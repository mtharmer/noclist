module Auth
  class Authenticator
    @@token = nil

    def authenticate
      # Return the existing token if already authenticated; otherwise, attempt authentication
      @@token.nil? ? attempt_authentication : @@token
    end

    private

    def attempt_authentication
      # Set the retry count to 0; we will try a max of 3 attempts
      retry_count = 0
      begin
        # Attempt to request the auth token
        request_token
      rescue => err
        # On error, print to STDERR
        STDERR.puts "ERROR on Attempt #{retry_count}: #{err.message}"
        # If we have attempted less than 3 times, retry the authentication
        unless retry_count >= 2
          retry_count += 1
          retry
        end
        # If we have reached our max attempts, end the program with the given error
        raise err
      end
   end

    def request_token
      # TODO: Move the URL to an environment variable or config file
      # Make a request to the HEAD /auth path of the API server
      uri = URI("http://0.0.0.0:8888")
      res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.head('/auth') }
      if res.is_a?(Net::HTTPSuccess)
        # On success, set the auth token to the response's header field
        @@token = res['Badsec-Authentication-Token']
      else
        # On failure, return an exception containing the code received
        Exception.new("#{res.code}")
      end
    end
  end
end
