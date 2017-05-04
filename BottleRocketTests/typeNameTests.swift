//
//  ModelNameTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class TypeNameTests: XCTestCase {

    func test_whenKeyPlural_thatReturnsSingular() {
        let result = typeName(for: "users")
        XCTAssertEqual(result, "User")
    }

    func test_whenKeySingular_thatReturnsSingular() {
        let result = typeName(for: "user")
        XCTAssertEqual(result, "User")
    }

    func test_whenKeyUnderscore() {
        let result = typeName(for: "_link")
        XCTAssertEqual(result, "Link")
    }

    func test_whenKeyHyphen() {
        let result = typeName(for: "url-link")
        XCTAssertEqual(result, "UrlLink")
    }

    func test_whenCleaningKey_withBlacklistedWord() {
        let result = cleanKey(for: "self")
        XCTAssertEqual(result, "self_")
    }

    func test_whenCleaningKey_withNonAlphaBeginning() {
        let result = cleanKey(for: "+1")
        XCTAssertEqual(result, "plus1")
    }

    func test_whenCreatingClassName_withBlacklistedWord() {
        let result = typeName(for: "self")
        XCTAssertEqual(result, "Self_")
    }

}
