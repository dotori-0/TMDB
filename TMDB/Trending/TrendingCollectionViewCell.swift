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
        
//        print("🍑")
//        print(layer.masksToBounds)  // true
        layer.masksToBounds = false
        
//        cell.layer.masksToBounds  // Cannot find 'cell' in scope
//        view.layer.masksToBounds  // Cannot find 'view' in scope
//        print("😇", contentView.layer.masksToBounds)  // false
        
        releaseDateLabel.text = data.releaseDate
        releaseDateLabel.textColor = .darkGray
        releaseDateLabel.font = .systemFont(ofSize: 14)
        
        genreLabel.text = "#\(data.genreID)"
        genreLabel.font = .boldSystemFont(ofSize: 20)
        
        mediaTypeLabel.text = data.mediaType
        mediaTypeLabel.textColor = .lightGray
        mediaTypeLabel.font = .boldSystemFont(ofSize: 15)
        
        let url = URL(string: Endpoint.configurationURL + data.backdropPath)
        backdropImageView.kf.setImage(with: url)
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.layer.cornerRadius = 12
        backdropImageView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        titleLabel.text = data.title
        titleLabel.font = .systemFont(ofSize: 20)
        
        overviewLabel.text = data.overview
        overviewLabel.textColor = .darkGray
        overviewLabel.font = .systemFont(ofSize: 15)
        
        showDetailsLabel.font = .systemFont(ofSize: 13)
        
        configureShadowForContainerView()
    }
    
    func configureShadowForContainerView() {
//        print("🐶")
//        print(containerView.layer.masksToBounds)  // false
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 15
        containerView.layer.shadowOpacity = 0.7
        containerView.layer.cornerRadius = 12
    }
}
