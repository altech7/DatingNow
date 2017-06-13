import JSONJoy

class NoteJson : JSONJoy {
    
    //var id:Int?
    var peopleDatingId:Int
    var clientId:Int
    var note:String
    var dateOfSharing:String
    var pseudo:String
    
    required init(_ decoder: JSONDecoder) throws {
        note = try decoder["note"].get()
        dateOfSharing = try decoder["dateOfSharing"].get()
        clientId = try decoder["clientId"].get()
        pseudo = try decoder["pseudo"].get()
        peopleDatingId = try decoder["peopleDatingId"].get()
        
        //just an example of "checking" for a property.
        if let meta: String = decoder["meta"].getOptional() {
            print("found some meta info: \(meta)")
        }
    }
}
