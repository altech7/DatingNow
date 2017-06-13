import SwiftHTTP
import JSONJoy

protocol NoteServiceDelegate {
    func didShared(note: NoteJson);
    func didFailed(error: String)
    func didFindedNotes(notes: Array<NoteJson>)
}

class NoteWebServices {
    
    static func sharedNote(note:Note, delegate:NoteServiceDelegate){
        do {
            let params = ["id" : String(describing: note.id), "dateOfSharing": DatesUtils.getDateToString(date: note.dateOfSharing).replacingOccurrences(of: " ", with: "-"), "note": note.note, "peopleDatingId": String(note.peopleDatingId), "clientId": String(note.clientId), "pseudo": note.pseudo]
            
            let opt = try HTTP.POST("http://localhost:5000/note/share", parameters: params)
            
            opt.start { response in
                if response.statusCode != HTTPStatusCode.ok.rawValue {
                    do {
                        let err = try ErrorJson(JSONDecoder(response.data))
                        if !err.message.isEmpty {
                            delegate.didFailed(error: err.message)
                        }
                    } catch {
                        print(error);
                    }
                }
                
                do {
                    let note = try NoteJson(JSONDecoder(response.data))
                    if !note.dateOfSharing.isEmpty {
                        DispatchQueue.main.async {
                            delegate.didShared(note: note)
                        }
                    }
                } catch {
                    print(error);
                }
            }
            
        } catch let error {
            print("got an error: \(error)")
        }
    }
    
    static func findAllByPeopleDating(peopleDatingId:Int, delegate:NoteServiceDelegate) {
        do {
            let opt = try HTTP.GET("http://localhost:5000/note/find/peopleDating/" + String(peopleDatingId))
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    DispatchQueue.main.async {
                        delegate.didFailed(error: err.localizedDescription);
                    }
                    return
                }
                
                do {
                    var collect = Array<NoteJson>()
                    var decoder = JSONDecoder(response.data);
                    if let arr = decoder.getOptionalArray() {
                        for decoder in arr {
                            try collect.append(NoteJson(decoder))
                        }
                    }
                    DispatchQueue.main.async {
                        delegate.didFindedNotes(notes: collect)
                    }
                } catch {
                    print(error);
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
        }
    }
}
