import UIKit
import Alamofire

class AppTitleTableViewController: UITableViewController {
    
    private var personList: [PersonViewModel] = []
    let personeService = Service.shared
    
    @IBOutlet weak var activityIndecator: UIActivityIndicatorView!
    
    private func loadPerson() {
        activityIndecator.startAnimating()
        personeService.personList(completed: { [weak self] people in
            guard let strongSelf = self else { return }
            strongSelf.personList = people.filter{ peoples -> Bool in
                if peoples.name != nil {
                    return true
                }
                return false
                }.map{ PersonViewModel(with: $0) }
            strongSelf.tableView.reloadData()
            self!.activityIndecator.stopAnimating()
            }, failed: {
                self.showError(with: ErrorType.loading)
                self.activityIndecator.stopAnimating()
        })
    }
    
    func showError(with type: ErrorType) {
        let myAlert = UIAlertController(title: "Error", message: type.rawValue, preferredStyle: .alert)
        let okeyAction = UIAlertAction(title: "Okey", style: .default, handler: nil)
        myAlert.addAction(okeyAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadPerson()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? AppCellTableViewCell
            else {
                return UITableViewCell()
        }
        
        let personModel = personList[indexPath.row]
        cell.setup(with: personModel)
        cell.firstNameLabel?.text = "First name: \(personModel.name.capitalized)"
        cell.lastNameLabel?.text = "Last name: \(personModel.lastName.capitalized)"
        
        if let imageURL = URL(string: personList[indexPath.row].picture) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.imageCell.image = image
                    }
                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail" {
            guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return }
            let personlist = personList[indexPath.row]
            if let screenTitleViewController: ScreenTitleViewController = segue.destination as? ScreenTitleViewController {
                screenTitleViewController.personlist = personlist
            }
        }
    }
    // Edit для удаления и перемены местами cell
    @IBAction func editButton(_ sender: Any) {
        isEditing = !isEditing
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Перемещение cell
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = personList[sourceIndexPath.row]
        personList.remove(at: sourceIndexPath.row)
        personList.insert(itemToMove, at: destinationIndexPath.row)
    }
    // Функция удаления cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.personList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
