//
//  HomeViewController.swift
//  mvvm-programmatic
//
//  Created by Emil Maharramov on 15.11.24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel = HomeVM()
    
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        configureViewModel()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        let cellNib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        let headerNib = UINib(nibName: "TrendingReusableView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TrendingReusableView")
    }
    
    func configureViewModel() {
        viewModel.loadMovie()
        
        viewModel.success = {
            self.collectionView.reloadData()
        }
        
        viewModel.didUpdateMovie = {
            self.collectionView.reloadData()
        }
    }
    
    func seeAll() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            controller.allMovies = viewModel.popularMovie + viewModel.trendingMovie
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func search(_ sender: Any) {
        seeAll()
    }
}
//MARK: CollectionView config
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.trendingMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let movie = viewModel.trendingMovie[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.trendingMovie[indexPath.row]
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            controller.movie = selectedMovie
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrendingReusableView", for: indexPath) as! TrendingReusableView
            header.delegate = self
            header.configure(with: viewModel.popularMovie)
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 350, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: 350)
    }
}
//MARK: TrendingReusable config
extension HomeViewController: TrendingReusableViewDelegate {
    
    func popularSeeAll(in view: TrendingReusableView) {
         let popularMovies = viewModel.popularMovie
         
        if let controller = storyboard?.instantiateViewController(withIdentifier: "AllMovieViewController") as? AllMovieViewController {
             controller.popularMovies = popularMovies
             navigationController?.pushViewController(controller, animated: true)
         }
    }
    
    func trendingSeelAll(in view: TrendingReusableView) {
        let trendingMovies = viewModel.trendingMovie
         
        if let controller = storyboard?.instantiateViewController(withIdentifier: "AllMovieViewController") as? AllMovieViewController {
            controller.trendingMovies = trendingMovies
             navigationController?.pushViewController(controller, animated: true)
         }
    }
    
    func seeAllAction(type: TrendingViewActionType) {
        switch type {
        case .popular:
            let popularMovies = viewModel.popularMovie
            
            if let controller = storyboard?.instantiateViewController(withIdentifier: "AllMovieViewController") as? AllMovieViewController {
                controller.popularMovies = popularMovies
                navigationController?.pushViewController(controller, animated: true)
            }
        case .trending:
            let trendingMovies = viewModel.trendingMovie
            
            if let controller = storyboard?.instantiateViewController(withIdentifier: "AllMovieViewController") as? AllMovieViewController {
                controller.trendingMovies = trendingMovies
                navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
  
}
