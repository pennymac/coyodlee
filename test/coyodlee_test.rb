require 'test_helper'

class CoyodleeTest < Minitest::Test

  def setup
    Coyodlee.setup do |config|
      config.host = "developer.api.yodlee.com"
      config.cobrand_login = ENV['YODLEE_COBRAND_LOGIN']
      config.cobrand_password = ENV['YODLEE_COBRAND_PASSWORD']
    end
  end

  def with_session(api, &block)
    session = Coyodlee::Session.create(api)

    VCR.use_cassette('cobrand_login_success', allow_playback_repeats: true) do
      cob_session.login login_name: Coyodlee.cobrand_login, password: Coyodlee.cobrand_password
      session.login_cobrand login_name: Coyodlee.cobrand_login,
                            password: Coyodlee.cobrand_password

    end

    VCR.use_cassette('user_login_success', allow_playback_repeats: true) do
      login_name = ENV['YODLEE_USER_1_LOGIN_NAME']
      password = ENV['YODLEE_USER_1_PASSWORD']
      session.login_user login_name: login_name,
                         password: password
    end

    block.call(api)
  end

  def test_that_it_has_a_version_number
    refute_nil Coyodlee::VERSION
  end

  def test_it_provides_a_setup_hook
    Coyodlee.setup do |config|
      config.host = 'example.org'
      config.cobrand_login = 'yodlee_cobranded_username'
      config.cobrand_password = 'yodlee_cobranded_password'
    end

    assert_equal 'example.org', Coyodlee.host
    assert_equal 'yodlee_cobranded_username', Coyodlee.cobrand_login
    assert_equal 'yodlee_cobranded_password', Coyodlee.cobrand_password
  end

  # def test_user_details
  #   with_session_tokens do |cobrand_session, user_session|
  #     VCR.use_cassette('user_details_success') do
  #       client = ::Envestnet::Yodlee::Client.new(user_session)
  #       response = client.get_user_details
  #       user_json = JSON.parse(response.body, symbolize_names: true)

  #       refute_empty user_json[:user]
  #       refute_empty user_json[:user][:preferences]
  #       refute_empty user_json[:user][:email]
  #       refute_empty user_json[:user][:name]
  #       refute_empty user_json[:user][:loginName]
  #     end
  #   end
  # end

  # def test_providers
  #   with_session_tokens do |cobrand_session, user_session|
  #     VCR.use_cassette('providers_success') do
  #       client = Coyodlee::Client.new(user_session)
  #       response = client.get_providers
  #       providers_json = JSON.parse(response.body, symbolize_names: true)

  #       refute_empty providers_json[:provider]
  #     end
  #   end
  # end

  # def test_accounts
  #   with_session_tokens do |cobrand_session, user_session|
  #     VCR.use_cassette('accounts_success') do
  #       client = Coyodlee::Client.new(user_session)
  #       response = client.get_accounts
  #       accounts_json = JSON.parse(response.body, symbolize_names: true)

  #       refute_empty accounts_json[:account]
  #     end
  #   end
  # end
end
