//: Playground - noun: a place where people can play

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
    PlaygroundPage.current.finishExecution()
}

class GCDTest {
    
    lazy var dwi = DispatchWorkItem { [weak self] in
            for i in 1...5 {
                if self?.dwi.isCancelled ?? true {
                    print("Cancelled")
                    return
                }
                print(i)
                sleep(1)
            }
        }
    

    func run() {
        let queue = DispatchQueue(label: "test", qos: .background)
        queue.async(execute: dwi)
        sleep(3)
        dwi.cancel()
    }
    
    func runInGroup() {
        let dispatchGroup = DispatchGroup()
        let queue = DispatchQueue(label: "test", qos: .background)
        queue.async(group: dispatchGroup, execute: dwi)
        sleep(6)
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            print("All Done")
        })
    }
    
}

// GCDTest().run()
GCDTest().runInGroup()

