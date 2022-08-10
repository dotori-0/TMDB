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
    var cast: [CastModel] = []
    var crew: [CastModel] = []
    
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
        title = "상세 정보"
        navigationItem.backButtonTitle = "nil"
        
        detailsTableView.dataSource = self
        detailsTableView.delegate = self
        detailsTableView.register(UINib(nibName: OverviewTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: OverviewTableViewCell.reuseIdentifier)
        detailsTableView.register(UINib(nibName: CreditsTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CreditsTableViewCell.reuseIdentifier)
        
//        detailsTableView.rowHeight = UITableView.automaticDimension
//        detailsTableView.estimatedRowHeight = 180

        configureHeaderView()
        fetchCredits()
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
    
    
    func fetchCredits() {
        guard let media = self.media != nil ? self.media : nil else {  // 맞는 구문인지..? data가 nil일 경우 guard let으로 처리하는 방법?
            print("Cannot find media.")
            return
        }
        
        TMDBAPIManager.shared.fetchCredits(media: media) { cast, crew in
            self.cast.append(contentsOf: cast)
            self.crew.append(contentsOf: crew)
            self.detailsTableView.reloadData()
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
            case 1: return cast.count
            case 2: return crew.count
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section != 0 {
            return 100
        } else {
            return UITableView.automaticDimension
//            return 180
        }
        
//        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.reuseIdentifier) as? OverviewTableViewCell else {
                print("Cannot find OverviewTableViewCell")
                return UITableViewCell()
            }
            
            cell.overview = media?.overview
            cell.configureOverviewLabel()
            cell.configureButton()
            
            
            return cell
        } else if section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreditsTableViewCell.reuseIdentifier) as? CreditsTableViewCell else {
                print("Cannot find CreditsTableViewCell")
                return UITableViewCell()
            }
            
            cell.cast = cast[indexPath.row]
            cell.configureCell()
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreditsTableViewCell.reuseIdentifier) as? CreditsTableViewCell else {
                print("Cannot find CreditsTableViewCell")
                return UITableViewCell()
            }
            
            cell.cast = crew[indexPath.row]
            cell.configureCell()
            
            return cell
        }
    }
}


extension DetailsViewController: CustomTableViewCellDelegate {
    func showAndHideButtonClicked() {
        print("Delegate")
        detailsTableView.reloadRows(at: [[0, 0]], with: .fade)
        detailsTableView.reloadData()
    }
}
