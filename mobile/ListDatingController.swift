import UIKit

class ListDatingController: UITableViewController, NoteServiceDelegate {
    
    let cellId = "datingCell"
    var datings = [Dating]()
    var currentDating:Dating?
    var mode:ModeForm = ModeForm.ADD
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let dating = datings[indexPath.row]
        
        cell.textLabel?.text = dating.peopleDating.firstname + " " + dating.peopleDating.lastname
        cell.detailTextLabel?.text = "Rencontré le : " + DatesUtils.getDateToString(date: dating.dateOfDating).replacingOccurrences(of: " ", with: "/")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Supprimer") { (action, indexPath) in
            
            let dating = self.datings[indexPath.row]
            let alert = UIAlertController(title: "Supression", message: "Voulez-vous supprimer \(dating.peopleDating.firstname) ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Oui", style: .default) { _ in
                
                do {
                    try DatingProvider.delete(item: dating)
                } catch {
                    print(error)
                    return;
                }
                
                self.datings.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                alert.dismiss(animated: true, completion: {})
            })
            
            alert.addAction(UIAlertAction(title: "Non", style: .cancel) { _ in
                alert.dismiss(animated: true, completion: {})
            })
            
            self.present(alert, animated:true)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Modifier") { (action, indexPath) in
            self.currentDating = self.datings[indexPath.row]
            self.performSegue(withIdentifier: "toFormDatingFromListDating", sender: self)
        }
        
        edit.backgroundColor = UIColor.blue;
        return [delete, edit]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "toFormDatingFromListDating":
                if let destinationController = segue.destination as? AddDatingController {
                    destinationController.mode = ModeForm.EDIT
                    destinationController.datingToEdit = self.currentDating
                }
                break;
            default:
                break;
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dating = self.datings[indexPath.row]
        
        let alert = UIAlertController(title: "Remarque", message: (dating.note.isEmpty ? "Aucune" : dating.note), preferredStyle: .alert)
        
        if !dating.note.isEmpty {
            // Case shared
            alert.addAction(UIAlertAction(title: "Partager", style: .default) { _ in
                do {
                    let note = Note(note: dating.note, peopleDatingId: dating.peopleDating.id!, dateOfSharing: Date(timeIntervalSinceNow: DatesUtils.getTimeIntervalBy(year: 0)), clientId: ClientConnected.getId(), pseudo: ClientConnected.getPseudo())
                    
                    try NoteWebServices.sharedNote(note: note, delegate: self)
                } catch {
                    print(error)
                    return;
                }
                self.datings[indexPath.row] = dating
                alert.dismiss(animated: true, completion: {})
            })
            // Case delete
            alert.addAction(UIAlertAction(title: "Supprimer", style: .destructive) { _ in
                dating.note = ""
                do {
                    try DatingProvider.update(item: dating)
                } catch {
                    print(error)
                    return;
                }
                self.datings[indexPath.row] = dating
                alert.dismiss(animated: true, completion: {})
            })
        }
        
        alert.addAction(UIAlertAction(title: "Fermer", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: {})
        })
        
        self.present(alert, animated:true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func didFailed(error: String) {
        let this = self
        DispatchQueue.main.async {
            ViewsUtils.showPopup(title: "Erreur", message: "Veuillez réessayer", controller: this)
        }
    }
    
    func didShared(note: NoteJson) {
        // Do anything
        // Reload list
    }
    
    func didFindedNotes(notes: [NoteJson]) {
        // Do anything
    }
}
