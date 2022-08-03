//
//  UICollectionViewCell+Extension.swift
//  TMDB
//
//  Created by SC on 2022/08/03.
//

import UIKit

extension UICollectionViewCell: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
