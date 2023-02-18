class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?,?)
    SQL
# Saves the instance to the database
    DB[:conn].execute(sql, self.name, self.album)
# Retrives the instane id and sets the id to the database id
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
# returns the intire instane instead of an empty array
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end