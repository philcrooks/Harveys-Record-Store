require('pg')

class SqlRunner

  def SqlRunner.requests
    @@requests ||= []
    return @@requests
  end

  def SqlRunner.run( sql )
    @@requests ||= []
    @@requests << sql
    begin
      db = PG.connect({ dbname: 'music_store', host: 'localhost' })
      result = db.exec( sql )
    ensure
      db.close
    end
    return result
  end

end