//
//  TrendingCollectionViewCell.swift
//  TMDB
//
//  Created by SC on 2022/08/03.
//

import UIKit

import Kingfisher
import SkeletonView

class TrendingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var showDetailsLabel: UILabel!
    
    var media: MediaModel?
    
    
    func configureCell(data: MediaModel) {
        media = data
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
        
//        let url = URL(string: Endpoint.configurationURL + data.backdropPath)
//        backdropImageView.kf.setImage(with: url)
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.layer.cornerRadius = 12
        backdropImageView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        designTrailerButton()
        
        titleLabel.text = data.title
        titleLabel.font = .systemFont(ofSize: 20)
        
        overviewLabel.text = data.overview
        overviewLabel.textColor = .darkGray
        overviewLabel.font = .systemFont(ofSize: 15)
        
        showDetailsLabel.font = .systemFont(ofSize: 13)
        
        configureShadowForContainerView()
    }
    
    
    func designTrailerButton() {
        trailerButton.setTitle("", for: .normal)
        trailerButton.tintColor = .white
//        trailerButton.backgroundColor = .systemMint
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 150)
        let paperclipImage = UIImage(systemName: "paperclip.circle.fill", withConfiguration: symbolConfig)
        trailerButton.setImage(paperclipImage, for: .normal)
//        trailerButton.contentMode = .scaleAspectFill  // plain X, defult X
//        trailerButton.imageView?.contentMode = .scaleAspectFill
//        trailerButton.imageView?.contentMode = .scaleAspectFit  // plain X, defult X
//        trailerButton.titleLabel?.font = .systemFont(ofSize: 40)  // plain X, defult X
//        trailerButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        trailerButton.layer.shadowColor = UIColor.black.cgColor
        trailerButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        trailerButton.layer.shadowRadius = 20
        trailerButton.layer.shadowOpacity = 0.5
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
    
    
    func skeletonizeAll() {
        self.isSkeletonable = true
        self.containerView.isSkeletonable = true
        
        releaseDateLabel.isSkeletonable = true
//        releaseDateLabel.showAnimatedSkeleton()
        genreLabel.isSkeletonable = true
        mediaTypeLabel.isSkeletonable = true
        
        backdropImageView.isSkeletonable = true
//        backdropImageView.showAnimatedSkeleton()
        
        titleLabel.isSkeletonable = true
        overviewLabel.isSkeletonable = true
        showDetailsLabel.isSkeletonable = true
    }
    
    
//    @IBAction func trailerButtonClicked(_ sender: UIButton) {
//        let sb = UIStoryboard(name: "Web", bundle: nil)
//        guard let vc = sb.instantiateViewController(withIdentifier: WebViewController.reuseIdentifier) as? WebViewController else {
//            print("Cannot find WebViewController")
//            return
//        }
//
//        vc.media = media
//        // 여기에서 video를 받아서 넘겨주는 것이 나은지, WebViewController에서 video를 받는 것이 나은지?
//
//
//    }
    
    
}
