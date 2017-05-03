//
//  ParseNodeTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class ParseNodeTests: XCTestCase {

    func test_whenParsingBool_withTrueValue_thatResultCorrect() {
        let root = parseNode(key: "root", value: true)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "Bool")
        default: XCTFail()
        }
    }

    func test_whenParsingBool_withFalseValue_thatResultCorrect() {
        let root = parseNode(key: "root", value: false)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "Bool")
        default: XCTFail()
        }
    }

    func test_whenParsingInt_thatResultCorrect() {
        let root = parseNode(key: "root", value: 1)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "Int")
        default: XCTFail()
        }
    }

    func test_whenParsingDouble_withFractionValue_thatResultCorrect() {
        let root = parseNode(key: "root", value: 1.1)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "Double")
        default: XCTFail()
        }
    }

    func test_whenParsingDouble_withFloorValue_thatResultCorrect() {
        let root = parseNode(key: "root", value: 1.0)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "Double")
        default: XCTFail()
        }
    }

    func test_whenParsingString_thatResultCorrect() {
        let root = parseNode(key: "root", value: "foo")
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "String")
        default: XCTFail()
        }
    }

    func test_whenParsingNestedJSON_thatResultCorrect() {
        let root = parseNode(key: "root", value: ["foo": "bar"])
        switch root {
        case .object(let key, _, let properties):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(properties.count, 1)
            switch properties.first! {
            case .scalar(let key, let type, _):
                XCTAssertEqual(key, "foo")
                XCTAssertEqual(type, "String")
            default: XCTFail()
            }
        default: XCTFail()
        }
    }

    func test_whenParsingArray_withInts_thatResultCorrect() {
        let root = parseNode(key: "roots", value: [1])
        switch root {
        case .array(let key, let obj):
            XCTAssertEqual(key, "roots")
            switch obj {
            case .scalar(_, let type, _): XCTAssertEqual(type, "Int")
            default: XCTFail()
            }
        default: XCTFail()
        }
    }

    func test_whenParsingArray_withDoubles_thatResultCorrect() {
        let root = parseNode(key: "roots", value: [1.0])
        switch root {
        case .array(let key, let obj):
            XCTAssertEqual(key, "roots")
            switch obj {
            case .scalar(_, let type, _): XCTAssertEqual(type, "Double")
            default: XCTFail()
            }
        default: XCTFail()
        }
    }

    func test_whenParsingArray_withStrings_thatResultCorrect() {
        let root = parseNode(key: "roots", value: ["foo"])
        switch root {
        case .array(let key, let obj):
            XCTAssertEqual(key, "roots")
            switch obj {
            case .scalar(_, let type, _): XCTAssertEqual(type, "String")
            default: XCTFail()
            }
        default: XCTFail()
        }
    }

    func test_whenParsingArray_withBools_thatResultCorrect() {
        let root = parseNode(key: "roots", value: [true])
        switch root {
        case .array(let key, let obj):
            XCTAssertEqual(key, "roots")
            switch obj {
            case .scalar(_, let type, _): XCTAssertEqual(type, "Bool")
            default: XCTFail()
            }
        default: XCTFail()
        }
    }

    func test_whenParsingArray_withNestedJSON_thatResultCorrect() {
        let root = parseNode(key: "roots", value: [ ["foo": "bar"] ])
        switch root {
        case .array(let key, let obj):
            XCTAssertEqual(key, "roots")
            switch obj {
            case .object(_, let type, properties: let properties):
                XCTAssertEqual(type, "Root")
                XCTAssertEqual(properties.count, 1)
                switch properties.first! {
                case .scalar(let key, let type, _):
                    XCTAssertEqual(key, "foo")
                    XCTAssertEqual(type, "String")
                default: XCTFail()
                }
            default: XCTFail()
            }
        default: XCTFail()
        }
    }

}
