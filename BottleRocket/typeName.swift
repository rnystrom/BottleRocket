//
//  singular.swift
//  BottleRocket
//
//  Created by Ryan Nystrom on 5/1/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

func cleanKey(for key: String) -> String {
    let removedSymbols = key
        .replacingOccurrences(of: "+", with: "plus")
        .replacingOccurrences(of: "-", with: "minus")
        .replacingOccurrences(of: "$", with: "dollar")
        .replacingOccurrences(of: "\"", with: "quote")
        .replacingOccurrences(of: "'", with: "apostrophe")

    let blacklistedWords = [
        "self",
        "struct",
        "class",
        "func",
        "import",
        "let",
        "var",
        "static",
        "convenience",
        "init",
        "guard",
        "private",
        "default",
        "description",
    ]

    for word in blacklistedWords {
        if removedSymbols.lowercased() == word {
            let newKey = removedSymbols + "_"
            print("Changing blacklisted key name \"\(removedSymbols)\" to \"\(newKey)\"")
            return newKey
        }
    }

    return removedSymbols
}

func typeName(for key: String, locale: Locale = Locale.current) -> String {
    var badCharacters = CharacterSet()
    badCharacters.insert("_")
    badCharacters.insert("-")
    let split = key.components(separatedBy: badCharacters)
    let capSplit = split.map { $0.capitalized(with: locale) }
    let join = capSplit.joined(separator: "")

    let cleanedKey = cleanKey(for: join)

    return TTTStringInflector.default().singularize(cleanedKey)
}
