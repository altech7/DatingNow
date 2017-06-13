import UIKit

class DetailsController: UIViewController, NoteServiceDelegate{
    
    var peopleDating:PeopleDating?
    var datings = [Dating]()
    var notesShared = [Note]()
    
    @IBOutlet weak var btnSharedNote: UIButton!
    @IBOutlet weak var btnDating: UIButton!
    @IBOutlet weak var labelDateOfBirth: UILabel!
    @IBOutlet weak var imgSexe: UIImageView!
    @IBOutlet weak var labelNote: UILabel!
    @IBOutlet weak var labelFullname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView(peopleDating:peopleDating!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "toListDatingView":
                do {
                    if let destinationController = segue.destination as? ListDatingController {
                        destinationController.datings = self.datings
                    }
                } catch {
                    print(error)
                }
                break;
            case "toFormDating":
                if let destinationController = segue.destination as? AddDatingController {
                    destinationController.mode = ModeForm.ADD
                    destinationController.peopleDatingAssociated = self.peopleDating
                }
                break;
            case "toListNoteView":
                if let destinationController = segue.destination as? ListNoteController {
                    destinationController.notesShared = self.notesShared
                }
                break;
            case "toPictureView":
                if let destinationController = segue.destination as? PictureController {
                    destinationController.peopleDating = self.peopleDating
                    do {
                        var pict = try PeopleDatingProvider.findPicture(peopleDating: self.peopleDating!)
                        destinationController.pictureExisting = pict
                    } catch {
                        print(error)
                    }
                }
                break;
            default:
                break;
            }
        }
    }
    
    func populateView(peopleDating:PeopleDating) {
        labelFullname.text = peopleDating.lastname + " " + peopleDating.firstname
        labelDateOfBirth.text = DatesUtils.getDateToString(date: peopleDating.dateOfBirth).replacingOccurrences(of: " ", with: "/")
        labelNote.text = "\(peopleDating.note) / 10"
        
        switch peopleDating.sexe {
        case "F":
            imgSexe.image = #imageLiteral(resourceName: "img-female")
            break;
        case "H":
            imgSexe.image = #imageLiteral(resourceName: "img-male")
            break;
        default:
            break
        }
        
        do {
            self.datings = try DatingProvider.findAllByPeopleDating(peopleDatingId: (peopleDating.id)!)!
        }catch {
            print(error)
            return
        }
        
        btnDating.setTitle("Voir les rencontres ( " +  String(self.datings.count) + " )", for: .normal)
        btnSharedNote.setTitle("Voir les remarques partagées" , for: .normal)
    }
    
    @IBAction func reloadDataDetailsPeopleDating(segue: UIStoryboardSegue){
        populateView(peopleDating:peopleDating!)
    }
    
    func didFailed(error: String) {
        ViewsUtils.showPopup(title: "Erreur", message: "Une erreur est survenue", controller: self)
    }
    
    func didShared(note: NoteJson) {
    }
    
    func didFindedNotes(notes: [NoteJson]) {
        for n in notes {
            self.notesShared.removeAll()
            let date = n.dateOfSharing
            self.notesShared.append(Note(
                note: n.note,
                peopleDatingId: n.peopleDatingId,
                dateOfSharing: DatesUtils.getDateStringFromDate(date: date),
                clientId: n.clientId,
                pseudo: n.pseudo))
        }
        self.performSegue(withIdentifier: "toListNoteView", sender: self)
    }
    
    @IBAction func findNotes(_ sender: Any) {
        NoteWebServices.findAllByPeopleDating(peopleDatingId: self.peopleDating!.id!, delegate: self)
    }
    


}
