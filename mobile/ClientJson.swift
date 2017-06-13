import JSONJoy

class ClientJson : JSONJoy {
    
    var id:Int?
    var pseudo:String = ""
    var email:String = ""
    var password:String = ""
    
    required init(_ decoder: JSONDecoder) throws {
        id = try decoder["id"].get()
        pseudo = try decoder["pseudo"].get()
        email = try decoder["email"].get()
        password = try decoder["password"].get()
        
        //just an example of "checking" for a property.
        if let meta: String = decoder["meta"].getOptional() {
            print("found some meta info: \(meta)")
        }
    }
}
