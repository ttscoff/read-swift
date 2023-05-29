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

    /// Returns the number of times a given string appears.
    ///
    /// - Parameter s: The string to count.
    /// - Returns: The number of times the given string appears.
    func getCharCount(s: String = ",") throws -> Int {
        try getInnerText().rangesOfString(s: s).count
    }

    /// Removes the style attribute.
    func cleanStyles() throws {
        try getAllElements().array().forEach {
            try $0.removeAttr("style")
        }
    }

    /// Returns the density of links as a percentage of content.
    ///
    /// This is the amount of text that is inside a link divided by the total text in the node.
    func getLinkDensity() throws -> Float {
        let links = try getElementsByTag("a")
        let textLength = try getInnerText().count
        var linkLength = 0

        for link in links {
            linkLength += try link.getInnerText().count
        }

        if textLength > 0 {
            return Float(linkLength / textLength)
        } else {
            return 0
        }
    }

    /// Returns the element's class/id weight.
    ///
    /// Uses regular expressions to tell if this element looks good or bad.
    func getClassWeight() throws -> Int {
        var weight = 0

        // Look for a special classname
        if try hasAttr("class") && attr("class") != "" {
            if try attr("class").matches(RegEx.negative) {
                weight -= 25
            }

            if try attr("class").matches(RegEx.positive) {
                weight += 25
            }
        }

        // Look for a special ID
        if try hasAttr("id") && attr("id") != "" {
            if try attr("id").matches(RegEx.negative) {
                weight -= 25
            }

            if try attr("id").matches(RegEx.positive) {
                weight += 25
            }
        }

        return weight
    }

    /// Clean a node of all elements of a given tag (unless it's a youtube/vimeo video; people love movies).
    /// - Parameter tag: The elements to clean.
    func clean(tag: String) throws {
        let isEmbed = (tag == "iframe" || tag == "object" || tag == "embed")
        for element in try getElementsByTag(tag).array() {
            // Allow youtube and vimeo videos through as people usually want to see those.
            if isEmbed {
                var attributeValues = ""
                if let attributes = element.getAttributes() {
                    for il in attributes {
                        attributeValues = il.getValue() + "|" // DOMAttr?
                    }
                }

                // First, check the elements attributes to see if any of them contain youtube or vimeo
                if attributeValues.matches(RegEx.video) {
                    continue
                }

                // Then check the elements inside this element for the same.
                if try element.html().matches(RegEx.video) {
                    continue
                }
            }

            try element.parent()?.removeChild(element)
        }
    }

    /// Clean out spurious headers from an Element. Checks things like classnames and link density.
    ///
    /// - Parameter getClassWeight: A Boolean value indicated whether class weights should be calculated.
    func cleanHeaders(getClassWeight: Bool) throws {
        for headerIndex in 1 ... 2 {
            for header in try getElementsByTag("h\(headerIndex)").array()  {
                let classWeight = getClassWeight ? try header.getClassWeight() : 0
                let linkDensity = try header.getLinkDensity()

                if classWeight < 0 || linkDensity > 0.33 {
                    try header.parent()?.removeChild(header)
                }
            }
        }
    }
}

internal extension Element {
    /// Reverts P elements with class `readability-styled` to text nodes - which is what they were before.
    func revertReadabilityStyledElements() throws {
        guard let owner = ownerDocument() else {
            return
        }

        for element in try select("p.readability-styled").array() {
            try element.parent()?.replaceChild(owner.appendText(element.text()), element)
        }
    }
}
