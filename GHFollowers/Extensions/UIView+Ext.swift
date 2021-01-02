//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Jonathan Yataco  on 1/1/21.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
