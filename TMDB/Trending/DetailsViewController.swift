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
//        checkMedia()
        fetchDetails()
//        configureHeaderView()
    }
    
    
//    func checkMedia() {
//        if media == nil {
//            print("Cannot find media")
//        } else {
//            media = media!
//        }
//    }
    

    func configureHeaderView() {
        titleLabel.text = media?.title
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        titleLabel.layer.shadowRadius = 10
        titleLabel.layer.shadowOpacity = 1.0
        
        let backdropURL = URL(string: Endpoint.configurationURL + (media?.backdropPath)!)  // 강제해제 하지 않기?
        backdropImageView.kf.setImage(with: backdropURL)
        backdropImageView.contentMode = .scaleAspectFill
        
        let posterURL = URL(string: Endpoint.configurationURL + (media?.posterPath)!)  // 강제해제 하지 않기?
        posterImageView.kf.setImage(with: posterURL)
        posterImageView.contentMode = .scaleAspectFill
    }
    
    
    func fetchDetails() {
        guard let media = self.media != nil ? self.media : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
            print("Cannot find media.")
            return
        }
        
        let url = "\(Endpoint.detailsURL)\(media.mediaType)/\(media.id)?api_key=\(APIKey.TMDB)"
        // https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US
        // https://api.themoviedb.org/3/tv/{tv_id}?api_key=<<api_key>>&language=en-US
        
        AF.request(url, method: .get).validate(statusCode: 200..<400).responseData { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("JSON: \(json)")
                    
                    let posterPath = json["poster_path"].stringValue
                    
                    self.media?.posterPath = posterPath
//
                    self.configureHeaderView()
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
}
