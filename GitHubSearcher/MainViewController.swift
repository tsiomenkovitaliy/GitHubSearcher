import UIKit

class MainViewController: UIViewController{
    var items = [StarItem]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    var gitHubSevice = GitHubSevice()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text =  items[indexPath.item].item?.name
        cell.detailTextLabel?.text = String(items[indexPath.item].star!)
        return cell
    }
}
extension MainViewController : UISearchBarDelegate{

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count>2{
            gitHubSevice.searchRepositories(searchText: searchBar.text!) { (data, error) in
                self.items = data
                self.tableView.reloadData()
            }
        }
    }
}
