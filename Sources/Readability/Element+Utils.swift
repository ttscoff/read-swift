//
//  Element+Utils.swift
//  
//
//  Created by Mathew Gacy on 5/28/23.
//

import Foundation
import SwiftSoup

public extension Element {
    /// Returns the inner text.
    ///
    /// This also strips out any excess whitespace to be found.
    ///
    /// - Parameter normalizeSpaces: A Boolean value indicating whether spaces should be normalized.
    /// - Returns: The inner text.
    func getInnerText(normalizeSpaces: Bool = true) throws -> String {
        let textContent = try text().trimmingCharacters(in: .whitespacesAndNewlines)
        if normalizeSpaces {
            return textContent.replacingOccurrences(of: RegEx.normalize, with: " ")
        } else {
            return textContent
        }
    }
}
