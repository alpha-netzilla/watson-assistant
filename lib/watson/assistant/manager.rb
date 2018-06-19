require 'rest-client'
require "json"
require "watson/assistant/dialog"

module Watson
  module Assistant
    class Manager
      def initialize(config)
        storage = config[:storage] || "hash"
        @cnv = Dialog.new(
          config
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

  end
end
