//
//  RegEx.swift
//  
//
//  Created by Mathew Gacy on 5/28/23.
//  
//

import Foundation

/// All of the regular expressions in use within readability.
public enum RegEx {
    static let unlikelyCandidates = "/combx|comment|community|disqus|extra|header|menu|remark|rss|shoutbox|sidebar|sponsor|ad-break|agegate|pagination|pager|popup/i"
    static let okMaybeItsACandidate = "/and|article|body|column|main|shadow|instapaper_body|post/i"
    static let positive = "/article|body|content|entry|hentry|main|page|attachment|pagination|post|text|footnote|blog|story/i"
    static let negative = "/combx|comment|com-|contact|foot|footer|_nav|masthead|media|meta|outbrain|promo|related|scroll|shoutbox|sidebar|sponsor|shopping|tags|tool|widget/i"
    static let divToPElements = "/<(a|blockquote|dl|div|img|ol|p|pre|table|ul)/i"
    static let replaceBrs = "/(<br[^>]*>[ \\n\\r\\t]*){2,}/i"
    static let replaceFonts = "/<(/?)font[^>]*>/i"
    static let normalize = "/\\s{2,}/"
    static let killBreaks = "/(<br\\s*/?>(\\s|&nbsp;?)*){1,}/"
    static let video = "///(player\\.|www\\.)?(youtube\\.com|vimeo\\.com|viddler\\.com|twitch\\.tv)/i"
}
