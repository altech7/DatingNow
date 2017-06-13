import JSONJoy

class ErrorJson: NSObject {
    let message: String
    
    init(_ decoder: JSONDecoder) throws {
        message = try decoder["error"].get()
        
        if let meta: String = decoder["meta"].getOptional() {
            print("found some meta info: \(meta)")
        }
    }
}
