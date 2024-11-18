//
//  HomeViewController.swift
//  mvvm-programmatic
//
//  Created by Emil Maharramov on 15.11.24.
//


import UIKit
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            navigationController?.show(controller, sender: nil)
        }
}

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrendingReusableView", for: indexPath) as! TrendingReusableView
            
            header.configure(with: viewModel.popularMovie)
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    }
    
    
    
}
