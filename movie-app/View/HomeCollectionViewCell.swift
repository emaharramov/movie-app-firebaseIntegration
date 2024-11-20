//
//  HomeCollectionViewCell.swift
//  mvvm-programmatic
//
//  Created by Emil Maharramov on 15.11.24.
//


import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet private weak var fileNameLabel: UILabel!
    @IBOutlet private weak var imageViewField: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    func configure(with model: Movie) {
        fileNameLabel.text = model.title
        descriptionLabel.text = model.overview
        ratingLabel.text = "\(String(describing: model.voteAverage!)) / 10 IMDb"
        if let posterPath = model.posterPath, !posterPath.isEmpty {
            let baseURL = "https://image.tmdb.org/t/p/w500"
            let fullPath = baseURL + posterPath
            let url = URL(string: fullPath)
            imageViewField.kf.setImage(with: url)
        } else {
            imageViewField.image = UIImage(named: "default_poster")
        }
    }
    
}
