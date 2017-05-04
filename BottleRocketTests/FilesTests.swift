//
//  FilesTests.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/3/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import XCTest

class FilesTests: XCTestCase {

    let userDir = ("~/" as NSString).expandingTildeInPath

    func test_whenGeneratingURL_withRelativePath_withBaseMissingSlash_withDestinationMissingSlash() {
        let result = generatePathToSave(fromBasePath: "/Users/rnystrom/tmp", destinationPath: ".")
        XCTAssertEqual(result, "/Users/rnystrom/tmp/./")
    }

    func test_whenGeneratingURL_withRelativePath_withBaseSlash_withDestinationMissingSlash() {
        let result = generatePathToSave(fromBasePath: "/Users/rnystrom/tmp/", destinationPath: ".")
        XCTAssertEqual(result, "/Users/rnystrom/tmp/./")
    }

    func test_whenGeneratingURL_withRelativePath_withBaseSlash_withDestinationSlash() {
        let result = generatePathToSave(fromBasePath: "/Users/rnystrom/tmp/", destinationPath: "./")
        XCTAssertEqual(result, "/Users/rnystrom/tmp/./")
    }

    func test_whenGeneratingURL_withRelativePath_withBaseTilde_withBaseMissingSlash_withDestinationMissingSlash() {
        let result = generatePathToSave(fromBasePath: "~/tmp", destinationPath: ".")
        XCTAssertEqual(result, userDir + "/tmp/./")
    }

    func test_whenGeneratingURL_withRelativePath_withBaseTilde_withBaseSlash_withDestinationMissingSlash() {
        let result = generatePathToSave(fromBasePath: "~/tmp/", destinationPath: ".")
        XCTAssertEqual(result, userDir + "/tmp/./")
    }

    func test_whenGeneratingURL_withAbsolutePath_withMissingSlash() {
        let result = generatePathToSave(fromBasePath: "~/foo/", destinationPath: "/Users/rnystrom/tmp")
        XCTAssertEqual(result, "/Users/rnystrom/tmp/")
    }

    func test_whenGeneratingURL_withAbsolutePath_withSlash() {
        let result = generatePathToSave(fromBasePath: "~/foo/", destinationPath: "/Users/rnystrom/tmp/")
        XCTAssertEqual(result, "/Users/rnystrom/tmp/")
    }

    func test_whenGeneratingURL_withAbsolutePath_withTilde_withMissingSlash() {
        let result = generatePathToSave(fromBasePath: "~/foo/", destinationPath: "~/tmp")
        XCTAssertEqual(result, userDir + "/tmp/")
    }

    func test_whenGeneratingURL_withAbsolutePath_withTilde_withSlash() {
        let result = generatePathToSave(fromBasePath: "~/foo/", destinationPath: "~/tmp/")
        XCTAssertEqual(result, userDir + "/tmp/")
    }

}
