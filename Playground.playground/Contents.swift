//: Playground - noun: a place where people can play

import Foundation

let dict: [String: Any] = [
    "int": 0,
    "bool": false,
    "double": 0.0,
]

func printDict(d: [String: Any]) {
    for (k, v) in d {
        let type: String
        switch v {
        case _ as Double: type = "Double"
        case _ as Int: type = "Int"
        case _ as Bool: type = "Bool"
        default: type = "Unknown"
        }
        print("\(k) is \(type)")
    }
    print("\n")
}

print("original")
printDict(d: dict)

let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

print("unpacked dict")
printDict(d: json)

let stringData = "{\"int\": 0, \"bool\": false, \"double\": 0.0}".data(using: .utf8)
let stringJSON = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

print("unpacked string")
printDict(d: stringJSON)

let arrOpt: [String] = ["one", "two", "three"]
for s in arrOpt ?? [] {
    print(s)
}
