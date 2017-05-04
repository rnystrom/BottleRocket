//
//  ConfigTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/2/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class ConfigTests: XCTestCase {

    func test_whenParsingConfig_withEmptyJSON_thatResultDefaults() {
        let config = parseConfig(json: [:])
        XCTAssertEqual(config.renameMap.count, 0)
        XCTAssertEqual(config.destination, "")
    }

    func test_whenParsingConfig_withRenameMap_thatConfigHasMap() {
        let config = parseConfig(json: ["rename_map": ["foo": "bar"]])
        XCTAssertEqual(config.renameMap["foo"], "bar")
    }

    func test_whenParsingConfig_withDestination_thatConfigHasDestination() {
        let config = parseConfig(json: ["destination": "/foo/bar"])
        XCTAssertEqual(config.destination, "/foo/bar")
    }

}
