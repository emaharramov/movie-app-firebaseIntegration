//
//  TrendingReusableView.swift
//  mvvm-programmatic
//
//  Created by Emil Maharramov on 15.11.24.
//

import UIKit
import Kingfisher

protocol TrendingReusableViewDelegate: AnyObject {
    func popularSeeAll(in view: TrendingReusableView)
    func trendingSeelAll(in view: TrendingReusableView)
}

class TrendingReusableView: UICollectionReusableView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet private weak var filmTitleLabel: UILabel!
    @IBOutlet private weak var imageViewField: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var movies: [Movie] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    func configure(with movies: [Movie]) {
        self.movies = movies
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: collectionView.frame.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    }
    
    weak var delegate: TrendingReusableViewDelegate?
    
     @IBAction func popularSeeAll(_ sender: Any) {
         print("Popular See All clicked")
         delegate?.popularSeeAll(in: self)
     }
     
     @IBAction func trendingSeelAll(_ sender: Any) {
         print("Trending See All clicked")
         delegate?.trendingSeelAll(in: self)
     }
   
}
