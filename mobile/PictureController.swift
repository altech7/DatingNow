import UIKit

class PictureController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {
    
    @IBOutlet weak var picture: UIImageView!
    let imagePicker = UIImagePickerController()
    var peopleDating:PeopleDating?
    var pictureExisting:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        if(pictureExisting != nil) {
            picture.image = pictureExisting! as UIImage
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        // Stored pictures
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        picture.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        do {
            try PeopleDatingProvider.addPicture(peopleDating: self.peopleDating!, picture: picture.image!)
        } catch {
            print(error)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
