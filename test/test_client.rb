require 'test_helper'
require 'moodle/client'

class ClientTest < Minitest::Test
  # Test initialization with hash
  def test_initialize_with_hash
    client = Moodle::Client.new({
      :username => 'test_username',
      :password => 'test_password',
      :domain   => 'test_domain',
      :protocol => 'test_protocol',
      :service => 'test_service',
      :format => 'test_format',
      :token => 'test_token'
    })

    assert_equal 'test_username', client.username
    assert_equal 'test_password', client.password
    assert_equal 'test_domain', client.domain
    assert_equal 'test_protocol', client.protocol
    assert_equal 'test_service', client.service
    assert_equal 'test_format', client.format
    assert_equal 'test_token', client.token
  end

  # Test obtaining a token
  def test_obtain_token
    RestClient.stubs(:get).returns('{"token" : "12345"}')
    moodle_client = Moodle::Client.new({:token => 'dummy', :domain => 'test'})
    assert_equal '12345', moodle_client.obtain_token()
  end

  describe "calling different methods from RestClient" do
    before do
      @client = Moodle::Client.new({
        :username => 'test_username',
        :password => 'test_password',
        :domain   => 'test_domain',
        :protocol => 'test_protocol',
        :service => 'test_service',
        :format => 'test_format',
        :token => 'test_token'
      })
    end
    it "calls get" do
      RestClient.stubs(:get).returns('{"method" : "get"}')
      expected = { 'method' => 'get' }
      @client.request(method: :get).must_equal expected
    end

    it "calls post" do
      RestClient.stubs(:post).returns('{"method" : "post"}')
      expected = { 'method' => 'post' }
      @client.request(method: :post).must_equal expected
    end

    it "calls delete" do
      RestClient.stubs(:delete).returns('{"method" : "delete"}')
      expected = { 'method' => 'delete' }
      @client.request(method: :delete).must_equal expected
    end
  end
end
