import UIKit
import Foundation
import SQLite

class DatingProvider: Queryable {
    static let TABLE_NAME = "dating"
    
    static let table = Table(TABLE_NAME)
    static let id = Expression<Int>("id")
    static let note = Expression<String>("note")
    static let dateOfDating = Expression<Date>("dateOfBirth")
    static let peopleDatingFK = Expression<Int>("peopleDating_id")
    
    typealias T = Dating
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let _ = try DB.run(table.create(ifNotExists: true) {t in
                t.column(id, primaryKey: true)
                t.column(dateOfDating)
                t.column(note)
                t.column(peopleDatingFK)
                t.foreignKey(peopleDatingFK, references: PeopleDatingProvider.table, PeopleDatingProvider.id)
            })
        } catch {
            // Error throw if table already exists
            print(error);
            print("Tables already exists")
        }
    }
    
    static func insert(item: T) throws -> Int64? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let insert = table.insert(peopleDatingFK <- item.peopleDating.id!, dateOfDating <- item.dateOfDating, note <- item.note)
        do {
            let rowId = try DB.run(insert)
            guard rowId > 0 else {
                throw DataAccessError.Insert_Error
            }
            return rowId
        } catch {
            print(error)
            throw DataAccessError.Insert_Error
        }
        
        throw DataAccessError.Nil_In_Data
    }
    
    static func update(item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        if let idItem = item.id {
            let query = table.filter(idItem == id)
            do {
                try DB.run(query.update(peopleDatingFK <- item.peopleDating.id!, dateOfDating <- item.dateOfDating, note <- item.note))
                return
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
        
        throw DataAccessError.Nil_In_Data
    }
    
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        if let idItem = item.id {
            let query = table.filter(idItem == id)
            do {
                try DB.run(query.delete())
            } catch _ {
                throw DataAccessError.Delete_Error
            }
        }
    }
    
    static func deleteByPeopleDatingId (idItem: Int) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(idItem == peopleDatingFK)
        do {
            try DB.run(query.delete())
        } catch {
        }
    }
    
    static func find(idItem: Int) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        /*
         let query = table.filter(idItem == id)
         do {
         for row in try DB.prepare(query) {
         return Dating(id: row[id], dateOfDating: row[dateOfDating], peopleDating: row[peopleDating], secondPeople: row[secondPeople])
         }
         } catch {
         }
         */
        return nil
    }
    
    static func findAllByPeopleDating(peopleDatingId: Int) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var result = [Dating]()
        
        let query = table.filter(peopleDatingId == self.peopleDatingFK)
        do {
            for row in try DB.prepare(query) {
                result.append(Dating(
                    id: row[id],
                    dateOfDating: row[dateOfDating],
                    peopleDating: try PeopleDatingProvider.find(idItem: row[peopleDatingFK])!,
                    note: row[note]))
            }
        } catch {
        }
        return result
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var result = [Dating]()
        
        let query = table.order(id);
        do {
            for row in try DB.prepare(query) {
                result.append(Dating(
                    id: row[id],
                    dateOfDating: row[dateOfDating],
                    peopleDating: try PeopleDatingProvider.find(idItem: row[peopleDatingFK])!,
                    note: row[note]))
            }
        } catch {
        }
        return result
    }
}
