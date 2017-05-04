//
//  Node.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

public indirect enum Node {

    public enum EncodeType: String {
        // used by custom objects, NSNumber, String, and Array
        case object = "Object"
        case bool = "Bool"
    }

    case scalar(key: String, type: String, encodeType: EncodeType)
    case object(key: String, type: String, properties: [Node])
    case array(key: String, node: Node)
    case unknown

    var key: String {
        switch self {
        case .scalar(let key, _, _): return key
        case .object(let key, _, _): return key
        case .array(let key, _): return key
        case .unknown: return ""
        }
    }

    var type: String {
        switch self {
        case .scalar(_, let type, _): return type
        case .object(_, let type, _): return type
        case .array(_, let obj): return "[\(obj.type)]"
        case .unknown: return ""
        }
    }

    var encodeType: EncodeType {
        switch self {
        case .scalar(_, _, let encodeType): return encodeType
        default: return .object
        }
    }
    
}
