//  Created by Axel Ancona Esselmann on 9/10/21.
//

import SwiftUI

struct ContentView: View {

    @State var rotationSlider: Double = 0
    @State var toothWidthSlider: Double = 0.25
    @State var toothTipWidthPerchentOfRoot: Double = 0.25
    @State var toothHeightSlider: Double = 0.4
    @State var toothNumberSlider: Double = 0.5

    var toothNumber: Int {
        Int(toothNumberSlider * 10.0) + 3
    }

    var toothHeight: CGFloat {
        CGFloat(toothHeightSlider * 50)
    }

    var body: some View {
        let style = StrokeStyle(
            lineWidth: 2,
            lineCap: .round,
            lineJoin: .round,
            miterLimit: 0,
            dash: [],
            dashPhase: 0
        )
        VStack {
            Slider(value: $rotationSlider).padding([.leading, .trailing], 16)
            Slider(value: $toothWidthSlider).padding([.leading, .trailing], 16)
            Slider(value: $toothTipWidthPerchentOfRoot).padding([.leading, .trailing], 16)
            Slider(value: $toothHeightSlider).padding([.leading, .trailing], 16)
            Slider(value: $toothNumberSlider).padding([.leading, .trailing], 16)
            Text("Number of teeth: \(toothNumber)")
            ZStack(alignment: .center) {


                GeometryReader { geometry in
                    let center = geometry.frame(in: .local).center
                    Gear(center: center, radius: 100, toothHeigh: toothHeight, toothWidth: toothWidthSlider, toothTipWidthPerchentOfRoot: toothTipWidthPerchentOfRoot, toothCount: toothNumber, rotate: .radians(rotationSlider * 2 * .pi)).stroke(
                        Color.black,
                        style: style
                    )
                }.frame(width: 300, height: 300)
                .background(Color.white)
            }
        }
    }

}

struct Gear: Shape {
    var center: CGPoint
    var radius: CGFloat
    var toothHeigh: CGFloat
    var toothWidth: Double
    var toothTipWidthPerchentOfRoot: Double
    var toothCount: Int
    var rotate: Angle

    func path(in rect: CGRect) -> Path {
        Path { p in
            let segmentAngle: Angle = .radians(2 * .pi / Double(toothCount))
            let innerRadius = radius - toothHeigh
            let toothRootWidthAngle = segmentAngle * toothWidth
            let halfToothRootWidthAngle = toothRootWidthAngle / 2
            let tootTipWidthAngle = segmentAngle * toothTipWidthPerchentOfRoot
            let offset: Angle = -tootTipWidthAngle / 2 + rotate

            p.move(to: center + CGPoint(x: radius, y: 0).rotated(by: offset))
            for i in 0..<toothCount {
                let segmentStart = segmentAngle * Double(i)

                let bigEnd = segmentStart + tootTipWidthAngle + offset
                p.addArc(center: center, radius: radius, startAngle: segmentStart + offset, endAngle: bigEnd, clockwise: false)

                var smallStart = segmentStart + tootTipWidthAngle + halfToothRootWidthAngle + offset
                var smallEnd = segmentStart + segmentAngle - halfToothRootWidthAngle + offset
                if smallEnd < smallStart {
                    smallStart = (smallStart + smallEnd) / 2
                    smallEnd = smallStart
                }
                p.addArc(center: center, radius: innerRadius, startAngle: smallStart, endAngle: smallEnd, clockwise: false)
            }
            p.addLine(to: center + CGPoint(x: radius, y: 0).rotated(by: offset))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension CGPoint {
    func angle(from p1: CGPoint, to p2: CGPoint, returnSmallest: Bool = true) -> Angle {
        let v1 = CGVector(dx: p1.x - x, dy: p1.y - y)
        let v2 = CGVector(dx: p2.x - x, dy: p2.y - y)
        var angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        let inverse = CGFloat.pi * 2 - abs(angle)
        if returnSmallest, inverse < abs(angle) {
            let sign: CGFloat = angle >= 0 ? 1 : -1
            angle = -sign * inverse
        }
        return .radians(Double(angle))
    }

    func rotated(by theta: Angle) -> CGPoint {
        let cosTheta = CGFloat(cos(theta.radians))
        let sinTheta = CGFloat(sin(theta.radians))
        let x: CGFloat = self.x * cosTheta - self.y * sinTheta
        let y: CGFloat = self.x * sinTheta + self.y * cosTheta
        return CGPoint(x: x, y: y)
    }

    var unit: CGPoint {
        self / lenght
    }

    var lenght: CGFloat {
        return sqrt(x * x + y * y)
    }

    var orth: CGPoint {
        CGPoint(x: -y, y: x)
    }

    var orthUnit: CGPoint {
        orth.unit
    }
}

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}

func angle(of position: Int, in count: Int) -> Angle {
    .radians(2 * Double.pi / Double(count) * Double(position))
}

prefix func - (lhs: CGPoint) -> CGPoint {
    CGPoint(x: -lhs.x, y: -lhs.y)
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: width / 2, y: height / 2)
    }
}
