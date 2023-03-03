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

    def put(endpoint, body, token = nil)
      endpoint_url = "#{PayWithExtend.configuration.base_url}#{endpoint}"
      headers = {
        "Content-Type" => "application/json",
        "Accept" => PayWithExtend.configuration.api_version,
      }
      headers["Authorization"] = "Bearer #{token}" if !token.nil?
      begin
        response = RestClient::Request.execute(method: :put, url: endpoint_url, payload: body.to_json, headers: headers)
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
      get("/virtualcards/#{card_id}", @api_token)
    end

    def get_secured_virtual_card(card_id)
      get("/virtualcards/#{card_id}", @api_token, true)
    end

    def create_virtual_card(params)
      post("/virtualcards", params, @api_token)
    end

    def cancel_virtual_card(card_id)
      put("/virtualcards/#{card_id}/cancel", {}, @api_token)
    end

    def cancel_virtual_card_update_request(card_id)
      put("/virtualcards/#{card_id}/cancelupdate", {}, @api_token)
    end

    def update_virtual_card(card_id, params)
      put("/virtualcards/#{card_id}", params, @api_token)
    end

    def reject_virtual_card(card_id)
      put("/virtualcards/#{card_id}/reject", {}, @api_token)
    end

    def update_virtual_card_customer_support_code(card_id, params)
      put("/virtualcards/#{card_id}/supportcode", params, @api_token)
    end

    def get_virtual_card_transactions(card_id)
      get("/virtualcards/#{card_id}/transactions", @api_token)
    end

    # Source Credit Card
    def get_credit_card
      get("/creditcards/#{card_id}", @api_token)
    end
  end
end
