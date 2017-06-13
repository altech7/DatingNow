import UIKit

class ViewsUtils: NSObject {

    static var refreshAlert = UIAlertController()
    
    static func showPopup(title:String, message:String, controller:UIViewController) {
        
            self.refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            self.refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            }))
        
            controller.present(self.refreshAlert, animated: true, completion: nil)
        }

}
