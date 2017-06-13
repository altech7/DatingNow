import UIKit
import Foundation
import SQLite

class ClientProvider: Queryable {
    static let TABLE_NAME = "client"
    
    static let table = Table(TABLE_NAME)
    static let id = Expression<Int>("id")
    static let email = Expression<String>("email")
    static let pseudo = Expression<String>("pseudo")
    static let password = Expression<String>("password")
    static let isRememberMe = Expression<Bool>("isRememberMe")
    
    typealias T = Client
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let _ = try DB.run(table.create(ifNotExists: true) {t in
                t.column(id, primaryKey: true)
                t.column(pseudo)
                t.column(email)
                t.column(password)
                t.column(isRememberMe)
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
        
        let insert = table.insert(email <- item.email, pseudo <- item.pseudo, password <- item.password, isRememberMe <- item.isRememberMe)
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
        
        let query = table.filter(email == item.email && password == item.password)
        do {
            try DB.run(query.update(email <- item.email, pseudo <- item.pseudo, password <- item.password, isRememberMe <- item.isRememberMe))
            return
        } catch _ {
            throw DataAccessError.Delete_Error
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
    
    static func findByEmailAndPassword(email: String, password:String) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(email == self.email && password == self.password)
        do {
            for row in try DB.prepare(query) {
                return Client(
                    email: row[self.email],
                    pseudo: row[self.pseudo],
                    password: row[self.password],
                    isRememberMe: row[self.isRememberMe])
            }
        } catch {
        }
        
        return nil
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var result = [Client]()
        
        let query = table.order(id);
        do {
            for row in try DB.prepare(query) {
                result.append(Client(
                    email: row[email],
                    pseudo: row[pseudo],
                    password: row[password],
                    isRememberMe: row[isRememberMe]))
            }
        } catch {
        }
        return result
    }
}
