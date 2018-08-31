require 'rest-client'
require 'json'

module Watson
  module Assistant

    class Dialog      
      def initialize(config)
        auth = config[:auth]
        workspace_id = config[:workspace_id]
        region = config[:region] || "gateway.watsonplatform.net"

        url = "https://#{auth}@#{region}/assistant/api"
        version = "2018-09-20"
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

  end
end


