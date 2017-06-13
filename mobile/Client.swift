import UIKit

class Client {
    
    var id:Int?
    var email:String
    var pseudo:String
    var password:String
    var isRememberMe:Bool
    
    init(id:Int, email:String, pseudo:String, password:String, isRememberMe:Bool) {
        self.id = id
        self.email = email
        self.pseudo = pseudo
        self.password = password
        self.isRememberMe = isRememberMe
    }
    
    init(email:String, pseudo:String, password:String, isRememberMe:Bool) {
        self.id = nil
        self.email = email
        self.pseudo = pseudo
        self.password = password
        self.isRememberMe = isRememberMe
    }
}


