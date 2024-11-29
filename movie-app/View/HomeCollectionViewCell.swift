//
//  HomeCollectionViewCell.swift
//  movie-app
//
//  Created by Emil Maharramov on 15.11.24.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var fileNameLabel: UILabel!
    @IBOutlet private weak var imageViewField: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    func configure(with model: Movie) {
        fileNameLabel.text = model.title
        descriptionLabel.text = model.overview
        ratingLabel.text = "\(String(describing: model.voteAverage ?? 0.0)) / 10 IMDb"
        imageViewField.setImage(from: model.posterPath)
    }
}
