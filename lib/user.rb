module User
  def get_users(token)
    retry_count = 0
    begin
      res = users_request(token)
    rescue => err
      STDERR "ERROR on Attempt #{retry_count}: #{err.message}"
      unless retry_count >= 2
        retry_count += 1
        retry
      end
      raise
    else
      puts res.body
    end
  end

  private

  def users_request(token)
    uri = URI("http://0.0.0.0:8888/users")
    req = build_request(uri, token)
    Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
  end

  def build_request(uri, token)
    req = Net::HTTP::Get.new(uri)
    req['X-Request-Checksum'] = Digest::SHA256.hexdigest(token + "/users")
    # req['Content-Type'] = 'application/json'
    req
  end
end
