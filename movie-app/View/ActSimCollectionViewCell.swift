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
            setImage(from: profilePath)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    func configSimilarFilms(with movie: Movie) {
        nameLabel.text = movie.title
        if let posterPath = movie.posterPath {
            setImage(from: posterPath)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func setImage(from path: String) {
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        guard let url = URL(string: baseUrl + path) else { return }
        
        // Basit resim yükleme işlemi
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
