//
//  parseNode.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

func parseNode(key: String, value: Any) -> Node {
    switch value {
    case _ as Bool: return .scalar(key: key, type: "Bool", encodeType: "Bool")
    case _ as String: return .scalar(key: key, type: "String", encodeType: "Object")
    case _ as Double: return .scalar(key: key, type: "Double", encodeType: "Double")
    case _ as Int: return .scalar(key: key, type: "Int", encodeType: "Integer")
    case let arr as [Any] where arr.count > 0: return .array(key: key, node: parseNode(key: key, value: arr.first!))
    case let dict as [String: Any]: return parseNodeObject(key: key, dict: dict)
    default: return .unknown
    }
}
