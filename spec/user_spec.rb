require 'user'

include User

def capture(&block)
    begin
      $stdout = StringIO.new
      $stderr = StringIO.new
      yield
      result = {}
      result[:stdout] = $stdout.string
      result[:stderr] = $stderr.string
    ensure
      $stdout = STDOUT
      $stderr = STDERR
    end
    result
  end

describe User do
  describe "#get_users" do
    it "should attempt to call #users_request with provided token" do
      stub_request(:get, "http://0.0.0.0:8888/users").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Host'=>'0.0.0.0:8888',
       	  'User-Agent'=>'Ruby',
           }).
         to_return(status: 500, body: "{}", headers: {})
      expect(User).to receive(:users_request)
      User.get_users("some-token")
    end

    it "should log results in a list upon success" do
      stub_request(:get, "http://0.0.0.0:8888/users").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Host'=>'0.0.0.0:8888',
       	  'User-Agent'=>'Ruby',
           }).
         to_return(status: 200, body: "sometoken\nanothertoken", headers: {})
      result = capture { User.get_users("some-token") }
      expect(result[:stdout]).to include("sometoken\nanothertoken")
    end
  end
end
