import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController{
    var items = [Item]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var gitHubSevice = GitHubSevice()
    let disposeBag = DisposeBag()
    private var lastValidQuery = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar
            .rx
            .text
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { $0!.count > 2 }
            .subscribe(onNext: { [unowned self] (query) in
                if lastValidQuery != query{
                    gitHubSevice.searchRepositories(searchText: query!) { (data, error) in
                        if error != nil{
                            presentAler(title: "Error", message: error.debugDescription)
                        }
                        else
                        {
                            lastValidQuery = query!
                            if let data = data {
                                self.items = data
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func presentAler(title:String,message:String){
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text =  items[indexPath.item].name
        cell.detailTextLabel?.text = String(items[indexPath.item].stargazersCount)
        return cell
    }
}
