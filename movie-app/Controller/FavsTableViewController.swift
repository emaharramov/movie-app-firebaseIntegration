//
//  FavsTableViewController.swift
//  movie-app
//
//  Created by Emil Maharramov on 18.11.24.
//

import UIKit
import FirebaseFirestore

class FavsTableViewController: UITableViewController, FavsTableViewCellDelegate {

    var favorites: [(id: String, data: [String: Any])] = []
    private let db = Firestore.firestore()
    var moviedetail = MovieDetailViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "FavsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FavsTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites), name: Notification.Name("FavoritesUpdated"), object: nil)

        
        fetchFavorites()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("FavoritesUpdated"), object: nil)
    }

    @objc func refreshFavorites() {
        fetchFavorites()
    }

    func fetchFavorites() {
        db.collection("favorites").getDocuments { snapshot, error in
            if let error = error {
                return print(error)
            }

            guard let documents = snapshot?.documents else {
                return
            }

            self.favorites = documents.map { (id: $0.documentID, data: $0.data()) }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favorites.count
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavsTableViewCell", for: indexPath) as! FavsTableViewCell
            let movie = favorites[indexPath.row]
            cell.configure(with: movie.data, id: movie.id)
            cell.delegate = self
    
            return cell
        }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        
        let movie = Movie(
            id: Int(favorite.data["id"] as? String ?? "0"),
            title: favorite.data["title"] as? String,
            originalTitle: nil,
            overview: favorite.data["description"] as? String,
            posterPath: favorite.data["posterPath"] as? String,
            backdropPath: nil,
            releaseDate: favorite.data["releaseDate"] as? String,
            voteAverage: favorite.data["voteAverage"] as? Double,
            voteCount: nil,
            popularity: favorite.data["popularity"] as? Double
        )
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            controller.movie = movie
            navigationController?.pushViewController(controller, animated: true)
        }
    }

        func removeFavorite(for movieId: String) {
            
            moviedetail.updateFavoriteIcon(isFavorite: false)
            
            db.collection("favorites").document(movieId).delete { error in
                if let error = error {
                    return print(error)
                }
    
                self.favorites.removeAll { $0.id == movieId }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
}
