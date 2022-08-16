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
    private var isCollapsed = true
    
    
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
    
    private func configureButtonImage() {
        showAndHideButton.setImage(UIImage(systemName: isCollapsed ? "chevron.down" : "chevron.up"), for: .normal)
    }
    
    private func configureOverviewLabelLines() {
        overviewLabel.numberOfLines = isCollapsed ? 2 : 0
    }
    
    @IBAction private func foldButtonClicked(_ sender: UIButton) {
        print(#function)
        isCollapsed.toggle()
        configureButtonImage()
        configureOverviewLabelLines()
        print(overviewLabel.numberOfLines)
        delegate?.showAndHideButtonClicked()
    }
    // 강남 성수 을지로 (판교) 투자받기 좋은 위치 개발사
    // 테헤란로....
    // 마포 서대문 여의도는 혼자 할 확률이 높다..
    // 구디 가디 무조건 거르기!!! 야근의 성지..
    // 제조업 거르기
}
