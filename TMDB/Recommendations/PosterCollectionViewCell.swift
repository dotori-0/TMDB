//
//  PosterCollectionViewCell.swift
//  TMDB
//
//  Created by SC on 2022/08/09.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterView: PosterView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterView.backgroundColor = .yellow
        roundCorners()
    }

    func roundCorners() {
        posterView.layer.cornerRadius = 10
    }
}
