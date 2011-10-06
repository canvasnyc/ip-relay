post '/downtime' do
  puts "=" * 79
  puts "Downtime alert received at #{Time.now}"
  puts request.body.read
  alert = JSON.parse params[:alert]
  commands = []
  downtime = Downtime.new 'downtime'
  unless downtime.is_logged?(alert)
    commands = interpret alert["commands"]
    commands.each do |command|
      command[:origin] = {
        :name => "Downtime",
        :alert => alert
      }
      command[:args][:comment] =
        "#{alert['site']} #{alert['environment']['name']} at #{alert['environment']['url']} failed checkup: #{alert['url']}"
    end
  end
  respond execute commands
end

class Downtime

  def lookback
    '-1 HOUR'
  end

  def initialize(name)
    @db_file = File.join(settings.db_path, name + '.db')
  end

  def is_logged?(alert)
    db_exists? ? db_open : db_create
    result = find alert
    if result.empty?
      log alert
      false
    else
      puts "*" * 79
      puts "Ignoring alert for environment id ##{alert['environment']['id']}"
      puts "Was already processed on: #{result.first[1]}"
      puts "*" * 79
      true
    end
  end

 private

  def db_exists?
    File.exist? @db_file
  end

  def db_open
    @db = SQLite3::Database.new @db_file
  end

  def db_create
    db_open
    @db.execute "CREATE TABLE `alerts` (`environment_id` INTEGER, `logged_at` TEXT)"
  end

  def log(alert)
    @db.execute "INSERT INTO `alerts` VALUES (\"#{alert['environment']['id']}\", DATETIME('NOW'))"
  end

  def find(alert)
    @db.execute "SELECT * FROM `alerts` WHERE `environment_id`=\"#{alert['environment']['id']}\" AND `logged_at` >= DATETIME('NOW', '#{lookback}') LIMIT 1"
  end
end