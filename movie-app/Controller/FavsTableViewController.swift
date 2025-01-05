//
//  FavsTableViewController.swift
//  movie-app
//
//  Created by Emil Maharramov on 18.11.24.
//

import UIKit

class FavsTableViewController: UITableViewController, FavsTableViewCellDelegate {

    private var favorites: [(id: String, data: [String: Any])] = []
    private let firestoreService = FirestoreService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupObservers()
        fetchFavorites()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFavorites), name: Notification.Name("FavoritesUpdated"), object: nil)
    }

    @objc private func refreshFavorites() {
        fetchFavorites()
    }

    // MARK: - Setup Methods
    private func setupTableView() {
        let nib = UINib(nibName: "FavsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FavsTableViewCell")
    }

    // MARK: - Fetch Data
    private func fetchFavorites() {
        firestoreService.fetchFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedFavorites):
                self.favorites = fetchedFavorites
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error fetching favorites: \(error)")
                showAlert(title: "Error", message: "Error Message: \(error)", isError: true)
            }
        }
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavsTableViewCell", for: indexPath) as! FavsTableViewCell
        let favorite = favorites[indexPath.row]
        cell.configure(with: favorite.data, id: favorite.id)
        cell.delegate = self
        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let movie = Movie(
            id: Int(favorite.data["movieId"] as? String ?? "0"),
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

    // MARK: - FavsTableViewCellDelegate
    func removeFavorite(for movieId: String) {
        firestoreService.removeMovieFromFavorites(documentId: movieId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.favorites.removeAll { $0.id == movieId }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print("Error removing favorite: \(error)")
            }
        }
    }
}
