import UIKit

class ListNoteController: UITableViewController {
    
    let cellId = "noteCell"
    var notesShared = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesShared.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let note = notesShared[indexPath.row]
        
        cell.textLabel?.text = note.note
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        cell.detailTextLabel?.text = "Partagé le : " + dateFormatter.string(from: note.dateOfSharing) + " | Par : " + note.pseudo
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
