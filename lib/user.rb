module User
  def get_users(token)
    # Set the retry count to 0; we will try a max of 3 attempts
    retry_count = 0
    begin
      # Attempt to request a list of users from the API server
      users_request(token)
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

  private

  def users_request(token)
    # Make a request to the GET /users path of the API server
    uri = URI("http://0.0.0.0:8888/users")
    # Call build_request to include the necessary header data
    req = build_request(uri, token)
    res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
    if res.is_a?(Net::HTTPSuccess)
      # If the request is successful, print out the list of received users
      puts res.body
    else
      # If the request failed, return an exception with the error code
      return Exception.new("#{res.code}")
    end
  end

  def build_request(uri, token)
    # Build a new GET request with the given URI
    req = Net::HTTP::Get.new(uri)
    # Set the checksum header to the calculated checksum including the auth token and users path
    req['X-Request-Checksum'] = Digest::SHA256.hexdigest(token + "/users")
    # Return the built request
    req
  end
end
