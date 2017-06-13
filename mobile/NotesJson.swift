import JSONJoy

class NotesJson : JSONJoy {
    
    var notes:[Note]
    
    var id:Int?
    var peopleDatingId:Int
    var clientId:Int
    var note:String
    var dateOfSharing:String
    
    required init(_ decoder: JSONDecoder) throws {
        
        id = try decoder["id"].get()
        peopleDatingId = try decoder["peopleDatingId"].get()
        note = try decoder["note"].get()
        dateOfSharing = try decoder["dateOfSharing"].get()
        clientId = try decoder["clientId"].get()
        
        notes.append(Note(id: id!,
                          note: note,
                          peopleDatingId: <#T##Int#>,
                          dateOfSharing: DatesUtils dateOfSharing,
                          clientId: clientId)
        
        //just an example of "checking" for a property.
        if let meta: String = decoder["meta"].getOptional() {
            print("found some meta info: \(meta)")
        }
    }
}
