//
//  UITableViewCell+Extension.swift
//  TMDB
//
//  Created by SC on 2022/08/04.
//

import UIKit

extension UITableViewCell: ReusableProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
