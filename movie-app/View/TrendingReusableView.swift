//
//  TrendingReusableView.swift
//  mvvm-programmatic
//
//  Created by Emil Maharramov on 15.11.24.
//

import UIKit
import Kingfisher

class TrendingReusableView: UICollectionReusableView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var imageViewField: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [Movie] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // CollectionView için delegate ve dataSource ayarları
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // CollectionView hücresini kaydediyoruz
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    func configure(with movies: [Movie]) {
        self.movies = movies
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie) // Hücre yapılandırması
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: collectionView.frame.height)
    }
}
