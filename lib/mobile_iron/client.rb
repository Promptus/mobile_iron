# encoding: utf-8
require 'faraday'
require 'oj'

module MobileIron
  class Client

    def initialize(url:, username:, password:, admin_device_space_id: '1')
      @url = url
      @username = username
      @password = password
      @admin_device_space_id = admin_device_space_id
    end

    def upload_inhouse_app(file_path:)
      with_connection do |connection|
        upload_io = Faraday::UploadIO.new(file_path, 'application/octet-stream')
        response = connection.post '/api/v2/appstore/inhouse', params('installer': upload_io)
        raise MobileIron::RequestError, "Failed to upload app '#{file_path}': #{response.status} #{response.body}" if response.status != 200
        Oj.load(response.body)
      end
    end

    def update_app_data(id:, data: {})
      with_connection do |connection|
        response = connection.post "/api/v2/appstore/apps/#{id}", params(data)
        raise MobileIron::RequestError, "Failed to update data of app '#{id}': #{response.status} #{response.body}" if response.status != 200
        Oj.load(response.body)
      end
    end

    protected

    def with_connection
      connection = Faraday.new(url: @url) do |f|
        f.request :multipart
        f.request :url_encoded
        f.adapter Faraday.default_adapter
        f.basic_auth @username, @password
      end
      yield connection
    end

    def params(extra_params)
      { 'adminDeviceSpaceId': @admin_device_space_id }.merge(extra_params)
    end

  end
end
