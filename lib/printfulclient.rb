##
#
# This class helps to use the Printful API
#
# version 1.0
# copyright 2014 Idea Bits LLC
#
##

require 'net/http'
require 'json'
require 'uri'

module PrintfulClientModule

	API_URL = 'https://api.theprintful.com/'
	USER_AGENT = 'Printful API Ruby Library 1.0'

    @api_key
    @last_response_raw
    @last_response


    # Initialize API library
    # key - Printful Store API key
    def initialize(key)
        @api_key = key
    end


	# Returns total available item count from the last request if it supports paging (e.g order list) or nil otherwise
	def item_count
		return last_response && last_response.key?('paging')  ? last_response['paging']['total'] : nil
	end

    # Perform a GET request to the API
    # path - Request path (e.g. 'orders' or 'orders/123')
    # params - Additional GET parameters as a hash
    def get(path, params=nil)
        request('GET', path, params)
    end


    # Perform a DELETE request to the API
    # path - Request path (e.g. 'orders' or 'orders/123')
    # params - Additional GET parameters as a hash
    def delete(path, params=nil)
        request('DELETE', path, params)
    end


    # Perform a POST request to the API
    # path - Request path (e.g. 'orders' or 'orders/123')
    # data - Request body data as a hash
    # params - Additional GET parameters as a hash
    def post(path, data=nil, params=nil)
        request('POST', path, params, data)
    end


    # Perform a PUT request to the API
    # path - Request path (e.g. 'orders' or 'orders/123')
    # data - Request body data as a hash
    # params - Additional GET parameters as a hash
    def put(path, data=nil, params=nil)
        request('PUT', path, params, data)
    end

    # Internal generic request wrapper
    def request (method, path, params=nil, data=nil)

        @last_response_raw = nil
        @last_response = nil

        uri = URI.join(API_URL, path)
        if params
            query = URI.encode_www_form(params)
            uri.query = query
        end

        body = data ? JSON.generate(data) : nil

        headers = {
            'User-Agent' => USER_AGENT
        }
        begin
            http = Net::HTTP.start(
                uri.host,
                uri.port,
                :use_ssl => uri.scheme=='https',
                :open_timeout => 10,
                :read_timeout => 20
            ) do |http|

                request = Net::HTTPGenericRequest.new(method,(body ? true : false), true, uri.request_uri ,headers)
                request.basic_auth @api_key, ''
                response = http.request(request, body)

                @last_response_raw = response.body

                begin
                    result = JSON.parse(response.body)
                    @last_response = result
                rescue JSON::ParserError
                    raise PrintfulException, "API response was not valid JSON"
                end

                if !result.key?('code') || !result.key?('result')
                  raise PrintfulException, "Invalid API response"
                end

                status = result['code']
                if status<200 || status >=300
                    raise PrintfulApiException.new(status), result['result']
                end

                result['result']
            end
        rescue PrintfulException
            raise
        rescue Exception => e
          raise PrintfulException, 'API request failed: ' + e.message
        end
    end

    private :request
    attr_accessor :last_response, :last_response_raw
end

class PrintfulClient
   include PrintfulClientModule
end

# Generic Printful exception
class PrintfulException < RuntimeError
end

# Printful exception returned from the API
class PrintfulApiException < PrintfulException
  def initialize(code)
    @code = code
  end
  attr_accessor :code
end