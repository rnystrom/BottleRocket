//
//  RenderTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/3/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class RenderTests: XCTestCase {

    func test_whenWrapGuard_withNotOptional() {
        let result = wrapGuard(base: "test", optional: false)
        XCTAssertEqual(result, "guard test else { return nil }")
    }

    func test_whenWrapGuard_withOptional() {
        let result = wrapGuard(base: "test", optional: true)
        XCTAssertEqual(result, "test")
    }

    func test_whenRenderParsingScalar_withNotOptional() {
        let result = renderParsingScalar(name: "name", type: "Type", optional: false)
        XCTAssertEqual(result.first, "guard let name = json?[Keys.name] as? Type else { return nil }")
    }

    func test_whenRenderParsingScalar_withOptional() {
        let result = renderParsingScalar(name: "name", type: "Type", optional: true)
        XCTAssertEqual(result.first, "let name = json?[Keys.name] as? Type")
    }

    func test_whenRenderParsingObject_withNotOptional() {
        let result = renderParsingObject(name: "name", type: "Type", optional: false)
        let expectation = [
            "guard let nameJSON = json?[Keys.name] as? [String: Any] else { return nil }",
            "guard let name = Type(json: nameJSON) else { return nil }"
        ]
        XCTAssertEqual(result, expectation)
    }

    func test_whenRenderParsingObject_withOptional() {
        let result = renderParsingObject(name: "name", type: "Type", optional: true)
        let expectation = [
            "let nameJSON = json?[Keys.name] as? [String: Any]",
            "let name = Type(json: nameJSON)"
        ]
        XCTAssertEqual(result, expectation)
    }

    func test_whenRenderParsingArray_withScalar_withNotOptional() {
        let node = Node.scalar(key: "scalar_key", type: "Type", encodeType: .object)
        let result = renderParsingArray(name: "name", node: node, optional: false)
        XCTAssertEqual(result.first, "guard let name = json?[Keys.name] as? [Type] else { return nil }")
    }

    func test_whenRenderParsingArray_withObject_withNotOptional() {
        let node = Node.object(key: "key", type: "Type", properties: [])
        let result = renderParsingArray(name: "names", node: node, optional: false)
        let expectation = [
            "guard let namesJSON = json?[Keys.names] as? [ [String: Any] ] else { return nil }",
            "var names = [Type]()",
            "for dict in namesJSON ?? [] {",
            "  if let object = Type(json: dict) {",
            "    names.append(object)",
            "  }",
            "}",
        ]
        XCTAssertEqual(result, expectation)
    }

    func test_whenRenderInitCall_withMultipleNodes() {
        let nodes: [Node] = [
            Node.scalar(key: "scalar", type: "String", encodeType: .object),
            Node.array(key: "array", node: Node.scalar(key: "nested", type: "NSNumber", encodeType: .object)),
            Node.object(key: "object", type: "MyObject", properties: []),
            ]
        let result = renderInitCall(nodes: nodes)
        let expectation = [
            "self.init(",
            "  scalar: scalar,",
            "  array: array,",
            "  object: object",
            ")",
            ]
        XCTAssertEqual(result, expectation)
    }

    func test_whenRenderDecodeNode_withCast() {
        let result = renderDecode(name: "name", encodeType: .object, type: "Type", optional: true)
        XCTAssertEqual(result, "let name = aDecoder.decodeObject(forKey: Keys.name) as? Type")
    }

    func test_whenRenderDecodeNode_withoutCast_withOptional() {
        let result = renderDecode(name: "name", encodeType: .bool, type: "Bool", optional: true)
        XCTAssertEqual(result, "let name = aDecoder.decodeBool(forKey: Keys.name)")
    }

    func test_whenRenderDecodeNode_withoutCast_withNotOptional() {
        let result = renderDecode(name: "name", encodeType: .bool, type: "Bool", optional: false)
        XCTAssertEqual(result, "let name = aDecoder.decodeBool(forKey: Keys.name)")
    }

    func test_whenRenderEncodeNode() {
        let result = renderEncode(name: "name")
        XCTAssertEqual(result, "aCoder.encode(name, forKey: Keys.name)")
    }

    func test_whenRenderInitDecode() {
        let optionalNodes: [OptionalNode] = [
            (Node.scalar(key: "scalar", type: "NSNumber", encodeType: .object), true),
            (Node.array(key: "array", node: Node.scalar(key: "nested", type: "String", encodeType: .object)), false),
            (Node.object(key: "object", type: "MyObject", properties: []), true),
            ]
        let result = renderInitDecode(optionalNodes: optionalNodes)
        let expectation = [
            "convenience init?(coder aDecoder: NSCoder) {",
            "  let scalar = aDecoder.decodeObject(forKey: Keys.scalar) as? NSNumber",
            "  guard let array = aDecoder.decodeObject(forKey: Keys.array) as? [String] else { return nil }",
            "  let object = aDecoder.decodeObject(forKey: Keys.object) as? MyObject",
            "  self.init(",
            "    scalar: scalar,",
            "    array: array,",
            "    object: object",
            "  )",
            "}"
        ]
        XCTAssertEqual(result, expectation)
    }

    func test_whenRenderEncode() {
        let nodes = [
            Node.scalar(key: "scalar", type: "NSNumber", encodeType: .object),
            Node.array(key: "array", node: Node.scalar(key: "nested", type: "NSNumber", encodeType: .object)),
            Node.object(key: "object", type: "MyObject", properties: []),
            ]
        let result = renderEncode(nodes: nodes)
        let expectation = [
            "func encode(with aCoder: NSCoder) {",
            "  aCoder.encode(scalar, forKey: Keys.scalar)",
            "  aCoder.encode(array, forKey: Keys.array)",
            "  aCoder.encode(object, forKey: Keys.object)",
            "}"
        ]
        XCTAssertEqual(result, expectation)
    }

    func test_whenRenderKeys() {
        let nodes = [
            Node.scalar(key: "scalar", type: "NSNumber", encodeType: .object),
            Node.array(key: "array", node: Node.scalar(key: "nested", type: "NSNumber", encodeType: .object)),
            Node.object(key: "object", type: "MyObject", properties: []),
            ]
        let result = renderKeys(nodes: nodes)
        let expectation = [
            "struct Keys {",
            "  static let scalar = \"scalar\"",
            "  static let array = \"array\"",
            "  static let object = \"object\"",
            "}"
        ]
        XCTAssertEqual(result, expectation)
    }

    func test_whenRenderingInitializer() {
        let optionalNodes: [OptionalNode] = [
            (Node.scalar(key: "scalar", type: "NSNumber", encodeType: .object), true),
            (Node.array(key: "array", node: Node.scalar(key: "nested", type: "String", encodeType: .object)), false),
            ]
        let result = renderInitializer(optionalNodes: optionalNodes)
        let expectation = [
            "init(",
            "  scalar: NSNumber?,",
            "  array: [String]",
            "  ) {",
            "  self.scalar = scalar",
            "  self.array = array",
            "}"
        ]
        XCTAssertEqual(result, expectation)
    }

    func test_whenRenderingProperties() {
        let optionalNodes: [OptionalNode] = [
            (Node.scalar(key: "scalar", type: "NSNumber", encodeType: .object), true),
            (Node.array(key: "array", node: Node.scalar(key: "nested", type: "String", encodeType: .object)), false),
            (Node.object(key: "object", type: "MyObject", properties: []), true),
            ]
        let result = renderProperties(optionalNodes: optionalNodes)
        let expectation = [
            "let scalar: NSNumber?",
            "let array: [String]",
            "let object: MyObject?"
        ]
        XCTAssertEqual(result, expectation)
    }

    func test_whenRenderingClass() {
        let optionalNodes: [OptionalNode] = [
            (Node.scalar(key: "scalar", type: "NSNumber", encodeType: .object), true),
            (Node.array(key: "array", node: Node.scalar(key: "nested", type: "String", encodeType: .object)), false),
            (Node.object(key: "object", type: "MyObject", properties: []), true),
            ]
        let result = renderClass(name: "MyClass", optionalNodes: optionalNodes)
        XCTAssertTrue(result.count > 0)
    }
    
}
