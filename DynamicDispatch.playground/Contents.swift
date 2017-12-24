//: Playground - noun: a place where people can play

import Foundation

protocol Playgroundable {
    
    associatedtype aType
    
    func printIt(item:aType)
    func sumIt(item1:aType, item2:aType) -> aType
}

class TestClass : Playgroundable {
    
    typealias aType = Double
    
    func printIt(item: Double) {
        print(item)
    }
    
    func sumIt(item1: Double, item2: Double) -> Double {
        return item1 + item2
    }
    
}

let testClassObj = TestClass()
testClassObj.printIt(item: 1)
testClassObj.printIt(item: testClassObj.sumIt(item1: 5.0, item2: 6.5))

// Generics with associated types
class GenericClass<T: Playgroundable> {
    func print(item:T, val:T.aType) {
        item.printIt(item: val)
    }
}

let genericClassObj = GenericClass<TestClass>()
genericClassObj.print(item: TestClass(), val: Double.pi)






