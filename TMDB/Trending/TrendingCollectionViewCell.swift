//
//  TrendingCollectionViewCell.swift
//  TMDB
//
//  Created by SC on 2022/08/03.
//

import UIKit

import Kingfisher

class TrendingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var showDetailsLabel: UILabel!
    
    func configureCell(data: MediaModel) {
        
        print("🍑")
        print(layer.masksToBounds)
        
//        cell.layer.masksToBounds  // Cannot find 'cell' in scope
//        view.layer.masksToBounds  // Cannot find 'view' in scope
        print("😇", contentView.layer.masksToBounds)
        
        releaseDateLabel.text = data.releaseDate
        genreLabel.text = "#\(data.genreID)"
        mediaTypeLabel.text = data.mediaType
        
        let url = URL(string: Endpoint.configurationURL + data.backdropPath)
        backdropImageView.kf.setImage(with: url)
        
        titleLabel.text = data.title
        overviewLabel.text = data.overview
        
        configureShadowForContainerView()
        
//        showDetailsLabel.font
    }
    
    func configureShadowForContainerView() {
        print("🐶")
        print(containerView.layer.masksToBounds)
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOpacity = 1.0
    }
}
