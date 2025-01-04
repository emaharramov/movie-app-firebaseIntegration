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
    
    @IBOutlet weak var similarcollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    var movie: Movie?
    var favoriteDocId: String?
    private let viewModel = HomeVM()

    private let firestoreService = FirestoreService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        checkIfMovieIsFavorite()
        title = movie?.title
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        similarcollectionView.delegate = self
        similarcollectionView.dataSource = self
        
        let detailCellNib = UINib(nibName: "MovieDetailCollectionViewCell", bundle: nil)
        collectionView.register(detailCellNib, forCellWithReuseIdentifier: "MovieDetailCollectionViewCell")
        
        let similarCellNib = UINib(nibName: "ActSimCollectionViewCell", bundle: nil)
        similarcollectionView.register(similarCellNib, forCellWithReuseIdentifier: "ActSimCollectionViewCell")
        
        viewModel.loadMovie()
        
        viewModel.success = {
            self.collectionView.reloadData()
            self.similarcollectionView.reloadData()
        }
        
        viewModel.didUpdateMovie = {
            self.collectionView.reloadData()
            self.similarcollectionView.reloadData()
        }
  
    }

    @IBAction func addFav(_ sender: Any) {
        guard let movie = movie else { return }
        
        if favoriteDocId == nil {
            firestoreService.addMovieToFavorites(movie: movie) { result in
                switch result {
                case .success:
                    self.updateFavoriteIcon(isFavorite: true)
                    self.checkIfMovieIsFavorite()
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
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: iconName)
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarcollectionView {
            return viewModel.trendingMovie.count
        }
        return movie != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == similarcollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActSimCollectionViewCell", for: indexPath) as? ActSimCollectionViewCell else {
                return UICollectionViewCell()
            }
            let movie = viewModel.trendingMovie[indexPath.row]
            cell.configSimilarFilms(with: movie) // Doğru yapılandırma metodu çağrılıyor
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCollectionViewCell", for: indexPath) as? MovieDetailCollectionViewCell, let movie = movie else {
            return UICollectionViewCell()
        }
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == similarcollectionView {
            return CGSize(width: collectionView.bounds.width, height: 180)
        }
        return CGSize(width: collectionView.bounds.width - 10, height: collectionView.bounds.height / 1.2)
    }
}
