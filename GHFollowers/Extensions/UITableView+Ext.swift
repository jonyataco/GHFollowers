//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Jonathan Yataco  on 1/1/21.
//

import UIKit

extension UITableView {

    func reloadDateOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }

    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
