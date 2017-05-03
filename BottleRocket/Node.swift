//
//  Node.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

public indirect enum Node {

    case scalar(key: String, type: String, encodeType: String)
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
        case .array(_, let obj): return obj.type
        case .unknown: return ""
        }
    }
}
