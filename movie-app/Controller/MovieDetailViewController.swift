//
//  MovieDetailViewController.swift
//  movie-app
//
//  Created by Emil Maharramov on 18.11.24.
//

import UIKit
import Kingfisher
import FirebaseFirestore

class MovieDetailViewController: UIViewController {

    var movie: Movie?
    private var firestore: Firestore!
    var favoriteDocId: String?
    
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
        setupUI()
        checkIfMovieIsFavorite()
    }

    @IBAction func addFav(_ sender: Any) {
        if let movie = movie {
            addToFavorites(movie: movie)
        }
    }

    func addToFavorites(movie: Movie) {
        guard let movieId = movie.id else { return }

        firestore.collection("favorites").whereField("movieId", isEqualTo: movieId).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking favorite: \(error)")
                return
            }

            if snapshot?.isEmpty ?? true {
                let favoriteData: [String: Any] = [
                    "title": movie.title ?? "No Title",
                    "description": movie.overview ?? "No Description",
                    "releaseDate": movie.releaseDate ?? "No Date",
                    "popularity": movie.popularity ?? 0,
                    "voteAverage": movie.voteAverage ?? 0,
                    "posterPath": movie.posterPath ?? "No Path",
                    "movieId": movieId
                ]

                self.firestore.collection("favorites").addDocument(data: favoriteData) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        self.favoriteDocId = self.firestore.collection("favorites").document().documentID
                        self.updateFavoriteIcon(isFavorite: true)
                        NotificationCenter.default.post(name: Notification.Name("FavoritesUpdated"), object: nil)
                    }
                }
            } else {
                if let doc = snapshot?.documents.first {
                    self.firestore.collection("favorites").document(doc.documentID).delete { error in
                        if let error = error {
                            print("Error removing favorite: \(error)")
                        } else {
                            self.updateFavoriteIcon(isFavorite: false)
                        }
                    }
                }
            }
        }
    }

    func checkIfMovieIsFavorite() {
        guard let movie = movie, let movieId = movie.id else { return }

        firestore.collection("favorites").whereField("movieId", isEqualTo: movieId).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking favorite: \(error)")
                return
            }

            if let documents = snapshot?.documents, documents.isEmpty {
                self.updateFavoriteIcon(isFavorite: false)
            } else {
                self.updateFavoriteIcon(isFavorite: true)
            }
        }
    }

    func updateFavoriteIcon(isFavorite: Bool) {
        let iconName = isFavorite ? "heart.fill" : "heart"
        favBarButtonItem?.image = UIImage(systemName: iconName)
    }

    func setupUI() {
        self.title = movie?.title ?? "No Title Available"
        
        titleLabel.text = movie?.title ?? "No Title Available"
        descriptionLabel.text = movie?.overview ?? "Description is not available."
        releaseDateLabel.text = "Release Date: \(movie?.releaseDate ?? "Unknown")"
        popularityLabel.text = "Popularity: \(movie?.popularity?.description ?? "Not available")"
        voteCountLabel.text = "Vote: \(movie?.voteAverage?.description ?? "0") / 10"
        
        if let posterPath = movie?.posterPath, let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
            imageView.kf.setImage(with: imageUrl)
        } else {
            imageView.image = UIImage(named: "default_poster")
        }
    }
}
