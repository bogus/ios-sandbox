//: Playground - noun: a place where people can play

import UIKit

let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
let rect2 = CGRect(x: 50, y: 50, width: 200, height: 200)

// Rotate
let rect3 = rect2.applying(CGAffineTransform(rotationAngle: 45))
// Translate
let rect4 = rect2.applying(CGAffineTransform(translationX: 20, y: 10))
// Scale
let rect5 = rect4.applying(CGAffineTransform(scaleX: 3, y: 2))

// union
let rect6 = rect2.union(rect3)

// is intersects
_ = rect2.intersects(rect3)
_ = rect.intersects(rect5)

// offset by
_ = rect.offsetBy(dx: 10, dy: 20)

// inset by
_ = rect.insetBy(dx: 10, dy: 20)

// divided
let (leftRect, rightRect) = rect.divided(atDistance: 20, from: .minXEdge)












