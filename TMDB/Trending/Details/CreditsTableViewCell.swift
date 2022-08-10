//
//  CreditsTableViewCell.swift
//  TMDB
//
//  Created by SC on 2022/08/04.
//

import UIKit

import Kingfisher


class CreditsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    var cast: CastModel?
    
    
    func configureCell() {
        let url = URL(string: Endpoint.imageConfigurationURL + cast!.profilePath)  // 강제해제 하지 않기?
        profileImageView.kf.setImage(with: url)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .lightGray
        profileImageView.layer.cornerRadius = 10
        
        nameLabel.text = cast?.name
        characterLabel.text = cast?.character
        characterLabel.textColor = .lightGray
        characterLabel.font = .systemFont(ofSize: 16.5)
    }

}
