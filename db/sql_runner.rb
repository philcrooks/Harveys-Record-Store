require('pg')

class SqlRunner
  DEBUG = false

  def SqlRunner.print_requests
    @@requests ||= []
    @@requests.each { | r | puts r }
  end
 
  def SqlRunner.clear_requests
    @@requests = []
  end

  def SqlRunner.requests
    @@requests ||= []
    return @@requests
  end

  def SqlRunner.run( sql )
    @@requests ||= []
    @@requests << sql if DEBUG
    begin
      db = PG.connect({ dbname: 'music_store', host: 'localhost' })
      result = db.exec( sql )
    ensure
      db.close() if db
    end
    return result
  end

end