//
//  TableViewController.swift
//  GitHubSearcher
//
//  Created by admin on 04.11.2020.
//

import UIKit

class MainViewController: UIViewController {
    var items = [StarItem]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarView: UISearchBar!
    var gitHubSevice = GitHubSevice()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBarView.delegate = self
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
        func searchBar(textDidChange: String){
            gitHubSevice.searchRepositories(searchText: textDidChange) { (data, error) in
            self.items = data
            self.tableView.reloadData()
        }
    }
}
