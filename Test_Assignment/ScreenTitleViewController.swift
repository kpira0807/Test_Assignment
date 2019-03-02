import UIKit
import Alamofire

class ScreenTitleViewController: UIViewController {
    
    @IBOutlet weak var imageScreen: UIImageView!
    @IBOutlet weak var firstnameScreen: UITextField!
    @IBOutlet weak var lastnameScreen: UITextField!
    @IBOutlet weak var genderScreen: UITextField!
    @IBOutlet weak var birthScreen: UITextField!
    @IBOutlet weak var phoneScreen: UITextField!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBAction func backButton(_ sender: Any) {
        let AppTitleTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "AppTitleTableViewController") as! AppTitleTableViewController
        
        self.present(AppTitleTableViewController, animated: true)
    }
    
    var personlist: PersonViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScreen.layer.cornerRadius = imageScreen.frame.size.width / 2
        imageScreen.clipsToBounds = true
        
        callButton.layer.cornerRadius = 10
        callButton.layer.borderWidth = 1
        callButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        callButton.layer.masksToBounds = true

        guard let personlist = personlist else { return }
        firstnameScreen.text = personlist.name.capitalized
        lastnameScreen.text = personlist.lastName.capitalized
        genderScreen.text = personlist.gender.capitalized
        if let range = personlist.date.range(of: "T") {
            let firstPart = personlist.date[(personlist.date.startIndex)..<range.lowerBound]
            birthScreen.text = String(firstPart)
        }

        phoneScreen.text = personlist.phone
        if let imageURL = URL(string: personlist.picture) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imageScreen.image = image
                    }
                }
            }
        }
    }
    
    @IBAction func callButton(_ sender: UIButton) {
        if let url = URL(string: "tel://\(self.phoneScreen.text ?? "")") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
