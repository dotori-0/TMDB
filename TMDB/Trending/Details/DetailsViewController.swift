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
    @IBOutlet weak var detailsTableView: UITableView!
    
    var media: MediaModel?
    
//    enum isFolded {
//        static var value = true {
//            willSet {
//                reloadSection()
//            }
//        }
//    }
//
//    func reloadSection() {
//        detailsTableView.reloadSections(IndexSet(0), with: true)
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        guard let media = self.media != nil ? self.media : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
//            print("Cannot find media.")
//            return
//        }
        
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.register(UINib(nibName: OverviewTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: OverviewTableViewCell.reuseIdentifier)
        detailsTableView.rowHeight = UITableView.automaticDimension

        fetchDetails()
//        configureHeaderView()
    }
    
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


extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return 1
            case 1: return 0
            case 2: return 0
            default:
                print("Error in numberOfRowsInSection")
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "Overview"
            case 1: return "Cast"
            case 2: return "Crew"
            default:
                print("Error in titleForHeaderInSection")
                return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.reuseIdentifier) as? OverviewTableViewCell else {
                print("Cannot find OverviewTableViewCell")
                return UITableViewCell()
            }
            
            cell.overview = media?.overview
            cell.configureOverviewLabel()
            cell.configureFoldButton()
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}


extension DetailsViewController: CustomTableViewCellDelegate {
    func foldButtonClicked() {
        print("Delegate")
        detailsTableView.reloadRows(at: [[0, 0]], with: .fade)
        detailsTableView.reloadData()
    }
}
