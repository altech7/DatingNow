import Foundation
import SQLite

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    var db: Connection?
    
    func isConnected() -> Bool {
        return db != nil
    }
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        do {
            try db = Connection("\(path)/datingnow.db")
            try db?.execute("PRAGMA foreign_keys = ON")
        } catch {
            db = nil
        }
    }
    
    func createTables() throws{
        do {
            // Create tables here...
            try PeopleDatingProvider.createTable()
            try DatingProvider.createTable()            
            //try ClientProvider.createTable()
        } catch {
            throw DataAccessError.Datastore_Connection_Error
        }
    }
}
