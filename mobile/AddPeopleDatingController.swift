import UIKit

class AddPeopleDatingController: UITableViewController {
    
    var peopleDatingToEdit:PeopleDating?
    var mode:ModeForm = ModeForm.ADD
    
    @IBOutlet weak var addPeopleDatingTableView: UITableViewCell!
    @IBOutlet weak var inputLastname: UITextField!
    @IBOutlet weak var inputFirstname: UITextField!
    @IBOutlet weak var datePickerDateOfBirth: UIDatePicker!
    @IBOutlet weak var progressBarNote: UISlider!
    @IBOutlet weak var switchSexe: UISegmentedControl!
    @IBOutlet weak var labelNote: UILabel!
    
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
            self.populateForm(peopleDating: peopleDatingToEdit!)
        }
        datePickerDateOfBirth.maximumDate = Date(timeIntervalSinceNow: DatesUtils.getTimeIntervalBy(year: 0))
        navigationItem.rightBarButtonItems = [validButton];
        navigationItem.leftBarButtonItems = [cancelButton];
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func backToList(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toPeopleDatingListView", sender: self)
    }
    
    func mergePeopleDating(sender: UIBarButtonItem) {
        if ((inputLastname.text?.isEmpty)! && (inputFirstname.text?.isEmpty)!) {
            ViewsUtils.showPopup(title: "Formulaire invalide", message: "Veuillez saisir un nom et un prénom", controller: self)
            return;
        }
        if ((inputLastname.text?.isEmpty)!) {
            ViewsUtils.showPopup(title: "Champs invalides", message: "Veuillez saisir un nom", controller: self)
            return;
        }
        if ((inputFirstname.text?.isEmpty)!) {
            ViewsUtils.showPopup(title: "Champs invalides", message: "Veuillez saisir un prénom", controller: self)
            return;
        }
        
        do {
            let peopleDating = PeopleDating(
                dateOfBirth: datePickerDateOfBirth.date,
                firstname: (inputLastname.text)!,
                lastname: (inputFirstname.text)!,
                sexe: (switchSexe.selectedSegmentIndex == 0 ? "H" :  "F"),
                note: Int(progressBarNote.value))
            
            if (try PeopleDatingProvider.findBy(lastname: peopleDating.lastname, firstname: peopleDating.firstname, sexe: peopleDating.sexe, dateOfBirth: DatesUtils.setNoHoursToDate(date: peopleDating.dateOfBirth))) != nil {
                ViewsUtils.showPopup(title: "Une erreur est survenue", message: "Cette personne existe déjà!", controller: self)
                return
            }
            
            merge(peopleDating: peopleDating)
            
        } catch {
            print(error)
            return;
        }
        
        performSegue(withIdentifier: "toPeopleDatingListView", sender: self)
    }
    
    
    func merge(peopleDating:PeopleDating) {
        do {

            
            switch mode {
            case .ADD:
                try  PeopleDatingProvider.insert(item: peopleDating)
                break
            case .EDIT:
                peopleDating.id = peopleDatingToEdit?.id
                try PeopleDatingProvider.update(item: peopleDating)
                break
                
            }
        } catch {
            print(error)
        }
    }
    
    func populateForm(peopleDating:PeopleDating) {
        inputLastname.text = peopleDating.lastname
        inputFirstname.text = peopleDating.firstname
        datePickerDateOfBirth.date = peopleDating.dateOfBirth
        labelNote.text = "\(peopleDating.note) / 10"
        progressBarNote.value = Float(peopleDating.note)
        switchSexe.selectedSegmentIndex = (peopleDating.sexe == "H" ? 0 : 1)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        labelNote.text = "\(currentValue) / 10"
    }
}
