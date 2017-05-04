//
//  ParseNodeTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class ParseNodeTests: XCTestCase {

    func test_whenParsingBool_withTrueValue() {
        let root = parseNode(key: "root", value: true)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "Bool")
        default: XCTFail()
        }
    }

    func test_whenParsingBool_withFalseValue() {
        let root = parseNode(key: "root", value: false)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "Bool")
        default: XCTFail()
        }
    }

    func test_whenParsingInt() {
        let root = parseNode(key: "root", value: 1)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "NSNumber")
        default: XCTFail()
        }
    }

    func test_whenParsingDouble_withFractionValue() {
        let root = parseNode(key: "root", value: 1.1)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "NSNumber")
        default: XCTFail()
        }
    }

    func test_whenParsingDouble_withFloorValue() {
        let root = parseNode(key: "root", value: 1.0)
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "NSNumber")
        default: XCTFail()
        }
    }

    func test_whenParsingString() {
        let root = parseNode(key: "root", value: "foo")
        switch root {
        case .scalar(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "String")
        default: XCTFail()
        }
    }

    func test_whenParsingNestedJSON() {
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

    func test_whenParsingArray_withInts() {
        let root = parseNode(key: "roots", value: [1])
        switch root {
        case .array(let key, let obj):
            XCTAssertEqual(key, "roots")
            switch obj {
            case .scalar(_, let type, _): XCTAssertEqual(type, "NSNumber")
            default: XCTFail()
            }
        default: XCTFail()
        }
    }

    func test_whenParsingArray_withDoubles() {
        let root = parseNode(key: "roots", value: [1.0])
        switch root {
        case .array(let key, let obj):
            XCTAssertEqual(key, "roots")
            switch obj {
            case .scalar(_, let type, _): XCTAssertEqual(type, "NSNumber")
            default: XCTFail()
            }
        default: XCTFail()
        }
    }

    func test_whenParsingArray_withStrings() {
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

    func test_whenParsingArray_withBools() {
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

    func test_whenParsingArray_withNestedJSON() {
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

    func test_whenParsingObject_withRename() {
        let root = parseNodeObject(key: "root", dict: ["foo": "bar"], renameMap: ["root": "baz"])
        switch root {
        case .object(let key, let type, _):
            XCTAssertEqual(key, "root")
            XCTAssertEqual(type, "Baz")
        default: XCTFail()
        }
    }

    func test_whenParsingInteger_withZeroValue() {
        let root = parseNode(key: "int", value: 0)
        switch root {
        case .scalar(_, let type, _): XCTAssertEqual(type, "NSNumber")
        default: XCTFail()
        }
    }

}
