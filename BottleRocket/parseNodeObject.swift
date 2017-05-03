//
//  parseNodeObject.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/2/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

func parseNodeObject(key: String, dict: [String: Any]) -> Node {
    var properties = [Node]()
    for (key, value) in dict {
        properties.append(parseNode(key: key, value: value))
    }
    return .object(
        key: key,
        type: typeName(for: key),
        properties: properties
    )
}
