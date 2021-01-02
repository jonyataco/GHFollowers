//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Jonathan Yataco  on 12/25/20.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
