//
//  ModelNameTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class typeNameTests: XCTestCase {

    func test_whenKeyPlural_thatReturnsSingular() {
        let result = typeName(for: "users")
        XCTAssertEqual(result, "User")
    }

    func test_whenKeySingular_thatReturnsSingular() {
        let result = typeName(for: "user")
        XCTAssertEqual(result, "User")
    }

}
