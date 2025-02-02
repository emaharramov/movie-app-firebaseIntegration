//
//  TopImageBottomLabelCell.swift
//  movie-app
//
//  Created by Emil Maharramov on 02.01.25.
//

import UIKit

protocol TopImageBottomLabelCellProtocol {
    var imageName: String { get }
    var nameText: String { get }
}

class TopImageBottomLabelCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(data: TopImageBottomLabelCellProtocol) {
        nameLabel.text = data.nameText
        imageView.setImage(from: data.imageName)
    }

}
