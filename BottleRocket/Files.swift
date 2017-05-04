//
//  Files.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/3/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

func jsonFiles(
    path: String
    ) -> (jsonFiles: [String], mapFile: String?) {
    let fileManager = FileManager.default
    let enumerator = fileManager.enumerator(atPath: path)
    var jsonFiles = [String]()
    var mapFile: String?
    while let element = enumerator?.nextObject() as? String {
        if element.hasSuffix("json") {
            if element == ".classMap.json" {
                mapFile = path + "/" + element
            } else {
                jsonFiles.append(path + "/" + element)
            }
        }
    }
    return (jsonFiles, mapFile)
}

func loadJSON(
    path: String
    ) -> [String: Any]? {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: path) == false {
        return nil
    }
    let url = URL.init(fileURLWithPath: path)
    do {
        let jsonData = try Data.init(contentsOf: url, options: Data.ReadingOptions.uncached)
        return try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
    } catch {
        return nil
    }
}

func loadJSONFiles(files: [String]) -> [ String: [String: Any] ] {
    var fileModels = [ String: [String: Any] ]()
    for file in files {
        let url = URL(fileURLWithPath: file)
        let fileName = url.lastPathComponent.replacingOccurrences(of: ".json", with: "")
        if let json = loadJSON(path: file) {
            fileModels[fileName] = json
        }
    }
    return fileModels
}
