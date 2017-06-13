import UIKit
import Foundation
import SQLite

class PeopleDatingProvider: Queryable {
    static let TABLE_NAME = "peopleDating"
    
    static let table = Table(TABLE_NAME)
    static let id = Expression<Int>("id")
    static let sexe = Expression<String>("sexe")
    static let lastname = Expression<String>("lastname")
    static let firstname = Expression<String>("firstname")
    static let dateOfBirth = Expression<Date>("dateOfBirth")
    static let note = Expression<Int>("note")
    static let picture = Expression<String?>("picture")
    
    typealias T = PeopleDating
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let _ = try DB.run(table.create(ifNotExists: true) {t in
                t.column(id, primaryKey: true)
                t.column(sexe)
                t.column(lastname)
                t.column(firstname)
                t.column(dateOfBirth)
                t.column(note)
                t.column(picture)
            
            })
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    static func insert(item: T) throws -> Int64? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        item.dateOfBirth = DatesUtils.setNoHoursToDate(date: item.dateOfBirth)
        
        if (item.lastname != nil && item.firstname != nil) {
            let insert = table.insert(sexe <- item.sexe, lastname <- item.lastname, firstname <- item.firstname, lastname <- item.lastname, dateOfBirth <- item.dateOfBirth, note <- item.note)
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
                try DB.run(query.update(sexe <- item.sexe, lastname <- item.lastname, firstname <- item.firstname, lastname <- item.lastname, dateOfBirth <- item.dateOfBirth, note <- item.note))
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
    
    static func find(idItem: Int) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(idItem == id)
        do {
            for row in try DB.prepare(query) {
                return PeopleDating(
                    id: row[id],
                    dateOfBirth: row[dateOfBirth],
                    firstname: row[firstname],
                    lastname: row[lastname],
                    sexe: row[sexe],
                    note: row[note])
            }
        } catch {
        }
        return nil
    }
    
    static func findBy(lastname: String, firstname: String, sexe: String, dateOfBirth: Date) throws -> Int? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(
            lastname == self.lastname &&
            firstname == self.firstname &&
            sexe == self.sexe &&
            dateOfBirth == self.dateOfBirth)
        do {
            for row in try DB.prepare(query) {
                return PeopleDating(
                    id: row[id],
                    dateOfBirth: row[self.dateOfBirth],
                    firstname: row[self.firstname],
                    lastname: row[self.lastname],
                    sexe: row[self.sexe],
                    note: row[self.note]).id
            }
        } catch {
        }
        return nil
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        var result = [PeopleDating]()
        let query = table.order(id);
        do {
            for row in try DB.prepare(query) {
                result.append(PeopleDating(
                    id: row[id],
                    dateOfBirth: row[dateOfBirth],
                    firstname: row[firstname],
                    lastname: row[lastname],
                    sexe: row[sexe],
                    note: row[note]))
            }
        } catch {
        }
        
        return result
    }
    
    static func addPicture(peopleDating:PeopleDating, picture:UIImage) throws -> Int? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let pd = table.filter(self.id == peopleDating.id!)
            let imageData:NSData = UIImagePNGRepresentation(picture)! as NSData
            let strBase64 = imageData.base64EncodedString()
            let update = pd.update([self.picture <- strBase64]
            )
            return try? DB.run(update)
        }catch {
            print(error)
        }
    }
    
    static func findPicture(peopleDating:PeopleDating) throws -> UIImage? {
        guard let DB = SQLiteDataStore.sharedInstance.db else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(self.id == peopleDating.id!)
        do {
            
            for row in try DB.prepare(query) {
                if let pictureFromDb = row[self.picture]{
                    let dataDecoded:NSData = NSData(base64Encoded: pictureFromDb, options: NSData.Base64DecodingOptions(rawValue: 0))!
                    let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                    return decodedimage
                }
            }
        } catch {
        }
        return nil
    }
}
