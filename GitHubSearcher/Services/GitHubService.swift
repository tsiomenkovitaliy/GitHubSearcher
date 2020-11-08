import Foundation
import Alamofire
struct GitHubSevice {
    private let queueCount = 2
    private let perPage = 15
    func searchRepositories(searchText:String, completion: @escaping ([Item]?, Error?)->Void){
        var items = [Item]()
        var storedError : Error?
        let dispatchGroup = DispatchGroup()
        for i in 1 ... queueCount {
            let queue = DispatchQueue(label: "Queue \(i)", qos: .userInitiated, attributes: .concurrent)
            dispatchGroup.enter()
            let url = "https://api.github.com/search/repositories?q=\(searchText)&per_page=\(perPage)&page=\(i)"
            AF.request(url).validate().responseDecodable(of: Repositoris.self,queue: queue) {
                (response) in
                switch response.result {
                    case .success(let value):
                        items.append(contentsOf: value.items)
                    case .failure(let error):
                        storedError = error
                    }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main){
            items.sort {
                $0.stargazersCount > $1.stargazersCount
            }
            completion(items, storedError)
        }
    }
}
