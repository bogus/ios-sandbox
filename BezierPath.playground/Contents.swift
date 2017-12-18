//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class BezierArcView : UIView {
    
    override func draw(_ rect: CGRect) {
        let bezierPathArc = UIBezierPath()
        bezierPathArc.addArc(withCenter: center, radius: 20, startAngle: 0, endAngle: 180, clockwise: true)
        bezierPathArc.close()
        UIColor.red.setStroke()
        bezierPathArc.stroke()
    }
    
}

class BezierLineView : UIView {
    
    override func draw(_ rect: CGRect) {
        let bezierPathSquare = UIBezierPath()
        bezierPathSquare.move(to: CGPoint(x: 10, y: 10))
        bezierPathSquare.addLine(to: CGPoint(x: 10, y: 100))
        bezierPathSquare.addLine(to: CGPoint(x: 100, y: 100))
        bezierPathSquare.addLine(to: CGPoint(x: 100, y: 10))
        bezierPathSquare.close()
        UIColor.red.setStroke()
        bezierPathSquare.stroke()
        UIColor.black.setFill()
        bezierPathSquare.fill()
    }
}

class BezierMask : UIView {
    
    var view:UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.white
        let rect = CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 10)
        view = UIView(frame: rect)
        view?.backgroundColor = UIColor.red
        guard let view = view else { return }
        addSubview(view)
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: .allCorners,
                                               cornerRadii: CGSize(width: 10, height: 10))
        let shapeMask = CAShapeLayer.init()
        shapeMask.path = maskPath.cgPath
        view.layer.mask = shapeMask
    }
    
}

PlaygroundPage.current.needsIndefiniteExecution = true
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = BezierMask(frame: CGRect(origin: CGPoint(x: 0, y: 0),
                                                              size: CGSize(width: 200, height: 200)))
