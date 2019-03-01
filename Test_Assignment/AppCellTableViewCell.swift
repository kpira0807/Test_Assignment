import UIKit

struct PersonViewModel {
    var name: String
    var lastName: String
    var gender: String
    var phone: String
    var date: String
    var picture: String

    
    init(with personModel: Person){
        name = personModel.name.first
        lastName = personModel.name.last
        gender = personModel.gender
        phone = personModel.phone
        date = personModel.dob.date
        picture = personModel.picture.medium
    }
}

class AppCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCell.layer.cornerRadius = imageCell.frame.size.width / 2
        imageCell.clipsToBounds = true
    }
    
    func setup(with personModel: PersonViewModel) {
        firstNameLabel.text = "First name: \(personModel.name)"
        lastNameLabel.text = "Last name: \(personModel.lastName)"
    }

}
