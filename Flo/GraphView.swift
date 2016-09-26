import UIKit

@IBDesignable class GraphView : UIView {
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    var graphPoints: [Int] = [4, 2, 6, 4, 5, 8, 3]
    
    override func drawRect(rect: CGRect) {
        
        let height = rect.height
        let width = rect.width
        
        var path = UIBezierPath(roundedRect: rect, byRoundingCorners: .AllCorners, cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])
        
        let margin: CGFloat = 20.0
        
        var columnXPoint = { (column: Int) -> CGFloat in
            let spaceWidth = width - margin * 2 - 4
            let spacer = spaceWidth / CGFloat(self.graphPoints.count)
            var x: CGFloat = CGFloat(column) * spacer
            x += (margin + 2)
            
            return x
        }
        
        let topBorder: CGFloat = 60.0
        let bottomBorder: CGFloat = 50.0
        let graphHeight = height - topBorder - bottomBorder
        let maxValue: Int! = graphPoints.maxElement()
        
        var columnYPoint = { (graphPoint: Int) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        var graphPath = UIBezierPath()
        graphPath.moveToPoint(CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        
        
        CGContextSaveGState(context)
        
        var clippingPath = graphPath.copy() as! UIBezierPath
        
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
        clippingPath.addLineToPoint(CGPoint(x: columnXPoint(0), y: height))
        
        clippingPath.addClip()
//
//        UIColor.whiteColor().setFill()
//        let rectPath = UIBezierPath(rect: self.bounds)
//        rectPath.fill()
        
        startPoint = CGPoint(x:margin, y: columnYPoint(maxValue))
        endPoint = CGPoint(x:margin, y: self.bounds.height)
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])


        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        
        CGContextRestoreGState(context)
        
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
            
        }
        
        let linePath = UIBezierPath()
        
        linePath.moveToPoint(CGPoint(x: margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: topBorder))
        
            //center line
        linePath.moveToPoint(CGPoint(x:margin,
                y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
                y:graphHeight/2 + topBorder))
            
            //bottom line
        linePath.moveToPoint(CGPoint(x:margin,
                y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
                y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        
        color.setStroke()
        linePath.lineWidth = 1.0
        linePath.stroke()
        
    }
}