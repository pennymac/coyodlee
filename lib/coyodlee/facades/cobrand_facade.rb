class CobrandFacade
  def initialize(request_facade)
    @request_facade = request_facade
  end

  def login(login_name:, password:)
    body = {
      cobrand: {
        cobrandLogin: login_name,
        cobrandPassword: password,
        locale: 'en_US'
      }
    }.to_json
    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    req = @request_facade.build(:post, 'cobrand/login', headers: headers, body: body)
    @request_facade.execute(req)
  end

  def logout
    req = @request_facade.build(:post, 'cobrand/logout')
    @request_facade.execute(req)
  end

  def public_key
    req = @request_facade.build(:get, 'cobrand/publicKey')
    @request_facade.execute(req)
  end
end
