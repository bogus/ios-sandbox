// Reference:
// https://www.uraimo.com/2017/05/07/all-about-concurrency-in-swift-1-the-present/

import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

class TestThread : Thread {
    override open func main() {
        print("(T1) Thread started, sleep for 2 seconds...")
        Thread.sleep(forTimeInterval:2)
        if isCancelled {
            print("(T1) Thread is cancelled")
            return
        }
        print("(T1) Done sleeping, exiting thread")
    }
}

let t = TestThread()
t.start()
DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
    t.cancel()
}

let t2 = Thread {
    print("(T2) Thread with block")
}
t2.start()

print("=========")

let lock = NSLock()
class LockedThread : Thread {
    
    override open func main() {
        lock.lock()
        print("(\(name ?? "(empty)")) acquired the lock")
        lock.unlock()
        if lock.try() {
            print("(\(name ?? "(empty)")) acquired the lock again")
            lock.unlock()
        } else {
            print("(\(name ?? "(empty)")) couldn't acquire the lock")
        }
        print("(\(name ?? "(empty)")) EOT")
    }
}

let lt1 = LockedThread()
lt1.name = "LT1"
let lt2 = LockedThread()
lt2.name = "LT2"

lt1.start()
lt2.start()

print("=========")

let NO_DATA = 1
let GOT_DATA = 2
let condLock = NSConditionLock(condition: NO_DATA)
var sharedVal = 0
class ProducerThread : Thread {
    override open func main() {
        for i in 1...5 {
            condLock.lock(whenCondition: NO_DATA)
            sharedVal = i
            condLock.unlock(withCondition: GOT_DATA)
        }
    }
}

class ConsumerThread : Thread {
    override open func main() {
        for _ in 1...5 {
            condLock.lock(whenCondition: GOT_DATA)
            print("(CONSUMER) \(sharedVal)")
            condLock.unlock(withCondition: NO_DATA)
        }
    }
}

let pt = ProducerThread()
let ct = ConsumerThread()
ct.start()
pt.start()

print("=========")


var opQueue = OperationQueue()
opQueue.name = "Test Operation Queue"
opQueue.maxConcurrentOperationCount = 3

let op1 = BlockOperation(block: {
    print("(OP1) Operation 1")
})
op1.queuePriority = .veryHigh
op1.completionBlock = {
    if op1.isCancelled {
        print("(OP1) This operation is cancelled")
    }
    print("(OP1) Completed")
}

let op2 = BlockOperation {
    print("(OP2) Op2 always after Op1")
    OperationQueue.main.addOperation{
        print("(OP2) Running on main queue")
    }
}

opQueue.addOperation(op1)
opQueue.addOperation(op2)

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
    PlaygroundPage.current.finishExecution()
}
