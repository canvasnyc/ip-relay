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
        "#{alert['site']} #{alert['environment']} at #{alert['url']} is down: #{alert['message']}"
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
      puts "Ignoring alert: #{alert["id"]} #{alert["environment"]}"
      puts "Was already processed on: #{result.first[2]}"
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
    @db.execute "CREATE TABLE `alerts` (`id` TEXT, `environment` TEXT, `logged_at` TEXT)"
  end

  def log(alert)
    @db.execute "INSERT INTO `alerts` VALUES (\"#{alert["id"]}\", \"#{alert["environment"]}\", DATETIME('NOW'))"
  end

  def find(alert)
    @db.execute "SELECT * FROM `alerts` WHERE `id`=\"#{alert["id"]}\" AND `environment`=\"#{alert["environment"]}\" AND `logged_at` >= DATETIME('NOW', '#{lookback}') LIMIT 1"
  end
end