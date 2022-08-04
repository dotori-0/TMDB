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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let url = Endpoint.trendingURL + APIKey.TMDB
        
//        let headers: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
//        let parameters = [
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
//                    print("JSON: \(json)")
                    
                    // json["results"].arrayValue는 배열, 배열 내의 요소는 모두 딕셔너리
//                    print(json["results"])  // .arrayValue 하지 않아도 되는 이유?
                    
                    for result in json["results"].arrayValue {//
                        let title = result["title"].stringValue
                        let mediaType = result["media_type"].stringValue
                        let id = result["id"].intValue
                        let backdropPath = result["backdrop_path"].stringValue
//                        guard let genreIDs = result["genre_ids"].arrayValue as? [Int] else {
//                            print("실패")
//                            return
//                        }
//                        print(genreIDs)
//                        print(type(of: genreIDs))
                        let genreID = result["genre_ids"][0].intValue
                        print("genreID", genreID)
                        let releaseDate = result["release_date"].stringValue
                        
                        let voteAverage = result["vote_average"].doubleValue
                        let overview = result["overview"].stringValue

                        let mediaModel = MediaModel(title: title, mediaType: mediaType, id: id, backdropPath: backdropPath, posterPath: nil, genreID: genreID, releaseDate: releaseDate, voteAverage: voteAverage, overview: overview)
                        self.mediaArray.append(mediaModel)

                        print(self.mediaArray.count)
//
                        self.trendingCollectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
        print("fetchData ending")
    }
}


extension TrendingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCollectionViewCell.reuseIdentifier, for: indexPath) as? TrendingCollectionViewCell else {
            print("Cannot find TrendingCollectionViewCell")
            return UICollectionViewCell()
        }
        
        cell.configureCell(data: mediaArray[indexPath.item])
        
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
}
