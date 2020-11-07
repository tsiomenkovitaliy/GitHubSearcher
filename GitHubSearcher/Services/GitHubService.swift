import Foundation
import Alamofire
struct GitHubSevice {
    private let queueCount = 2
    private let perPage = 15
    
    func searchRepositories(searchText:String, completion: @escaping ([Item]?, Error?)->Void){
        var items = [Item]()
        let fetchGroup = DispatchGroup()
        for i in 1 ... queueCount {
            let queue = DispatchQueue(label: "Queue \(i)", qos: .userInitiated, attributes: .concurrent)
            fetchGroup.enter()
            let url = "https://api.github.com/search/repositories?q=\(searchText)&per_page=\(perPage)&page=\(i)"
            AF.request(url).validate().responseDecodable(of: Repositoris.self,queue: queue) {
                (response) in
                if let repositories = response.value  {
                    items.append(contentsOf: repositories.items)
                    print(queue.label)
                }
                else
                {
                    completion(nil,response.error)
                }
                fetchGroup.leave()
            }
        }
        fetchGroup.notify(queue: .main){
            items.sort {
                $0.stargazersCount > $1.stargazersCount
            }
            completion(items, nil)
        }
    }
}
