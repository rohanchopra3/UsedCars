//
//  Extensions.swift
//  Used Cars
//
//  Created by Rohan Chopra on 7/12/21.
//

import Foundation

extension String {
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1-$2-$3", options: .regularExpression, range: nil)
    }
}
