//
//  SearchViewController.swift
//  movie-app
//
//  Created by Emil Maharramov on 20.11.24.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchFilm: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    var allMovies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    fileprivate func configureUI() {
        searchFilm.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        filteredMovies = allMovies
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        let movie = filteredMovies[indexPath.row]
        cell.textLabel?.text = movie.title
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMovies = allMovies
        } else {
            filteredMovies = allMovies.filter { movie in
                if let title = movie.title?.lowercased() {
                    return title.contains(searchText.lowercased())
                }
                return false
            }
        }
        
        searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredMovies = allMovies
        searchTableView.reloadData()
    }
}
