import UIKit
import Foundation
import SQLite

class NoteProvider: Queryable {
    static let TABLE_NAME = "note"
    
    static let table = Table(TABLE_NAME)
    static let id = Expression<Int>("id")
    static let isShared = Expression<Bool>("isShared")
    static let note = Expression<String>("note")
    static let dateOfSharing = Expression<Date>("dateOfSharing")
    static let peopleDatingId = Expression<Int>("peopleDating_Id")
    
    typealias T = Note
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let _ = try DB.run(table.create(ifNotExists: true) {t in
                t.column(id, primaryKey: true)
                t.column(note)
                t.column(dateOfSharing)
                t.column(peopleDatingId)
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
        
        let insert = table.insert(peopleDatingId <- item.peopleDatingId, note <- item.note, dateOfSharing <- item.dateOfSharing)
        do {
            let rowId = try DB.run(insert)
            guard rowId > 0 else {
                throw DataAccessError.Insert_Error
            }
            return rowId
        } catch _ {
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
                try DB.run(query.update(peopleDatingId <- item.peopleDatingId, note <- item.note, dateOfSharing <- dateOfSharing))
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
        
        let query = table.filter(idItem == peopleDatingId)
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
    
    static func findAllByPeopleDating(idItem: Int) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var result = [Note]()
        
        let query = table.filter(idItem == peopleDatingId)
        do {
            for row in try DB.prepare(query) {
                result.append(Note(
                    id: row[id],                    
                    note: row[note],
                    peopleDatingId: row[peopleDatingId],
                    dateOfSharing: row[dateOfSharing]))
            }
        } catch {
        }
        return result
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var result = [Note]()
        
        let query = table.order(id);
        do {
            for row in try DB.prepare(query) {
                result.append(Note(
                    id: row[id],
                    note: row[note],
                    peopleDatingId: row[peopleDatingId],
                    dateOfSharing: row[dateOfSharing]))
            }
        } catch {
        }
        return result
    }
    
    static func count() throws -> Int {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            return try DB.scalar(table.count)
        } catch {
        }
        
        return 0
    }
}
