import Foundation
import Alamofire

struct Person: Decodable {
    enum CodingKeys: String, CodingKey {
        case gender, name, phone, dob, picture
    }
    
    let gender: String
    let phone: String
    let name: Name
    let dob: BirthdayInfo
    let picture: Picture
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gender = try container.decode(String.self, forKey: .gender)
        name = try container.decode(Name.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        dob = try container.decode(BirthdayInfo.self, forKey: .dob)
        picture = try container.decode(Picture.self, forKey: .picture)
    }
}

struct Picture: Decodable {
    let medium: String
}

struct BirthdayInfo: Decodable {
    let date: String
}

struct Name: Decodable {
    let title: String
    let first: String
    let last: String
}

class Service {
    static let shared = Service()
    
    struct Box: Decodable {
        let results: [Person]
    }
    
    func personList(page: Int, completed: @escaping ([Person]) -> Void, failed: @escaping() -> Void) {
        AF.request("https://randomuser.me/api/?page=\(page)&results=30").responseDecodable { (response: DataResponse<Box>) in
            switch response.result {
            case .success(let value):
                completed(value.results)
            case .failure(let error):
                print(" error \(error)")
                failed()
            }
        }
    }
}
