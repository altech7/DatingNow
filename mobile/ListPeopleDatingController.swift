import UIKit

class ListPeopleDatingController: UITableViewController {
    
    let cellId = "peopleDatingCell"
    var peoplesDating = [PeopleDating]()
    var currentPeopleDating:PeopleDating?
    var mode:ModeForm = ModeForm.ADD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loader = LoadingOverlay.shared.activityIndicator {
            LoadingOverlay.shared.hideOverlayView()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var nb:Int = 0
        
        do {
            try peoplesDating = PeopleDatingProvider.findAll()!
            nb = peoplesDating.count
        } catch {
            print(error)
        }
        
        return nb
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let peopleDating = peoplesDating[indexPath.row]
        
        cell.textLabel?.text = peopleDating.firstname + " " + peopleDating.lastname
        cell.detailTextLabel?.text = (peopleDating.sexe == "F" ? "Née le : " : "Né le : ") + DatesUtils.getDateToString(date: peopleDating.dateOfBirth).replacingOccurrences(of: " ", with: "/") + "| Note : " + String(peopleDating.note) + " / 10"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Supprimer") { (action, indexPath) in
            
            let peopleDating = self.peoplesDating[indexPath.row]
            let alert = UIAlertController(title: "Supression", message: "Voulez-vous supprimer \(peopleDating.firstname) ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oui", style: .default) { _ in
                
                do {
                    try PeopleDatingProvider.delete(item: peopleDating)
                    try DatingProvider.deleteByPeopleDatingId(idItem:peopleDating.id!)
                } catch {
                    print(error)
                    return;
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                alert.dismiss(animated: true, completion: {})
            })
            
            alert.addAction(UIAlertAction(title: "Non", style: .cancel) { _ in
                alert.dismiss(animated: true, completion: {})
            })
            
            self.present(alert, animated:true)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Modifier") { (action, indexPath) in
            self.currentPeopleDating = self.peoplesDating[indexPath.row]
            self.mode = ModeForm.EDIT
            self.performSegue(withIdentifier: "toFormPeopleDating", sender: self)
        }
        
        edit.backgroundColor = UIColor.blue;
        return [delete, edit]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "toFormPeopleDating":
                if let destinationController = segue.destination as? AddPeopleDatingController {
                    destinationController.mode = self.mode
                    destinationController.peopleDatingToEdit = self.currentPeopleDating
                }
                break;
            case "toDetailsView":
                if let destinationController = segue.destination as? DetailsController {
                    let peopleDating = self.peoplesDating[(tableView.indexPathForSelectedRow?.row)!]
                    destinationController.peopleDating = peopleDating
                }
                break;
            default:
                break;
            }
        }
    }
    
    @IBAction func reloadDataListPleopleDating(segue: UIStoryboardSegue){
        self.mode = ModeForm.ADD
        tableView.reloadData();
    }
    
    @IBAction func setModeFormAdd(_ sender: Any) {
        self.mode = ModeForm.ADD
    }
}
