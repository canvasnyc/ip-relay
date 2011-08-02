class SCM

  def self.strip_commands(message)
    message.gsub(/\[(.*?)\]/, '').rstrip
  end

  def initialize(name)
    @db_file = File.join(settings.db_path, name + '.db')
  end

  def is_logged?(commit)
    db_exists? ? db_open : db_create
    result = find commit
    if result.empty?
      log commit
      false
    else
      puts "*" * 79
      puts "Ignoring commit: #{commit["id"]}"
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
    @db.execute "CREATE TABLE `commits` (`id` TEXT PRIMARY KEY, `logged_at` TEXT)"
  end

  def log(commit)
    @db.execute "INSERT INTO `commits` VALUES (\"#{commit["id"]}\", DATETIME('NOW'))"
  end

  def find(commit)
    @db.execute "SELECT * from `commits` where `id`=\"#{commit["id"]}\" LIMIT 1"
  end
end