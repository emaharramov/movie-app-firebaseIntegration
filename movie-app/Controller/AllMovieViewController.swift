//
//  AllMovieViewController.swift
//  movie-app
//
//  Created by Emil Maharramov on 20.11.24.
//

import UIKit

class AllMovieViewController: UITableViewController {
    
    
    @IBOutlet weak var allMovieTable: UITableView!
    
    var popularMovies: [Movie] = []
    var trendingMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let nib = UINib(nibName: "AllMovieTableCell", bundle: nil)
        allMovieTable.register(nib, forCellReuseIdentifier: "AllMovieTableCell")

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (popularMovies.count == 0) ? trendingMovies.count : popularMovies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMovieTableCell", for: indexPath) as! AllMovieTableCell
        
        let movie = (popularMovies.count == 0) ? trendingMovies[indexPath.row] : popularMovies[indexPath.row]
 
        cell.configure(with: movie)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = (popularMovies.count == 0) ? trendingMovies[indexPath.row] : popularMovies[indexPath.row]
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            controller.movie = selectedMovie
            
            if let navigationController = navigationController {
                navigationController.pushViewController(controller, animated: true)
            } else {
                print("NavigationController is nil")
            }
        } else {
            print("Failed to instantiate MovieDetailViewController with identifier 'MovieDetailViewController'")
        }
    }
    
    
}
