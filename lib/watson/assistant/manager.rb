require 'rest-client'
require "json"
require "watson/assistant/dialog"

module Watson
  module Assistant
    class Manager
      def initialize(config)
        @config = config
        check = check_config()

        if check == true
          create_dialog()
          prepare_storage()
        end

      end

      def create_dialog
        @dlg = Dialog.new(
          @config
        )
      end


      def prepare_storage
        storage = @config[:storage] || "hash"
        if storage == "hash"
          @users = Hash.new
        else
          @users = Redis.new(:url => storage)
        end
      end


      def check_config()
        if @config[:apikey]
          if @config[:username] || @config[:password]
            puts "Error: 'Both API key' and 'Username/Password' are used"
            return false
          end
          @config[:auth] = "apikey:#{@config[:apikey]}"

        elsif @config[:username] && @config[:password]
          @config[:auth] = "#{@config[:username]}:#{@config[:password]}"

        else
          puts "Error: Not authorized"
          return false
        end

        return true
      end


      def has_dlg?
        return @dlg
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
          code, body = @dlg.talk("", "")
        else
          code, body = @dlg.talk(question, context = @users.fetch(user))
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


      def read_context(user:)
        context = @users.fetch(user)
      end


      def read_context_section(user:, key:)
        context = @users.fetch(user)
        return context[key]
      end


      def update_context_section(user:, key:, value:)
        context = @users.fetch(user)
        context[key] = value
        @users.store(user, context)
				return context
      end


      def delete_context_section(user:, key:)
        context = @users.fetch(user)
        context.delete(key)
        @users.store(user, context)
				return context
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
