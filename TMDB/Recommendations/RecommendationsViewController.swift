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
    
    var movieIDs = [
        725201,  // The Gray Man
        361743,   // Top Gun: Maverick
        438631,   // Dune
        391713,   // Lady Bird
        120467,   // The Grand Budapest Hotel
        421,      // The Life Aquatic with Steve Zissou
        83666     // Moonrise Kingdom
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recommendationsTableView.dataSource = self
        recommendationsTableView.delegate = self
        recommendationsTableView.register(UINib(nibName: RecommendationsTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: RecommendationsTableViewCell.reuseIdentifier)
        
//        TMDBAPIManager.shared.fetchDetailsAndRecommendations(movieID: 725201) { title, posterPaths in
//        }
        TMDBAPIManager.shared.callRequestsForDetailsAndRecommendations(movieIDs: movieIDs)
    }
    
    
//    func getLayout(collectionView: UICollectionView) -> UICollectionViewFlowLayout {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
//
//    //        let width = UIScreen.main.bounds.width / 3.2
//    //        let height = width * 1.414
//        let height = collectionView.frame.height
//    //        let height = UIScreen.main.bounds.height / 4.2
//    //    print("💎 테이블뷰셀 posterCollectionView.frame.height: \(posterCollectionView.frame.height)")
//        let width = height / 1.414
//        layout.itemSize = CGSize(width: width, height: height)
//
//    //        collectionViewItemHeight = height
//
//        layout.minimumLineSpacing = 8
//        layout.minimumInteritemSpacing = 0
//
//
//        return layout
//    }
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
        print("🫐 테이블뷰 cell.posterCollectionView.frame.height: \(cell.posterCollectionView.frame.height)")
        cell.posterCollectionView.register(UINib(nibName: NibName.posterCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: PosterCollectionViewCell.reuseIdentifier)
//        print("컬렉션뷰 높이: \(cell.posterCollectionView.frame.height)")
//        print("컬렉션뷰 컨텐트 사이즈 높이: \(cell.posterCollectionView.collectionViewLayout.collectionViewContentSize.height)")
//        collectionViewItemHeight = cell.collectionViewItemHeight
//        print("collectionViewItemHeight: \(collectionViewItemHeight)")
//        print("\(cell.frame.height)")
//        cellFrameHeight = cell.frame.height
//        print("cell.contentView.frame.height: \(cell.contentView.frame.height)")
        
//        cell.posterCollectionView.collectionViewLayout = cell.collectionViewLayout()
//        tableView.reloadData()
        
        
        // 여기에서 레이아웃 주면 적용이 안되지만 가로스크롤 문제 없음
//        cell.posterCollectionView.collectionViewLayout = getLayout(collectionView: cell.posterCollectionView)
        cell.posterCollectionView.reloadData()
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("UIScreen.main.bounds.height: \(UIScreen.main.bounds.height / 4.5)")
//        return UIScreen.main.bounds.height / 4.5
//        return 190

//        print("tableView.rowHeight: \(tableView.frame.height)")
//        return tableView.rowHeight
//        return cellFrameHeight + collectionViewItemHeight
        
//        return UITableView.automaticDimension
        
//        let tableViewCellHeightExceptCollectionView = 53.0
//        let collectionViewItemHeight = UIScreen.main.bounds.width / 3.2 * 1.414
//        return tableViewCellHeightExceptCollectionView + collectionViewItemHeight + 8
        print("🥭", #function)
        return UIScreen.main.bounds.height / 4
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
        
        print("🐶 컬렉션뷰 cell.frame.height: \(cell.frame.height)")
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.borderWidth = 10
        
//        collectionView.reloadData()
//        recommendationsTableView.reloadData()
    
        // 여기에서 레이아웃 주면 적용이 되지만 가로스크롤 하면 PosterView instantiate에서 BAD ACCESS 에러
        // 에러가 나는 이유?
//        collectionView.collectionViewLayout = getLayout(collectionView: collectionView)

        
        return cell
    }
}


// ➕📎 RecommendationsTableViewCell에서 나머지 레이아웃 적용하고 아이템사이즈를 DelegateFlowLayout으로 적용하면
// 아이템사이즈 적용되고 런타임 오류도 없음
extension RecommendationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height / 1.414

        return CGSize(width: width, height: height)
    }
}





