//
//  OverviewTableViewCell.swift
//  TMDB
//
//  Created by SC on 2022/08/04.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {
    var delegate: CustomTableViewCellDelegate?

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var showAndHideButton: UIButton!
    
    var overview: String?
    var isCollapsed = true
    
    
    func configureOverviewLabel() {
        overviewLabel.sizeToFit()
        overviewLabel.numberOfLines = 2
        overviewLabel.text = overview ?? "Could not fetch overview data. Please try again."
    }
    
    func configureButton() {
        showAndHideButton.setTitle("", for: .normal)
        showAndHideButton.tintColor = .label
        configureButtonImage()
    }
    
    func configureButtonImage() {
        showAndHideButton.setImage(UIImage(systemName: isCollapsed ? "chevron.down" : "chevron.up"), for: .normal)
    }
    
    func configureOverviewLabelLines() {
        overviewLabel.numberOfLines = isCollapsed ? 2 : 0
    }
    
    @IBAction func foldButtonClicked(_ sender: UIButton) {
        print(#function)
        isCollapsed.toggle()
        configureButtonImage()
        configureOverviewLabelLines()
        delegate?.showAndHideButtonClicked()
    }
}
