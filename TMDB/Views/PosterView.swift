//
//  PosterView.swift
//  TMDB
//
//  Created by SC on 2022/08/09.
//

import UIKit

class PosterView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        guard let view = UINib(nibName: NibName.posterView, bundle: nil).instantiate(withOwner: self).first as? UIView else {
            print("Error while getting \(NibName.posterView)")
            return
        }
        
        view.frame = bounds
        self.addSubview(view)
    }
}
