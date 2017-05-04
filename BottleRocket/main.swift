//
//  main.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

class Generate: Command {
    let name = "gen"
    let path = Parameter()

    func execute() throws {
        let currentPath = FileManager.default.currentDirectoryPath
        let result = jsonFiles(path: path.value)

        print("Found \(result.jsonFiles.count) json files...")

        var configJSON: [String: Any]? = nil
        if let file = result.config {
            configJSON = loadJSON(path: file)
        }
        let config = parseConfig(json: configJSON)

        let fileModels = loadJSONFiles(files: result.jsonFiles)
        let rootNodes = fileModels.map { parseNodeObject(key: cleanKey(for: $0), dict: $1, renameMap: config.renameMap) }
        let classMap = buildClassMap(nodes: rootNodes)

        do {
            for (name, optionalNodes) in classMap {
                let render = renderClass(name: name, optionalNodes: optionalNodes).joined(separator: "\n")
                let destinationPath = config.destination == "" ? path.value : config.destination
                let toPath = generatePathToSave(fromBasePath: currentPath, destinationPath: destinationPath)
                try writeToFile(name: name, content: render, path: toPath)
                print("Saved \(name).swift")
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

CLI.setup(name: "bottlerocket")
CLI.register(command: Generate())
let result = CLI.go()
exit(result)
