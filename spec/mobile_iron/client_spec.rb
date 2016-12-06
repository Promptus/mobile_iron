# encoding: utf-8
require 'spec_helper'

describe MobileIron::Client do

  describe "#upload_inhouse_app" do

    let(:client) do
      MobileIron::Client.new(url: 'https://mobile_iron_host', username: 'user', password: 'pass')
    end
    let(:response_body) { api_response_json(filename: 'upload_inhouse_app.json') }
    let(:response_status) { 200 }
    let(:ipa_file_path) { File.join('spec', 'files', 'test.ipa') }

    before do
      stub_request(:post, mobile_iron_url(path: "appstore/inhouse")).to_return(status: response_status, body: response_body)
    end

    it 'returns the data of the uploaded app' do
      res = client.upload_inhouse_app(file_path: ipa_file_path)
      expect(res['results']['id']).to eql(952)
    end

    context 'file does not exist' do

      it 'raises a error' do
        expect { client.upload_inhouse_app(file_path: 'invalid path') }.to raise_error(Errno::ENOENT)
      end
    end

    context 'failed upload' do
      
      let(:response_body) { "Error" }
      let(:response_status) { 500 }

      it 'raises a RequestError error' do
        expect { client.upload_inhouse_app(file_path: ipa_file_path) }.to raise_error(MobileIron::RequestError)
      end

    end

  end

  describe "#update_app_data" do

  end
end
