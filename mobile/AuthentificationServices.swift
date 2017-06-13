import SwiftHTTP
import JSONJoy

protocol LoginServiceDelegate {
    func didChallenged(challenge: String);
    func challengeDidVerified(client:ClientJson);
    func didFailed(error: String)
}

protocol SignupServiceDelegate {
    func didSignup(client: ClientJson)
    func didFailed(error: String)
}

class AuthentificationServices {
    
    struct Challenge : JSONJoy {
        let signature: String
        
        init(_ decoder: JSONDecoder) throws {
            signature = try decoder["signature"].get()
        }
    }
    
    static func signup(email:String, password:String, pseudo:String, delegate:SignupServiceDelegate) {
        do {
            let params = ["email": email, "pseudo": pseudo, "password": password]
            let opt = try HTTP.POST("http://localhost:5000/signup", parameters: params)
            
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
                    let client = try ClientJson(JSONDecoder(response.data))
                    if !client.pseudo.isEmpty {
                        DispatchQueue.main.async {
                            delegate.didSignup(client:client)
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
    
    static func getChallenge(email:String, password:String, delegate:LoginServiceDelegate){
        let params = ["email": email]
        do{
            let opt = try HTTP.POST("http://localhost:5000/getChallenge", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    DispatchQueue.main.async {
                        delegate.didFailed(error: "Une erreur est survenue")
                    }
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                if let dictionary = json as? [String: Any] {
                    if let randomkey = dictionary["randomString"] as? String{
                        let challenge = String(randomkey + email + password)?.md5()
                        delegate.didChallenged(challenge: challenge!)
                    }
                }
            }
        }catch{
            print(error)
        }
    }
    
    static func verifyChallenge(challenge:String, email:String, delegate:LoginServiceDelegate){
        let params = ["email": email, "challenge": challenge]
        do{
            let opt = try HTTP.POST("http://localhost:5000/verifyChallenge", parameters: params)
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    let json = try? JSONSerialization.jsonObject(with: response.data, options: [])
                    delegate.didFailed(error: "Une erreur est survenue")
                    return //also notify app of failure as needed
                }
                
                do {
                    let client = try ClientJson(JSONDecoder(response.data))
                    DispatchQueue.main.async {
                        delegate.challengeDidVerified(client: client)
                    }
                } catch {
                    print(error);
                }
            }
        }catch{
            print(error)
        }
        
    }
}
