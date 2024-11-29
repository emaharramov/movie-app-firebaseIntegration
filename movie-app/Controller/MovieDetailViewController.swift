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
    var favoriteDocId: String?
    private let firestoreService = FirestoreService()
    
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
        setupUI()
        checkIfMovieIsFavorite()
    }

    @IBAction func addFav(_ sender: Any) {
        guard let movie = movie else { return }
        
        if favoriteDocId == nil {
            firestoreService.addMovieToFavorites(movie: movie) { result in
                switch result {
                case .success:
                    self.updateFavoriteIcon(isFavorite: true)
                    self.checkIfMovieIsFavorite() // Refresh the favorite status
                case .failure(let error):
                    print("Error adding favorite: \(error)")
                }
            }
        } else {
            guard let favoriteDocId = favoriteDocId else { return }
            
            firestoreService.removeMovieFromFavorites(documentId: favoriteDocId) { result in
                switch result {
                case .success:
                    self.updateFavoriteIcon(isFavorite: false)
                    self.favoriteDocId = nil
                case .failure(let error):
                    print("Error removing favorite: \(error)")
                }
            }
        }
    }

    func checkIfMovieIsFavorite() {
        guard let movie = movie, let movieId = movie.id else { return }
        
        firestoreService.isMovieFavorite(movieId: movieId) { result in
            switch result {
            case .success(let documentId):
                self.favoriteDocId = documentId
                self.updateFavoriteIcon(isFavorite: documentId != nil)
            case .failure(let error):
                print("Error checking favorite: \(error)")
            }
        }
    }

    func updateFavoriteIcon(isFavorite: Bool) {
        let iconName = isFavorite ? "heart.fill" : "heart"
        favBarButtonItem?.image = UIImage(systemName: iconName)
    }

    func setupUI() {
        titleLabel.text = movie?.title ?? "No Title Available"
        descriptionLabel.text = movie?.overview ?? "Description is not available."
        releaseDateLabel.text = "Release Date: \(movie?.releaseDate ?? "Unknown")"
        popularityLabel.text = "Popularity: \(movie?.popularity?.description ?? "Not available")"
        voteCountLabel.text = "Vote: \(movie?.voteAverage?.description ?? "0") / 10"
        imageView.setImage(from: movie?.posterPath)
    }
}
