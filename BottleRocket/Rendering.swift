//
//  genModel.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/3/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

typealias OptionalNode = (node: Node, optional: Bool)

prefix operator -->

prefix func --> (strs: [String]) -> [String] {
    return strs.map { "  " + $0 }
}

extension Node {
    var displayName: String {
        return cleanKey(for: key)
    }
}

func wrapGuard(
    base: String,
    optional: Bool
    ) -> String {
    if optional {
        return base
    }
    return "guard \(base) else { return nil }"
}

func appendCommas(
    lines: [String]
    ) -> [String] {
    var newLines = [String]()
    for line in lines {
        if line == lines.last {
            newLines.append(line)
        } else {
            newLines.append(line + ",")
        }
    }
    return newLines
}

func renderParsing(
    name: String,
    key: String,
    type: String,
    optional: Bool
    ) -> String {
    return wrapGuard(
        base: "let \(name) = json?[Keys.\(key)] as? \(type)",
        optional: optional
    )
}

func renderParsingScalar(
    name: String,
    type: String,
    optional: Bool
    ) -> [String] {
    let parse = renderParsing(
        name: name,
        key: name,
        type: type,
        optional: optional
    )
    return [ parse ]
}

func renderParsingObject(
    name: String,
    type: String,
    optional: Bool
    ) -> [String] {
    let jsonName = "\(name)JSON"
    let unpack = renderParsing(
        name: "\(jsonName)",
        key: name,
        type: "[String: Any]",
        optional: optional
    )
    let initObject = wrapGuard(
        base: "let \(name) = \(type)(json: \(jsonName))",
        optional: optional
    )
    return [ unpack, initObject ]
}

func renderParsingArray(name: String, node: Node, optional: Bool) -> [String] {
    switch node {
    case .scalar(_, let type, _):
        return [ renderParsing(name: name, key: name, type: "[\(type)]", optional: optional) ]
    case .object(_, let type, _):
        let jsonName = "\(name)JSON"
        return [
            renderParsing(name: jsonName, key: name, type: "[ [String: Any] ]", optional: optional),
            "var \(name) = [\(type)]()",
            "for dict in \(jsonName) ?? [] {",
            "  if let object = \(type)(json: dict) {",
            "    \(name).append(object)",
            "  }",
            "}"
        ]
    default:
        return []
    }
}

func renderInitCall(
    nodes: [Node]
    ) -> [String] {
    let params = nodes.map { "\($0.displayName): \($0.displayName)" }
    let paramsWithCommas = appendCommas(lines: params)
    return [ "self.init(" ]
        + -->paramsWithCommas
        + [ ")" ]
}

func renderDecode(
    name: String,
    encodeType: Node.EncodeType,
    type: String,
    optional: Bool
    ) -> String {
    let cast: String
    let typeOptional: Bool
    switch encodeType {
    case .object:
        cast = " as? \(type)"
        typeOptional = optional
    default:
        cast = ""
        // removes the guard wrap
        typeOptional = true
    }
    return wrapGuard(
        base: "let \(name) = aDecoder.decode\(encodeType.rawValue)(forKey: Keys.\(name))\(cast)",
        optional: typeOptional
    )
}

func renderEncode(
    name: String
    ) -> String {
    return "aCoder.encode(\(name), forKey: Keys.\(name))"
}

func renderInitDecode(
    optionalNodes: [OptionalNode]
    ) -> [String] {
    return [ "convenience init?(coder aDecoder: NSCoder) {" ]
        + -->optionalNodes.map {
            renderDecode(
                name: $0.node.displayName,
                encodeType: $0.node.encodeType,
                type: $0.node.type,
                optional: $0.optional
            )
        }
        + -->renderInitCall(nodes: optionalNodes.map { $0.node })
        + [ "}" ]
}

func renderEncode(
    nodes: [Node]
    ) -> [String]{
    return [ "func encode(with aCoder: NSCoder) {" ]
        + -->nodes.map { renderEncode(name: $0.displayName) }
        + [ "}" ]
}

func renderKeys(
    nodes: [Node]
    ) -> [String] {
    return [ "struct Keys {" ]
        + -->nodes.map { "static let \($0.displayName) = \"\($0.key)\"" }
        + [ "}" ]
}

func renderInitializer(
    optionalNodes: [OptionalNode]
    ) -> [String] {
    let paramLines = optionalNodes.map { "\($0.node.displayName): \($0.node.type)\($0.optional ? "?" : "")" }
    let paramLinesWithComma = appendCommas(lines: paramLines)

    return [ "init(" ]
        + -->paramLinesWithComma
        + -->[ ") {" ]
        + -->optionalNodes.map { "self.\($0.node.displayName) = \($0.node.displayName)" }
        + [ "}" ]
}

func renderProperties(
    optionalNodes: [OptionalNode]
    ) -> [String] {
    return optionalNodes.map { "let \($0.node.displayName): \($0.node.type)\($0.optional ? "?" : "")" }
}

func renderInitJSON(
    optionalNodes: [OptionalNode]
    ) -> [String] {

    var parsingLines = [String]()
    for pair in optionalNodes {
        let displayName = pair.node.displayName
        switch pair.node {
        case .scalar(_, let type, _):
            parsingLines += renderParsingScalar(name: displayName, type: type, optional: pair.optional)
        case .object(_, let type, _):
            parsingLines += renderParsingObject(name: displayName, type: type, optional: pair.optional)
        case .array(_, let node):
            parsingLines += renderParsingArray(name: displayName, node: node, optional: pair.optional)
        default: break
        }
    }

    return [ "convenience init?(json: [String: Any]?) {" ]
        + -->parsingLines
        + -->renderInitCall(nodes: optionalNodes.map { $0.node })
        + [ "}" ]
}

func renderClass(
    name: String,
    optionalNodes: [OptionalNode]
    ) -> [String] {
    let nodes = optionalNodes.map { $0.node }

    // written this way to appease the swift compiler
    let keys = -->renderKeys(nodes: nodes)
    let properties = -->renderProperties(optionalNodes: optionalNodes)
    let initJSON = -->renderInitJSON(optionalNodes: optionalNodes)
    let initializer = -->renderInitializer(optionalNodes: optionalNodes)
    let initDecode = -->renderInitDecode(optionalNodes: optionalNodes)
    let encode = -->renderEncode(nodes: nodes)

    var result = [String]()
    result.append("final class \(name): NSCoding {")
    result.append(contentsOf: keys)
    result.append(contentsOf: properties)
    result.append(contentsOf: initJSON)
    result.append(contentsOf: initializer)
    result.append(contentsOf: initDecode)
    result.append(contentsOf: encode)
    result.append("}")

    return result
}
