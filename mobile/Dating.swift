import UIKit

class Dating {
    
    var id:Int?
    var dateOfDating:Date
    var note:String
    var peopleDating:PeopleDating
    
    init(id:Int, dateOfDating:Date, peopleDating:PeopleDating, note:String) {
        self.id = id
        self.dateOfDating = dateOfDating
        self.peopleDating = peopleDating
        self.note = note
    }
    
    init(dateOfDating:Date, peopleDating:PeopleDating, note:String) {
        self.id = nil
        self.dateOfDating = dateOfDating
        self.peopleDating = peopleDating
        self.note = note
    }
}


