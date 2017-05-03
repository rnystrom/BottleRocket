//
//  Reduce.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/3/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

extension Node {

    var allKeys: [String] {
        var keys = [String]()
        switch self {
        case .object(_, _, let properties):
            keys += properties.map { $0.key }
        default: break
        }
        return keys
    }

}

// travels the tree and returns an array of all Node.object types
func flatten(nodes: [Node]) -> [Node] {
    var flat = [Node]()
    for node in nodes {
        switch node {
        case .object(_, _, let properties):
            flat.append(node)
            flat += flatten(nodes: properties)
        default: break
        }
    }
    return flat
}

// scan all object nodes and return an array of properties with optionality discovered
// node property is optional if it does not occur in every top-level node
func findOptionalNodes(nodes: [Node]) -> [OptionalNode] {
    let countedSet = NSCountedSet()
    var table = [String: Node]()
    for node in nodes {
        switch node {
        case .object(_, _, let properties):
            for prop in properties {
                table[prop.key] = prop;
                countedSet.add(prop.key)
            }
        default: break
        }
    }
    var optionalNodes = [OptionalNode]()
    for (key, value) in table {
        // the node is optional if its occurence count does not match the total nodes given
        optionalNodes.append((value, countedSet.count(for: key) != nodes.count))
    }
    return optionalNodes
}


