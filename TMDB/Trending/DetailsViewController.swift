//
//  DetailsViewController.swift
//  TMDB
//
//  Created by SC on 2022/08/04.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON


class DetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var media: MediaModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        guard let media = self.media != nil ? self.media : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
//            print("Cannot find media.")
//            return
//        }
        
        fetchDetails()
        configureHeaderView()
    }
    

    func configureHeaderView() {
        guard let media = self.media != nil ? self.media : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
            print("Cannot find media.")
            return
        }
        
        let url = URL(string: Endpoint.configurationURL + media.backdropPath)
        backdropImageView.kf.setImage(with: url)
        backdropImageView.contentMode = .scaleAspectFill
    }
    
    func fetchDetails() {
        guard let media = self.media != nil ? self.media : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
            print("Cannot find media.")
            return
        }
        
        var url: String
        
        url = ("\(Endpoint.detailsURL)\(media.mediaType)/\(media.id)?api_key=\(APIKey.TMDB)")
        // https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US
        // https://api.themoviedb.org/3/tv/{tv_id}?api_key=<<api_key>>&language=en-US
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    // json["results"].arrayValue는 배열, 배열 내의 요소는 모두 딕셔너리
//                    print(json["results"])  // .arrayValue 하지 않아도 되는 이유?
                    
//                    for result in json["results"].arrayValue {//
//                        let title = result["title"].stringValue
//                        let mediaType = result["media_type"].stringValue
//                        let backdropPath = result["backdrop_path"].stringValue
////                        guard let genreIDs = result["genre_ids"].arrayValue as? [Int] else {
////                            print("실패")
////                            return
////                        }
////                        print(genreIDs)
////                        print(type(of: genreIDs))
//                        let genreID = result["genre_ids"][0].intValue
//                        print("genreID", genreID)
//                        let releaseDate = result["release_date"].stringValue
//
//                        let voteAverage = result["vote_average"].doubleValue
//                        let overview = result["overview"].stringValue
//
//                        let mediaModel = MediaModel(title: title, mediaType: mediaType, backdropPath: backdropPath, genreID: genreID, releaseDate: releaseDate, voteAverage: voteAverage, overview: overview)
//                        self.mediaArray.append(mediaModel)
//
//                        print(self.mediaArray.count)
////
//                        self.trendingCollectionView.reloadData()
//                    }
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
}
