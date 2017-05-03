//: Playground - noun: a place where people can play

import Foundation

let i = 1.0

switch i {
case _ as Int: print("int")
default: print("default")
}

if let v = i as? Int {
    print("\(v)")
}