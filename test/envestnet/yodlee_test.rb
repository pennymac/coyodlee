require 'test_helper'

class Envestnet::YodleeTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Envestnet::Yodlee::VERSION
  end

  def test_it_provides_a_setup_hook
    ::Envestnet::Yodlee.setup do |config|
      config.base_url = 'http://example.org'
      config.cobranded_username = 'yodlee_cobranded_username'
      config.cobranded_password = 'yodlee_cobranded_password'
    end

    assert_equal 'http://example.org', ::Envestnet::Yodlee.base_url
    assert_equal 'yodlee_cobranded_username', ::Envestnet::Yodlee.cobranded_username
    assert_equal 'yodlee_cobranded_password', ::Envestnet::Yodlee.cobranded_password
  end

  def test_cobrand_login_without_arguments
    ::Envestnet::Yodlee.setup do |config|
      config.base_url = "https://rest.developer.yodlee.com/services/srest/restserver/v1.0"
      config.cobranded_username = ENV['YODLEE_COBRAND_LOGIN']
      config.cobranded_password = ENV['YODLEE_COBRAND_PASSWORD']
    end

    VCR.use_cassette('cobrand_login_success') do
      response = ::Envestnet::Yodlee.cobrand_login

      assert_equal 200, response.code
    end
  end

  def test_cobrand_login_has_session_token
    ::Envestnet::Yodlee.setup do |config|
      config.base_url = "https://rest.developer.yodlee.com/services/srest/restserver/v1.0"
    end

    VCR.use_cassette('cobrand_login_success') do
      response = ::Envestnet::Yodlee.cobrand_login username: ENV['YODLEE_COBRAND_LOGIN'], password: ENV['YODLEE_COBRAND_PASSWORD']

      json = JSON.parse(response.body, symbolize_names: true)

      refute_empty json[:cobrandConversationCredentials][:sessionToken]
    end
  end

  def test_new_cobrand_login_without_arguments
    ::Envestnet::Yodlee.setup do |config|
      config.base_url = "https://developer.api.yodlee.com/ysl/restserver/v1"
      config.cobranded_username = ENV['YODLEE_COBRAND_LOGIN']
      config.cobranded_password = ENV['YODLEE_COBRAND_PASSWORD']
    end

    VCR.use_cassette('new_cobrand_login_success') do
      response = ::Envestnet::Yodlee.new_cobrand_login

      assert_equal 200, response.code
    end
  end

  def test_new_cobrand_login_without_parameters_returns_session_token
    ::Envestnet::Yodlee.setup do |config|
      config.base_url = "https://developer.api.yodlee.com/ysl/restserver/v1"
      config.cobranded_username = ENV['YODLEE_COBRAND_LOGIN']
      config.cobranded_password = ENV['YODLEE_COBRAND_PASSWORD']
    end

    VCR.use_cassette('new_cobrand_login_success') do
      response = ::Envestnet::Yodlee.new_cobrand_login

      json = JSON.parse(response.body, symbolize_names: true)

      refute_empty json[:session][:cobSession]
    end
  end

  def test_user_login
    ::Envestnet::Yodlee.setup do |config|
      config.base_url = "https://developer.api.yodlee.com/ysl/restserver/v1"
      config.cobranded_username = ENV['YODLEE_COBRAND_LOGIN']
      config.cobranded_password = ENV['YODLEE_COBRAND_PASSWORD']
    end

    cobrand_session = ''

    VCR.use_cassette('new_cobrand_login_success', allow_playback_repeats: true, allow_unused_http_interactions: true) do
      cobrand_response = ::Envestnet::Yodlee.new_cobrand_login
      cobrand_json = JSON.parse(cobrand_response.body, symbolize_names: true)
      cobrand_session = cobrand_json[:session][:cobSession]
    end

    VCR.use_cassette('user_login_success', record: :new_episodes) do
      username = ENV['YODLEE_USER_1_LOGIN_NAME']
      password = ENV['YODLEE_USER_1_PASSWORD']
      user_response = ::Envestnet::Yodlee.user_login username: username, password: password, cobrand_session: cobrand_session
      user_json = JSON.parse(user_response.body, symbolize_names: true)

      refute_empty user_json[:user][:session][:userSession]
    end
  end
end
