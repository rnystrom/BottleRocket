//
//  NodeTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/3/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class NodeTests: XCTestCase {

    func test_whenCreatingArray_withScalarType_thatTypeMatches() {
        let scalar = Node.scalar(key: "key", type: "String", encodeType: .object)
        let array = Node.array(key: "array_key", node: scalar)
        XCTAssertEqual(array.type, "[String]")
    }

    func test_whenCreatingArray_withObjectType_thatTypeMatches() {
        let scalar = Node.object(key: "key", type: "MyObject", properties: [])
        let array = Node.array(key: "array_key", node: scalar)
        XCTAssertEqual(array.type, "[MyObject]")
    }

}
