module Auth
  class Authenticator
    @@token = nil

    def authenticate
      @@token.nil? ? attempt_authentication : @@token
    end

    private

    def attempt_authentication
     retry_count = 0
     begin
       request_token
     rescue => err
       STDERR "ERROR on Attempt #{retry_count}: #{err.message}"
       unless retry_count >= 2
         retry_count += 1
         retry
       end
       raise
     else
       @@token
     end
   end

    def request_token
      uri = URI("http://0.0.0.0:8888")
      res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.head('/auth') }
      @@token = res['Badsec-Authentication-Token'] if res.is_a?(Net::HTTPSuccess)
    end
  end
end
