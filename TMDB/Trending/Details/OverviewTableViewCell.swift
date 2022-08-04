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
    @IBOutlet weak var foldButton: UIButton!
    
    var overview: String?
    var isFolded = true
    
    func configureOverviewLabel() {
        overviewLabel.numberOfLines = 2
        overviewLabel.text = overview ?? "Could not fetch overview data. Please try again."
    }
    
    func configureFoldButton() {
        foldButton.setTitle("", for: .normal)
        foldButton.tintColor = .label
        configureFoldButtonImage()
    }
    
    func configureFoldButtonImage() {
        foldButton.setImage(UIImage(systemName: isFolded ? "chevron.down" : "chevron.up"), for: .normal)
    }
    
    @IBAction func foldButtonClicked(_ sender: UIButton) {
        print(#function)
        overviewLabel.numberOfLines = 0
        isFolded.toggle()
        configureFoldButtonImage()
        delegate?.foldButtonClicked()
    }
}
