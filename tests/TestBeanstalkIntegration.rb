Dir.chdir '../'
require 'rubygems'
require 'sinatra'
require 'ip-relay'
require 'json'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class TestBeanstalkIntegration < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_commit_no_bugs
    commit = File.read('examples/beanstalk/commit_no_bugs.json')
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_commit_1_bug
    commit = File.read('examples/beanstalk/commit_1_bug.json')
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_commit_1_bug_1_status
    commit = File.read('examples/beanstalk/commit_1_bug_1_status.json')
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_commit_2_bugs_1_status
    commit = File.read('examples/beanstalk/commit_2_bugs_1_status.json')
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_payload_no_bugs
    payload = File.read('examples/beanstalk/payload_no_bugs.json')
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_1_bug
    payload = File.read('examples/beanstalk/payload_1_bug.json')
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_1_bug_1_status
    payload = File.read('examples/beanstalk/payload_1_bug_1_status.json')
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_2_bugs_1_status
    payload = File.read('examples/beanstalk/payload_2_bugs_1_status.json')
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_too_large
    payload = File.read('examples/beanstalk/payload_too_large.json')
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

end