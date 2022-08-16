//
//  TrendingViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/03.
//

import UIKit

import Alamofire
import HelpersFramework
//import SkeletonView
import Kingfisher
import SwiftyJSON
import SkeletonView


class TrendingViewController: UIViewController {
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    private var mediaArray: [MediaModel] = []
    
    private var selectedMediaType: String?
    private var selectedMediaID: Int?
    
    private var page = 1
    private var offsetLimit: CGFloat = 8000
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
//        navigationItem.titleView?.tintColor = .black
        
        trendingCollectionView.isSkeletonable = true
        trendingCollectionView.showAnimatedGradientSkeleton(animation: GradientDirection.topLeftBottomRight.slidingAnimation())
        
        trendingCollectionView.dataSource = self
        trendingCollectionView.delegate = self
        
        trendingCollectionView.register(UINib(nibName: TrendingCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TrendingCollectionViewCell.reuseIdentifier)
        
//        print("CollectionView-masksToBounds", trendingCollectionView.layer.masksToBounds)  // false
//        print("CollectionView-clipsToBounds", trendingCollectionView.clipsToBounds)        // false

        configureCollectionViewLayout()
        
        fetchData()
//        TMDBAPIManager.shared.fetchData(page: page) { mediaArray in
//            print("self.mediaArray.count: \(self.mediaArray.count)")
//            self.mediaArray = mediaArray
//            print("self.mediaArray.count: \(self.mediaArray.count)")
//
//            self.trendingCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))  // 여기에서 hide 하지 않으면 스크롤 불가
//
//            self.trendingCollectionView.reloadData()
//        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        trendingCollectionView.isSkeletonable = true
//        trendingCollectionView.showAnimatedGradientSkeleton(animation: GradientDirection.topLeftBottomRight.slidingAnimation())
////        trendingCollectionView.showAnimatedSkeleton(us , animation: GradientDirection.topLeftBottomRight.slidingAnimation())
//    }
    
    
    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = UIScreen.main.bounds.width * 0.02
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 20
        
        layout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        layout.minimumLineSpacing = 48
//        layout.minimumInteritemSpacing  // 열이 1 개 이므로 생략
        
        let width = UIScreen.main.bounds.width - (horizontalInset * 2)
        layout.itemSize = CGSize(width: width, height: width * 1.15)
        
        trendingCollectionView.collectionViewLayout = layout
    }
    
    
    private func fetchData() {
        print(#function, page)
        TMDBAPIManager.shared.fetchData(page: page) { mediaArray in
            print("self.mediaArray.count: \(self.mediaArray.count)")
            self.mediaArray.append(contentsOf: mediaArray)
            print("self.mediaArray.count: \(self.mediaArray.count)")
            
            self.trendingCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))  // 여기에서 hide 하지 않으면 스크롤 불가
                                    
            self.trendingCollectionView.reloadData()
        }
    }
    
    
    @objc
//    func openWebView(mediaType: String, mediaID: Int) {
    private func openWebView() {
        let sb = UIStoryboard(name: "Web", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: WebViewController.reuseIdentifier) as? WebViewController else {
            print("Cannot find WebViewController")
            return
        }
        
        // 여기에서 video를 받아서 넘겨주는 것이 나은지, WebViewController에서 video를 받는 것이 나은지?
//        vc.media = selectedMedia
        vc.mediaType = selectedMediaType
        vc.mediaID = selectedMediaID
        
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension TrendingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("페이지: \(page) - \(mediaArray[indexPath.item].title)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.reuseIdentifier, for: indexPath) as? TrendingCollectionViewCell else {
            print("Cannot find TrendingCollectionViewCell")
            return UICollectionViewCell()
        }

        cell.isSkeletonable = true
//        cell.showAnimatedSkeleton()
        // cell의 cornerRadius를 넘어서 덮어 버리고, 데이터가 보이지 않음

        let data = mediaArray[indexPath.item]

        cell.configureCell(data: data)
        cell.skeletonizeAll()
        
        cell.backdropImageView.showAnimatedGradientSkeleton(animation: GradientDirection.topLeftBottomRight.slidingAnimation())
        
        let url = URL(string: Endpoint.imageConfigurationURL + data.backdropPath)
        cell.backdropImageView.kf.setImage(with: url) { result in
            switch result {
                case .success:
//                    print("🍒 성공")
//                    self.trendingCollectionView.hideSkeleton()
                    cell.backdropImageView.hideSkeleton()
//                    print("🍒 성공")
                case .failure(let error):
                    print(error)
            }
        }

        selectedMediaType = data.mediaType
        selectedMediaID = data.id
        cell.trailerButton.addTarget(self, action: #selector(openWebView), for: .touchUpInside)


        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: DetailsViewController.reuseIdentifier) as? DetailsViewController else {
            print("Cannot find DetailsViewController")
            return
        }
        
        vc.media = mediaArray[indexPath.item]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
        if scrollView.contentOffset.y > offsetLimit {
            page += 1
            offsetLimit += 8000
            fetchData()
        }
    }
}


extension TrendingViewController: SkeletonCollectionViewDataSource {
//    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TrendingCollectionViewCell.reuseIdentifier
    }
    
//    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return mediaArray.count
//    }
//
//    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
//        print("페이지: \(page) - \(mediaArray[indexPath.item].title)")
//        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.reuseIdentifier, for: indexPath) as? TrendingCollectionViewCell else {
//            print("Cannot find TrendingCollectionViewCell")
//            return UICollectionViewCell()
//        }
//
////        cell.isSkeletonable = true
////        cell.showAnimatedSkeleton()
//        // cell의 cornerRadius를 넘어서 덮어 버리고, 데이터가 보이지 않음
//
//        let data = mediaArray[indexPath.item]
//
//        cell.configureCell(data: data)
//
//
////        cell.trailerButton.addTarget(self, action: #selector(openWebView(mediaType: data.mediaType, mediaID: data.id)), for: .touchUpInside)
//        selectedMediaType = data.mediaType
//        selectedMediaID = data.id
//        cell.trailerButton.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
//
//
//        return cell
//    }
    

}
