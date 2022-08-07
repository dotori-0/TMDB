//
//  TrendingViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON


class TrendingViewController: UIViewController {
    
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    var mediaArray: [MediaModel] = []
    
    var selectedMediaType: String?
    var selectedMediaID: Int?
    
    var page = 1
    var offsetLimit: CGFloat = 8000
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonTitle = ""
//        navigationItem.titleView?.tintColor = .black
        
        trendingCollectionView.dataSource = self
        trendingCollectionView.delegate = self
        
        trendingCollectionView.register(UINib(nibName: TrendingCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TrendingCollectionViewCell.reuseIdentifier)
        
        print("CollectionView-masksToBounds", trendingCollectionView.layer.masksToBounds)
        print("CollectionView-clipsToBounds", trendingCollectionView.clipsToBounds)

        configureCollectionViewLayout()
        
        fetchData()
    }
    
    
    func configureCollectionViewLayout() {
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
    
    
    func fetchData() {
        print("fetchData starting")
//        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!  // 옵셔널이기 때문에 타입 어노테이션이나 가드구문 등으로 처리
        let url = Endpoint.trendingURL + APIKey.TMDB + "&page=\(page)"
        
//        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
//        let parameters = [
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    
                    // json["results"].arrayValue는 배열, 배열 내의 요소는 모두 딕셔너리
//                    print(json["results"])  // .arrayValue 하지 않아도 되는 이유?
                    
                    for result in json["results"].arrayValue {
                        let mediaType = result["media_type"].stringValue
                        let title = mediaType == "movie" ? result["title"].stringValue : result["name"].stringValue
                        let id = result["id"].intValue
                        let backdropPath = result["backdrop_path"].stringValue
//                        guard let genreIDs = result["genre_ids"].arrayValue as? [Int] else {
//                            print("실패")
//                            return
//                        }
//                        print(genreIDs)
//                        print(type(of: genreIDs))
                        let genreID = result["genre_ids"][0].intValue
//                        print("genreID", genreID)
                        let releaseDate = result["release_date"].stringValue
                        
                        let voteAverage = result["vote_average"].doubleValue
                        let overview = result["overview"].stringValue

                        let mediaModel = MediaModel(title: title, mediaType: mediaType, id: id, backdropPath: backdropPath, posterPath: nil, genreID: genreID, releaseDate: releaseDate, voteAverage: voteAverage, overview: overview)
                        self.mediaArray.append(mediaModel)

//                        print(self.mediaArray.count)
//
                        self.trendingCollectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
        print("fetchData ending")
    }
    
    
    @objc
//    func openWebView(mediaType: String, mediaID: Int) {
    func openWebView() {
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
        
        let data = mediaArray[indexPath.item]
        
        cell.configureCell(data: data)

//        cell.trailerButton.addTarget(self, action: #selector(openWebView(mediaType: data.mediaType, mediaID: data.id)), for: .touchUpInside)
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
