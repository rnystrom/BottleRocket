//
//  genModel.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/3/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

func wrapGuard(base: String, required: Bool) -> String {
    return "guard \(base) else { return nil }"
}

func renderParsing(name: String, type: String, required: Bool) -> String {
    return wrapGuard(
        base: "let \(name) = json[Keys.\(name)] as? \(type)",
        required: required
    )
}

func renderParsingScalar(name: String, type: String, required: Bool) -> [String] {
    return [ renderParsing(name: name, type: type, required: required) ]
}

func renderParsingObject(name: String, type: String, required: Bool) -> [String] {
    let jsonName = "\(name)JSON"
    let unpack = renderParsing(name: "\(jsonName)", type: "[String: Any]", required: required)
    let initObject = wrapGuard(
        base: "let \(name) = \(type)(json: \(jsonName))",
        required: required
    )
    return [ unpack, initObject ]
}

func renderInitCall(nodes: [Node]) -> [String] {
    let params = nodes.map { $0.key + ": " + $0.key + "," }
    return ["self.init("] + params + [")"]
}
