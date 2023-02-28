require "rest-client"
require "json"
require "jwt"

module PayWithExtend
  class Client
    class ResponseError < StandardError; end

    attr_accessor :api_token

    def initialize
      # Singin
      self.refresh_token
    end

    def refresh_token
      request_body = {
        email: PayWithExtend.configuration.account_email,
        password: PayWithExtend.configuration.account_password,
      }
      post("/signin", request_body)
    end

    def post(endpoint, body, token = nil)
      endpoint_url = "#{PayWithExtend.configuration.base_url}#{endpoint}"
      headers = {
        "Content-Type" => "application/json",
        "Accept" => PayWithExtend.configuration.api_version,
      }
      headers["Authorization"] = "Bearer #{token}" if !token.nil?
      begin
        response = RestClient::Request.execute(method: :post, url: endpoint_url, payload: body.to_json, headers: headers)
        if endpoint === "/signin"
          result = JSON.parse(response.body)
          @api_token = result["token"] if !result["token"].blank?
          return "Token refreshed"
        else
          JSON.parse(response.body)
        end
      rescue RestClient::ExceptionWithResponse => exception
        JSON.parse(exception.response.body)
      rescue JSON::ParserError => exception
        puts exception.response
      rescue RestClient::Unauthorized, RestClient::Forbidden => exception
        puts exception.response
      end
    end

    def get(endpoint, token = nil, secured = false)
      endpoint_url = secured ? "#{PayWithExtend.configuration.secure_base_url}#{endpoint}" : "#{PayWithExtend.configuration.base_url}#{endpoint}"
      headers = {
        "Content-Type" => "application/json",
        "Accept" => PayWithExtend.configuration.api_version,
      }
      headers["Authorization"] = "Bearer #{token}" if !token.nil?
      begin
        response = RestClient::Request.execute(method: :get, url: endpoint_url, headers: headers)
        JSON.parse(response.body)
      rescue RestClient::ExceptionWithResponse => exception
        JSON.parse(exception.response.body)
      rescue JSON::ParserError => exception
        puts exception.response
      rescue RestClient::Unauthorized, RestClient::Forbidden => exception
        puts exception.response
      end
    end

    def get_virtual_card(card_id)
      get("/virtualcards/#{card_id}", @api_token, false)
    end

    def get_secured_virtual_card(card_id)
      get("/virtualcards/#{card_id}", @api_token, true)
    end

    def create_virtual_card(params)
      post("/virtualcards", params, @api_token)
    end
  end
end
