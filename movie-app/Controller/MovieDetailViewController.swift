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
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movie: Movie?
    var favoriteDocId: String?
    private let viewModel = HomeVM()
    private let firestoreService = FirestoreService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
        checkIfMovieIsFavorite()
    }
    
    private func configureUI() {
        showLoading()
        viewModel.loadMovie()
        title = movie?.title
        
        viewModel.success = {
            self.hideLoading()
            self.collectionView.reloadData()
        }
        
        viewModel.error = { message in
            self.showAlert(title: "Error", message: "Error Message: \(message)", isError: true)
            self.hideLoading()
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let headerNib = UINib(nibName: "MovieDetailCollectionViewCell", bundle: nil)
        collectionView.register(headerNib, forCellWithReuseIdentifier: "MovieDetailCollectionViewCell")
        
        let trendingCellNib = UINib(nibName: "TopImageBottomLabelCell", bundle: nil)
        collectionView.register(trendingCellNib, forCellWithReuseIdentifier: "TopImageBottomLabelCell")
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return movie != nil ? 1 : 0
        }
        return viewModel.trendingMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCollectionViewCell", for: indexPath) as? MovieDetailCollectionViewCell, let movie = movie else {
                return UICollectionViewCell()
            }
            cell.configure(with: movie)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopImageBottomLabelCell", for: indexPath) as? TopImageBottomLabelCell else {
                return UICollectionViewCell()
            }
            let trendingMovie = viewModel.trendingMovie[indexPath.row]
            cell.configure(data: trendingMovie)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.trendingMovie[indexPath.row]
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            controller.movie = selectedMovie
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width - 10, height: 200)
        } else {
            let width = (collectionView.bounds.width / 2) - 15
            return CGSize(width: width, height: 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: collectionView.bounds.width, height: 10) : .zero
    }
}
