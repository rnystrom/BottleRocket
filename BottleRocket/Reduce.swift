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
func allObjects(nodes: [Node]) -> [Node] {
    var flat = [Node]()
    for node in nodes {
        switch node {
        case .object(_, _, let properties):
            flat.append(node)
            flat += allObjects(nodes: properties)
        case .array(key: _, let subnode):
            flat += allObjects(nodes: [subnode])
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
        let props: [Node]
        switch node {
        case .object(_, _, let properties): props = properties
        case .array(_, let subnode) :
            switch subnode {
            case .object(_, _, let properties): props = properties
            default: props = []
            }
        default: props = []
        }
        for prop in props {
            switch prop {
            case .unknown: break
            default:
                table[prop.key] = prop;
                countedSet.add(prop.key)
            }
        }
    }
    var optionalNodes = [OptionalNode]()
    for (key, value) in table {
        // the node is optional if its occurence count does not match the total nodes given
        optionalNodes.append((value, countedSet.count(for: key) != nodes.count))
    }
    return optionalNodes
}

func buildClassMap(
    nodes: [Node]
    ) -> [String: [OptionalNode]] {
    let allObjectNodes = allObjects(nodes: nodes)

    var dupeMap = [String: [Node]]()
    for node in allObjectNodes {
        let name = node.type
        var dupes = dupeMap[name] ?? [Node]()
        dupes.append(node)
        dupeMap[name] = dupes
    }

    var result = [String: [OptionalNode]]()
    for (key, nodes) in dupeMap {
        result[key] = findOptionalNodes(nodes: nodes)
    }

    return result
}
