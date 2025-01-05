//
//  ActSimCollectionViewCell.swift
//  movie-app
//
//  Created by Emil Maharramov on 02.01.25.
//

import UIKit

class ActSimCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }
    
    func configure(with actor: Actor) {
        nameLabel.text = actor.name
        if let profilePath = actor.profilePath {
            imageView.setImage(from: profilePath)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    func configSimilarFilms(with movie: Movie) {
        nameLabel.text = movie.title
        if let posterPath = movie.posterPath {
            imageView.setImage(from: posterPath)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}
