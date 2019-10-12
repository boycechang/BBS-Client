//
//  MarkDownParser.swift
//  BYR
//
//  Created by Boyce on 10/11/19.
//  Copyright © 2019 Ethan. All rights reserved.
//

import Foundation
import Down

@objc open class MarkDownParser : NSObject {
    let down : Down
    
    @objc public init(string : String) {
        down = Down(markdownString: string)
    }
    
    @objc func parse(styler: Styler) -> NSAttributedString {
        let attr = try! down.toAttributedString(styler: styler)
        return attr
    }
}
