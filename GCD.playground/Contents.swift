//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Create a new serial queue
let serialQueue = DispatchQueue(label: "MySerialQueue")

for i in 0...1000 {
    serialQueue.async {
        print("Serial \(i)")
    }
}

// Create a new concurrent queue
let concurrentQueue = DispatchQueue(label: "MyConcurrentQueue", qos: DispatchQoS.userInitiated, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)

for i in 0...1000 {
    concurrentQueue.async {
        print("Concurrent \(i)")
    }
}

// Create a read/write lock with GCD concurrent barrier
concurrentQueue.async(flags:.barrier) {
    print("Concurrently at the end")
}


// Read - write locking with .barrier
var arr = [String]()
for i in 0...100 {
    
    concurrentQueue.async {
        arr.forEach { print("\(i) --- \($0)") }
    }
    
    concurrentQueue.async(flags:.barrier) {
        arr.append("\(i)")
        print("======= ADDING NEW \(i)")
    }
}

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
    PlaygroundPage.current.finishExecution()
})
