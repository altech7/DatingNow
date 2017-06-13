import UIKit

protocol Queryable {
    associatedtype T
    
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64?
    static func update(item: T) throws -> Void
    static func delete(item: T) throws -> Void
    static func find(idItem: Int) throws -> T?
    static func findAll() throws -> [T]?
}
