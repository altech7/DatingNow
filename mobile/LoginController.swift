import UIKit
import IDZSwiftCommonCrypto

class LoginController: UIViewController, LoginServiceDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var switchRemember: UISwitch!
    var client:Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBottomBorderOnly(on: inputEmail);
        applyBottomBorderOnly(on: inputPassword);
        self.navigationController?.navigationBar.isHidden = true;
        inputEmail.clearButtonMode = UITextFieldViewMode.whileEditing;
        inputPassword.clearButtonMode = UITextFieldViewMode.whileEditing;
        
        checkRememberUserCredentials()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //textUsername.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        return true
    }
    
    func checkRememberUserCredentials() {
        if UserDefaults.standard.string(forKey: "isRememberMe") != nil {
            let email = UserDefaults.standard.string(forKey: "email")
            let password = UserDefaults.standard.string(forKey: "password")
            self.inputEmail.text = email
            self.inputPassword.text = password
            self.switchRemember.isOn = true
        }
    }
    
    func updateRememberUserCredentials() {
        if self.switchRemember.isOn {
            UserDefaults.standard.set(self.inputEmail.text, forKey: "email")
            UserDefaults.standard.set(self.inputPassword.text, forKey: "password")
            UserDefaults.standard.set(true, forKey: "isRememberMe")
        } else {
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "isRememberMe")
        }
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
    
    func didFailed(error: String) {
        let this = self
        DispatchQueue.main.async {
            ViewsUtils.showPopup(title: "Identifiants incorects", message: "Veuillez saisir vos identifiants", controller: this)
        }
    }
    
    func didChallenged(challenge: String) {
        if let email = inputEmail?.text{
            AuthentificationServices.verifyChallenge(challenge: challenge, email: email, delegate: self);
        }
    }
    
    func challengeDidVerified(client: ClientJson) {
        self.client = Client(
            email: client.email,
            pseudo: client.pseudo,
            password: client.password,
            isRememberMe: self.switchRemember.isOn)
        
        setInfosUserApp(client: client) // Todo : remove static class ClientConnected (useless now)
        updateRememberUserCredentials()
        
        LoadingOverlay.shared.showOverlay(view:self.view)
        performSegue(withIdentifier: "toPeopleDatingListView", sender: self)
    }
    
    func setInfosUserApp(client:ClientJson) {
        ClientConnected.setEmail(email: client.email)
        ClientConnected.setPseudo(pseudo: client.pseudo)
        ClientConnected.setId(id: client.id!)
    }
    
    @IBAction func signin(_ sender: Any) {
        if ((inputEmail.text?.isEmpty)! || (inputPassword.text?.isEmpty)!) {
            ViewsUtils.showPopup(title: "Identifiants incorects", message: "Veuillez saisir vos identifiants", controller: self)
            return;
        }
        if ((inputEmail.text?.isEmpty)!) {
            ViewsUtils.showPopup(title: "Email incorect", message: "Veuillez réessayer", controller: self)
            return;
        }
        if ((inputPassword.text?.isEmpty)!) {
            ViewsUtils.showPopup(title: "Mot de passe incorect", message: "Veuillez réessayer", controller: self)
            return;
        }
        
        AuthentificationServices.getChallenge(email: inputEmail.text!, password: inputPassword.text!, delegate: self)
    }
}

