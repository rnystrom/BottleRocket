//
//  ReduceTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/3/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class ReduceTests: XCTestCase {

    func test_whenQueryingAllObjects_withThreeDeepTree() {
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
        let result = allObjects(nodes: [root, root2])
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

    func test_whenFindingOptionalNodes_withNoOptionals() {
        let children = [
            Node.scalar(key: "a", type: "String", encodeType: .object),
            Node.scalar(key: "b", type: "Int", encodeType: .integer),
            Node.object(key: "c", type: "Empty", properties: [])
        ]
        let root = Node.object(key: "root2", type: "Root", properties: children)

        let result = findOptionalNodes(nodes: [root])

        var table = [String: Bool]()
        for r in result {
            table[r.node.key] = r.optional
        }

        XCTAssertFalse(table["a"]!)
        XCTAssertFalse(table["b"]!)
        XCTAssertFalse(table["c"]!)
    }

    func mapOptionalNodes(optionalNodes: [OptionalNode]) -> [String: Bool] {
        var table = [String: Bool]()
        for r in optionalNodes {
            table[r.node.key] = r.optional
        }
        return table
    }

    func test_whenFindingOptionalNodes_withOptionals() {
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

        var table = mapOptionalNodes(optionalNodes: result)

        XCTAssertFalse(table["a"]!)
        XCTAssertTrue(table["b"]!)
        XCTAssertTrue(table["c"]!)
    }

    func test_whenBuildClassMap_withOneType_withNoRenameMap() {
        let userProperties = [
            Node.scalar(key: "name", type: "String", encodeType: .object),
            Node.scalar(key: "pk", type: "Int", encodeType: .integer)
        ]
        let userPartialProperties = [
            Node.scalar(key: "pk", type: "Int", encodeType: .integer)
        ]
        let user = Node.object(key: "user", type: "User", properties: userProperties)
        let userPartial = Node.object(key: "user", type: "User", properties: userPartialProperties)

        let result = buildClassMap(nodes: [user, userPartial])

        XCTAssertEqual(result.count, 1)

        let table = mapOptionalNodes(optionalNodes: result["User"]!)
        XCTAssertTrue(table["name"]!)
        XCTAssertFalse(table["pk"]!)
    }

    func test_whenBuildClassMap_withNestedMatchingType_withNoRenameMap() {
        let userProperties = [
            Node.scalar(key: "name", type: "String", encodeType: .object),
            Node.scalar(key: "pk", type: "Int", encodeType: .integer)
        ]
        let userPartialProperties = [
            Node.scalar(key: "pk", type: "Int", encodeType: .integer)
        ]
        let user = Node.object(key: "user", type: "User", properties: userProperties)

        let commentProperties = [
            Node.object(key: "user", type: "User", properties: userPartialProperties)
        ]
        let comment = Node.object(key: "comment", type: "Comment", properties: commentProperties)

        let result = buildClassMap(nodes: [user, comment])

        XCTAssertEqual(result.count, 2)

        let userTable = mapOptionalNodes(optionalNodes: result["User"]!)
        XCTAssertTrue(userTable["name"]!)
        XCTAssertFalse(userTable["pk"]!)

        let commentTable = mapOptionalNodes(optionalNodes: result["Comment"]!)
        XCTAssertFalse(commentTable["user"]!)
    }

    func test_whenBuildClassMap_withNestedMatchingType_withRenameMap() {
        let userProperties = [
            Node.scalar(key: "name", type: "String", encodeType: .object),
            Node.scalar(key: "pk", type: "Int", encodeType: .integer)
        ]
        let userPartialProperties = [
            Node.scalar(key: "pk", type: "Int", encodeType: .integer)
        ]
        let user = Node.object(key: "user", type: "User", properties: userProperties)

        let commentProperties = [
            Node.object(key: "author", type: "Author", properties: userPartialProperties)
        ]
        let comment = Node.object(key: "comment", type: "Comment", properties: commentProperties)

        let result = buildClassMap(nodes: [user, comment], classMap: ["Author": "User"])

        XCTAssertEqual(result.count, 2)

        let userTable = mapOptionalNodes(optionalNodes: result["User"]!)
        XCTAssertTrue(userTable["name"]!)
        XCTAssertFalse(userTable["pk"]!)

        let commentTable = mapOptionalNodes(optionalNodes: result["Comment"]!)
        XCTAssertFalse(commentTable["author"]!)
    }

}
