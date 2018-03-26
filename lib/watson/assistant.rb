require "watson/assistant/version"
require 'rest-client'
require "json"
require "thread"
require "redis"



module Watson
  module Assistant

    class Dialog      
      def initialize(username: "", password: "", workspace_id: "")
        url = "https://#{username}:#{password}@gateway.watsonplatform.net/conversation/api"
        version="2017-02-03"
        @endpoint = "#{url}/v1/workspaces/#{workspace_id}/message?version=#{version}"
      end

    
      def talk(question, context)
        if context == ""
          body = {}.to_json
        else
          body = {
            input: {
              text: question
            },
            alternate_intents: true,
            context: context,
          }.to_json
        end

        begin
          response = RestClient.post @endpoint, body, content_type: :json, accept: :json
          code = response.code
          body = JSON.parse(response.body)
        rescue RestClient::ExceptionWithResponse => e
          code = e.response.code
          body = JSON.parse(e.response.body)
        end
  
        return code, body
      end
    end



    class Redis < ::Redis
      def fetch(user)
        JSON.parse(get(user))
      end


      def store(user, data)
        set(user, data.to_json)
      end


      def delete(user)
        del(user)
      end


      def has_key?(user)
        exists(user) 
      end
    end


  
    class ManageDialog
      def initialize(username: "", password: "", workspace_id: "", storage: "hash")
        @cnv = Dialog.new(
          username: username,
          password: password,
          workspace_id: workspace_id
        )
      
        if storage == "hash"
          @users = Hash.new
        else
          @users = Redis.new(:url => storage)
        end
      end


      def users()
        @users
      end


      def has_key?(user) 
        @users.has_key?(user)
      end


      def delete(user)
        @users.delete(user)
      end


      def talk(user, question)
        future_data = nil

        if @users.has_key?(user) == false
          code, body = @cnv.talk("", "")
        else
          code, body = @cnv.talk(question, context = @users.fetch(user))
        end

        if code == 200
          context = body["context"]
          output = body["output"]["text"]
        else
          output = body["error"]
        end

        if code == 200
          @users.store(user, context)
        else
          @users.delete(user)
        end

        return {user: user, status_code: code, output: output}.to_json
      end
    end
  end
end
