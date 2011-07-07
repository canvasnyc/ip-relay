require File.expand_path('../ip-relay.rb', File.dirname(__FILE__))
Bundler.require(:test)
require 'test/unit'

ENV['RACK_ENV'] = 'test'

class TestBeanstalkIntegration < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_commit_no_bugs
    commit = File.read(File.expand_path('../examples/beanstalk/commit_no_bugs.json', File.dirname(__FILE__)))
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_commit_1_bug
    commit = File.read(File.expand_path('../examples/beanstalk/commit_1_bug.json', File.dirname(__FILE__)))
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_commit_1_bug_chat
    commit = File.read(File.expand_path('../examples/beanstalk/commit_1_bug_chat.json', File.dirname(__FILE__)))
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_commit_1_task
    commit = File.read(File.expand_path('../examples/beanstalk/commit_1_task.json', File.dirname(__FILE__)))
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_commit_1_bug_1_status
    commit = File.read(File.expand_path('../examples/beanstalk/commit_1_bug_1_status.json', File.dirname(__FILE__)))
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_commit_2_bugs_1_status
    commit = File.read(File.expand_path('../examples/beanstalk/commit_2_bugs_1_status.json', File.dirname(__FILE__)))
    post '/beanstalk/commit', params = {:commit => commit}
    assert last_response.ok?
  end

  def test_payload_no_bugs
    payload = File.read(File.expand_path('../examples/beanstalk/payload_no_bugs.json', File.dirname(__FILE__)))
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_1_bug
    payload = File.read(File.expand_path('../examples/beanstalk/payload_1_bug.json', File.dirname(__FILE__)))
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_1_bug_email
    payload = File.read(File.expand_path('../examples/beanstalk/payload_1_bug_email.json', File.dirname(__FILE__)))
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_1_bug_1_status
    payload = File.read(File.expand_path('../examples/beanstalk/payload_1_bug_1_status.json', File.dirname(__FILE__)))
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_2_bugs_1_status_2_tasks
    payload = File.read(File.expand_path('../examples/beanstalk/payload_2_bugs_1_status_2_tasks.json', File.dirname(__FILE__)))
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_1_bug_chat
    payload = File.read(File.expand_path('../examples/beanstalk/payload_1_bug_chat.json', File.dirname(__FILE__)))
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_too_large
    payload = File.read(File.expand_path('../examples/beanstalk/payload_too_large.json', File.dirname(__FILE__)))
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_1_bug_not_monitored
    payload = File.read(File.expand_path('../examples/beanstalk/payload_1_bug_not_monitored.json', File.dirname(__FILE__)))
    post '/beanstalk/payload', params = {:payload => payload}
    assert last_response.ok?
  end

end