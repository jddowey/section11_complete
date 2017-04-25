import UIKit

class TweetTableViewController : UITableViewController {
    var authToken : String!
    var data : [String] = []
    var client : TweetClient!
    let searchController = UISearchController(searchResultsController: nil)
    var oldText = ""
    
    
    override func viewDidLoad() {
        print("\(self.authToken)")

        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "tweetTextCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        label.text = data[indexPath.item]
        return cell
    }
}

extension TweetTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        getContentForSearchText(searchController.searchBar.text!)
    }
    
    func getContentForSearchText(_ text: String) {
        guard text != "" && text != oldText else {
            return
        }
        print("Current text in search bar is: \(text)")
        oldText = text
    }
}

extension TweetTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        client.getTweets(auth: self.authToken, query: searchBar.text!) { tweets in
            self.data = tweets
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
}
