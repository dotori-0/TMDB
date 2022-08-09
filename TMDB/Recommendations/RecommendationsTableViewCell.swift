//
//  RecommendationsTableViewCell.swift
//  TMDB
//
//  Created by SC on 2022/08/09.
//

import UIKit

class RecommendationsTableViewCell: UITableViewCell {

    @IBOutlet weak var rowTitleLabel: UILabel!
    @IBOutlet weak var posterCollectionView: UICollectionView!
    
    var collectionViewItemHeight = 0.0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        designLabel()
        posterCollectionView.collectionViewLayout = collectionViewLayout()
    }

    
    func designLabel() {
        rowTitleLabel.textColor = .label
        rowTitleLabel.font = .boldSystemFont(ofSize: 24)
        print("👻rowTitleLabel.frame.height: \(rowTitleLabel.frame.height)")
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let width = UIScreen.main.bounds.width / 3.2
        let height = width * 1.414
        layout.itemSize = CGSize(width: width, height: height)
        
        collectionViewItemHeight = height
        
        // 미니멈라인 스페이싱, 미니멈인터아이템 스페이싱
        
        return layout
    }
}
