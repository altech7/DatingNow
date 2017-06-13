import UIKit

class Note {
    
    var id:Int?
    var note:String
    var dateOfSharing:Date
    var peopleDatingId:Int
    var clientId:Int
    var pseudo:String
    
    init(id:Int, note:String, peopleDatingId:Int, dateOfSharing:Date, clientId:Int, pseudo:String) {
        self.id = id
        self.note = note
        self.dateOfSharing = dateOfSharing
        self.peopleDatingId = peopleDatingId
        self.clientId = clientId
        self.pseudo = pseudo
    }
    
    init(note:String, peopleDatingId:Int, dateOfSharing:Date, clientId:Int, pseudo:String) {
        self.id = nil
        self.note = note
        self.dateOfSharing = dateOfSharing
        self.peopleDatingId = peopleDatingId
        self.clientId = clientId
        self.pseudo = pseudo
    }
}


