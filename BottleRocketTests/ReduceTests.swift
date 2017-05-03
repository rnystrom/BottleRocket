//
//  ReduceTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/3/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class ReduceTests: XCTestCase {

    func test_whenFlattening_withThreeDeepTree() {
        let childrenChildren = [
            Node.scalar(key: "count", type: "Integer", encodeType: .integer),
            Node.object(key: "another_object", type: "MyObject", properties: [])
        ]
        let children = [
            Node.scalar(key: "scalar_key", type: "String", encodeType: .object),
            Node.object(key: "first_object", type: "Type", properties: childrenChildren),
            Node.object(key: "empty_props", type: "Empty", properties: [])
        ]
        let root = Node.object(key: "root", type: "Root", properties: children)
        let root2 = Node.object(key: "root2", type: "Root2", properties: [])
        let result = flatten(nodes: [root, root2])
        XCTAssertEqual(result.count, 5)
    }

    func test_whenAccessingKeys() {
        let children = [
            Node.scalar(key: "foo", type: "String", encodeType: .object),
            Node.object(key: "bar", type: "Type", properties: []),
            Node.object(key: "baz", type: "Empty", properties: [])
        ]
        let root = Node.object(key: "root", type: "Root", properties: children)
        let result = root.allKeys
        let expectation = ["foo", "bar", "baz"]
        XCTAssertEqual(result, expectation)
    }

    func test_whenCollectingOptionalNodes() {
        let children1 = [
            Node.scalar(key: "a", type: "String", encodeType: .object),
            Node.scalar(key: "b", type: "Int", encodeType: .integer),
        ]
        let root1 = Node.object(key: "root1", type: "Root", properties: children1)

        let children2 = [
            Node.scalar(key: "a", type: "String", encodeType: .object),
            Node.scalar(key: "b", type: "Int", encodeType: .integer),
            Node.object(key: "c", type: "Empty", properties: [])
        ]
        let root2 = Node.object(key: "root2", type: "Root", properties: children2)

        let children3 = [
            Node.scalar(key: "a", type: "String", encodeType: .object),
            Node.object(key: "c", type: "Empty", properties: [])
        ]
        let root3 = Node.object(key: "root3", type: "Root", properties: children3)

        let result = findOptionalNodes(nodes: [root1, root2, root3])

        var table = [String: Bool]()
        for r in result {
            table[r.node.key] = r.optional
        }

        XCTAssertFalse(table["a"]!)
        XCTAssertTrue(table["b"]!)
        XCTAssertTrue(table["c"]!)
    }

}
