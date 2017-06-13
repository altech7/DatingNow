import UIKit

class AddDatingController: UIViewController {

    var datingToEdit:Dating?
    var peopleDatingAssociated:PeopleDating?
    var mode:ModeForm = ModeForm.ADD
    @IBOutlet weak var inputNote: UITextField!
    @IBOutlet weak var labelPeopleDatingAssociated: UILabel!
    @IBOutlet weak var datePickerDateOfDating: UIDatePicker!
    var cancelButton: UIBarButtonItem!
    var validButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.validButton = UIBarButtonItem(
            title: (mode == .ADD ? "Ajouter" : "Editer"),
            style: .plain,
            target: self,
            action: #selector(mergePeopleDating(sender:))
        )
        self.cancelButton = UIBarButtonItem(
            title: ("Annuler"),
            style: .plain,
            target: self,
            action: #selector(backToList(sender:))
        )
        
        if mode == .EDIT {
            self.populateForm(dating: datingToEdit!)
        } else {
            labelPeopleDatingAssociated.text = (self.peopleDatingAssociated?.lastname)! + " " + (self.peopleDatingAssociated?.firstname)!
        }
    
        datePickerDateOfDating.setValue(UIColor.white, forKey: "textColor")
        applyBottomBorderOnly(on: inputNote);
        navigationItem.rightBarButtonItems = [validButton];
        navigationItem.leftBarButtonItems = [cancelButton];
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    func mergePeopleDating(sender: UIBarButtonItem) {
        do {
            switch mode {
            case .ADD:
                let dating = Dating(dateOfDating: datePickerDateOfDating.date, peopleDating: self.peopleDatingAssociated!, note: inputNote.text!)
                try  DatingProvider.insert(item: dating)
                break
            case .EDIT:
                datingToEdit?.dateOfDating = datePickerDateOfDating.date
                datingToEdit?.note = inputNote.text!
                try  DatingProvider.update(item: datingToEdit!)
                break
            }
        } catch {
            print(error)
            return;
        }
        performSegue(withIdentifier: "fromAddFormDatingToDetailsPleopleDating", sender: self)
    }
    
    func backToList(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "fromAddFormDatingToDetailsPleopleDating", sender: self)
    }
    
    func populateForm(dating:Dating) {
        datePickerDateOfDating.date = dating.dateOfDating
        labelPeopleDatingAssociated.text = (dating.peopleDating.lastname) + " " + (dating.peopleDating.firstname)
        inputNote.text = dating.note
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
}
