require 'rethinkdb'

class RethinkDBConnection

  attr_reader :conn, :matches_table_name

  include RethinkDB::Shortcuts

  def initialize
    @db_name = "dembele"
    @matches_table_name = "matches"

    @conn = r.connect(
      host: "localhost",
      port: 28015,
      db: @db_name
    )
    setup
  end

  private

  def create_db
    r.db_create(@db_name).run(@conn)
  rescue
    puts "DB already exists"
  end

  def create_tables
    r.table_create(@matches_table_name).run(@conn)
  rescue 
    'matches table already exists'
  end

  def setup
    create_db
    create_tables
  end

end

$rethinkdb = RethinkDBConnection.new