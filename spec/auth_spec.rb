require 'auth'
require 'webmock/rspec'
include Auth

describe Auth do
  before do
    @auth = Authenticator.new
    Authenticator.class_variable_set(:@@token, nil)
  end

  describe "#authenticate" do
    it "returns the token if not nil" do
      Authenticator.class_variable_set(:@@token, "some-token")
      expect(@auth.authenticate).to eq("some-token")
    end

    it "should call #attempt_authentication if token is nil" do
      expect(@auth).to receive(:attempt_authentication)
      @auth.authenticate
    end

    it "should set the token from headers on a successful response" do
      stub_request(:head, "http://0.0.0.0:8888/auth").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'User-Agent'=>'Ruby'
           }).
         to_return(status: 200, body: "", headers: {"Badsec-Authentication-Token" => "some-token"})
      expect(@auth.authenticate).to eq("some-token")
    end

    it "should not set the token from headers on a failed response" do
      stub_request(:head, "http://0.0.0.0:8888/auth").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'User-Agent'=>'Ruby'
           }).
         to_return(status: 500, body: "", headers: {"Badsec-Authentication-Token" => "some-token"})
      @auth.authenticate
      expect(Authenticator.class_variable_get(:@@token)).to eq(nil)
    end
  end
end
