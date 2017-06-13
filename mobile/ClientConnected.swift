import UIKit

class ClientConnected {

    static var id:Int?
    static var email:String=""
    static var pseudo:String=""
    
    init() {
    }
    
    static func setId(id:Int) {
        self.id = id
    }
    
    static func setEmail(email:String) {
        self.email = email
    }
    
    static func setPseudo(pseudo:String) {
        self.pseudo = pseudo
    }

    static func getId() -> Int {
        return id!
    }
    
    static func getEmail() -> String {
        return email
    }
    
    static func getPseudo() -> String {
        return pseudo
    }
}
