import UIKit

class SignupController: UIViewController, SignupServiceDelegate {

    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var inputPseudo: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    var client:Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBottomBorderOnly(on: inputEmail);
        applyBottomBorderOnly(on: inputPseudo);
        applyBottomBorderOnly(on: inputPassword);
        inputEmail.clearButtonMode = UITextFieldViewMode.whileEditing;
        inputPassword.clearButtonMode = UITextFieldViewMode.whileEditing;
    }
    
    func applyBottomBorderOnly(on uiControl: UIControl){
        var border:CALayer = CALayer()
        var borderWidth:CGFloat = 1
        border.borderColor = UIColor.white.cgColor;
        border.frame = CGRect(x: 0, y: uiControl.frame.size.height - borderWidth, width: uiControl.frame.size.width, height: uiControl.frame.size.height);
        border.borderWidth = borderWidth;
        uiControl.layer.addSublayer(border)
        uiControl.layer.masksToBounds = true;
        
    }
    
    @IBAction func signup(_ sender: Any) {
        if ((inputEmail.text?.isEmpty)!) {
            ViewsUtils.showPopup(title: "Email incorect", message: "Veuillez saisir un email", controller: self)
            return;
        }
        if ((inputPseudo.text?.isEmpty)!) {
            ViewsUtils.showPopup(title: "Pseudo incorect", message: "Veuillez saisir un pseudo", controller: self)
            return;
        }
        if ((inputPassword.text?.isEmpty)!) {
            ViewsUtils.showPopup(title: "Mot de passe incorect", message: "Veuillez saisir un mot de passe", controller: self)
            return;
        }
        
        AuthentificationServices.signup(email: inputEmail.text!, password: inputPassword.text!, pseudo: inputPseudo.text!, delegate: self)
    }
    
    func didSignup(client:ClientJson) {
        performSegue(withIdentifier: "toLoginView", sender: self)
    }
    
    func didFailed(error: String) {
        let this = self;
        DispatchQueue.main.async {
            ViewsUtils.showPopup(title: "L'inscription a échouée", message: "Cet utilisateur est déjà existant", controller: this)            
        }
    }
}
