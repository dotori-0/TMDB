//
//  RecommendationsViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/09.
//

import UIKit

class RecommendationsViewController: UIViewController {

    @IBOutlet weak var recommendationsTableView: UITableView!
    
    var collectionViewItemHeight = 0.0
    var cellFrameHeight = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recommendationsTableView.dataSource = self
        recommendationsTableView.delegate = self
        recommendationsTableView.register(UINib(nibName: RecommendationsTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: RecommendationsTableViewCell.reuseIdentifier)
    }
}


extension RecommendationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationsTableViewCell.reuseIdentifier, for: indexPath) as? RecommendationsTableViewCell else {
            print("Cannot find RecommendationsTableViewCell")
            return UITableViewCell()
        }
        
        cell.backgroundColor = .systemGreen
        cell.posterCollectionView.dataSource = self
        cell.posterCollectionView.delegate = self
        cell.posterCollectionView.register(UINib(nibName: NibName.posterCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: PosterCollectionViewCell.reuseIdentifier)
//        print("컬렉션뷰 높이: \(cell.posterCollectionView.frame.height)")
//        print("컬렉션뷰 컨텐트 사이즈 높이: \(cell.posterCollectionView.collectionViewLayout.collectionViewContentSize.height)")
//        collectionViewItemHeight = cell.collectionViewItemHeight
//        print("collectionViewItemHeight: \(collectionViewItemHeight)")
//        print("\(cell.frame.height)")
//        cellFrameHeight = cell.frame.height
//        print("cell.contentView.frame.height: \(cell.contentView.frame.height)")
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("UIScreen.main.bounds.height: \(UIScreen.main.bounds.height / 4.5)")
//        return UIScreen.main.bounds.height / 4.5
//        return 190

        print("tableView.rowHeight: \(tableView.frame.height)")
//        return tableView.rowHeight
//        return cellFrameHeight + collectionViewItemHeight
        
//        return UITableView.automaticDimension
        
        let tableViewCellHeightExceptCollectionView = 53.0
        let collectionViewItemHeight = UIScreen.main.bounds.width / 3.2 * 1.414
        return tableViewCellHeightExceptCollectionView + collectionViewItemHeight + 8
    }
}


extension RecommendationsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.reuseIdentifier, for: indexPath) as? PosterCollectionViewCell else {
            print("Cannot find PosterCollectionViewCell")
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    

}
