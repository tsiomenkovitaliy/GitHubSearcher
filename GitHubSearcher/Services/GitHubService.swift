import Foundation
import Alamofire
struct GitHubSevice {
    private let queueCount = 2
    private let perPage = 15
    
    func searchRepositories(searchText:String, completion: @escaping ([StarItem], Error?)->Void){
        var items = [Item]()
        let fetchGroup = DispatchGroup()
        for i in 1 ... queueCount {
            let queue = DispatchQueue(label: "Thread \(i)", qos: .userInitiated, attributes: .concurrent)
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
                    print("Bad response")
                }
                fetchGroup.leave()
            }
        }
        fetchGroup.notify(queue: .global(qos: .userInitiated)){
            getStars(items:items,completion: completion)
        }
    }
    
    func getStars(items:[Item],completion: @escaping ([StarItem], Error?)->Void){
        var starItems = [StarItem]()
        let dispatchGroup = DispatchGroup()
        for i in 0 ..< items.count{
            let url = "https://api.github.com/repos/\(items[i].owner.login)/\(items[i].name)"
            dispatchGroup.enter()
            AF.request(url).validate().responseString(completionHandler: { (json) in
                if let value = json.data{
                    if let dictionary = DictionaryHalper.convertToDictionary(data: value){
                        if let star = dictionary["stargazers_count"] as? Int{
                            starItems.append(StarItem(item: items[i], star:star))
                        }
                    }
                    else
                    {
                        print("bad dictionary")
                    }
                }
                else
                {
                    print("bad data")
                }
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main){
            starItems.sort {
                $0.star! > $1.star!
            }
            completion(starItems, nil)
        }
    }
}
