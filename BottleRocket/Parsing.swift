//
//  parseNode.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

func parseNodeObject(key: String, dict: [String: Any], renameMap: [String: String] = [:]) -> Node {
    var properties = [Node]()
    for (key, value) in dict {
        properties.append(parseNode(key: key, value: value, renameMap: renameMap))
    }

    let mappedType = renameMap[key] ?? key
    let type = typeName(for: mappedType)

    return .object(
        key: key,
        type: type,
        properties: properties
    )
}

private let trueNumber = NSNumber(value: true)
private let falseNumber = NSNumber(value: false)
private let trueObjCType = String(cString: trueNumber.objCType)
private let falseObjCType = String(cString: falseNumber.objCType)

// MARK: - NSNumber: Comparable

extension NSNumber {
    var isBool:Bool {
        get {
            let objCType = String(cString: self.objCType)
            if (self.compare(trueNumber) == .orderedSame && objCType == trueObjCType) || (self.compare(falseNumber) == .orderedSame && objCType == falseObjCType){
                return true
            } else {
                return false
            }
        }
    }
}

func parseNode(key: String, value: Any, renameMap: [String: String] = [:]) -> Node {
    switch value {
    case let number as NSNumber:
        if number.isBool {
            return .scalar(key: key, type: "Bool", encodeType: .bool)
        } else {
            return .scalar(key: key, type: "NSNumber", encodeType: .object)
        }
    case _ as String: return .scalar(key: key, type: "String", encodeType: .object)
    case let arr as [Any] where arr.count > 0: return .array(key: key, node: parseNode(key: key, value: arr.first!, renameMap: renameMap))
    case let dict as [String: Any]: return parseNodeObject(key: key, dict: dict, renameMap: renameMap)
    default:
        print("Key \(key) with value \(value) not supported")
        return .unknown
    }
}

func parseConfig(json: Any?) -> Config {
    let dict = json as? [String: Any]
    let destination = dict?["destination"] as? String ?? ""
    let renameMap = dict?["rename_map"] as? [String: String] ?? [:]
    return Config(
        destination: destination,
        renameMap: renameMap
    )
}
