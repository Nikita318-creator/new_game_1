//
//  String+.swift
//  Baraban
//
//  Created by никита уваров on 23.08.24.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
