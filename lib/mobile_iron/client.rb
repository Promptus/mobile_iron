# encoding: utf-8
require 'faraday'
require 'oj'
require 'logger'

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
        params = { 'installer': Faraday::UploadIO.new(file_path, 'application/octet-stream') }
        response = connection.post '/api/v2/appstore/inhouse', params.merge(admin_device_space_param)
        raise MobileIron::RequestError, "Failed to upload app '#{file_path}': #{response.status} #{response.body}" if response.status != 200
        Oj.load(response.body)
      end
    end

    def update_app_data(id:, data: {}, icon_file_path: nil)
      with_connection do |connection|
        params = { 'appData': data.to_json }
        params['icon'] = Faraday::UploadIO.new(icon_file_path, 'image/png') if icon_file_path
        response = connection.post "/api/v2/appstore/apps/#{id}", params.merge(admin_device_space_param), { 'Content-Type': 'multipart/form-data' }
        raise MobileIron::RequestError, "Failed to update data of app '#{id}': #{response.status} #{response.body}" if response.status != 200
        Oj.load(response.body)
      end
    end

    protected

    def with_connection
      connection = Faraday.new(url: @url) do |f|
        f.request :multipart
        # f.response :logger, ::Logger.new(STDOUT), bodies: true
        f.basic_auth @username, @password
        f.adapter :net_http
      end
      yield connection
    end

    def admin_device_space_param
      { 'adminDeviceSpaceId': @admin_device_space_id }
    end

  end
end
