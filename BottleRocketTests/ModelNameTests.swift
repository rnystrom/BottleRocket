//
//  ModelNameTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class ModelNameTests: XCTestCase {

    func test_whenKeyPlural_thatReturnsSingular() {
        let result = modelName(for: "users")
        XCTAssertEqual(result, "User")
    }

    func test_whenKeySingular_thatReturnsSingular() {
        let result = modelName(for: "user")
        XCTAssertEqual(result, "User")
    }

}
