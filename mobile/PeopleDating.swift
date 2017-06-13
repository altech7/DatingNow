import UIKit

class PeopleDating {
    
    var id:Int?
    var dateOfBirth:Date
    var firstname:String
    var lastname:String
    var sexe:String
    var note:Int
    var picture:String?
    
    init(id:Int, dateOfBirth:Date, firstname:String, lastname:String, sexe:String, note:Int) {
        self.id = id
        self.dateOfBirth = dateOfBirth
        self.firstname = firstname
        self.lastname = lastname
        self.sexe = sexe
        self.note = note
        self.picture = nil
    }
    
    init(dateOfBirth:Date, firstname:String, lastname:String, sexe:String, note:Int) {
        self.id = nil
        self.dateOfBirth = dateOfBirth
        self.firstname = firstname
        self.lastname = lastname
        self.sexe = sexe
        self.note = note
        self.picture = nil
    }
}


