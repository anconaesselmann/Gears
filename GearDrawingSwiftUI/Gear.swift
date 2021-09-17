//
//  Gear.swift
//  GearDrawingSwiftUI
//
//  Created by Axel Ancona Esselmann on 9/17/21.
//

import SwiftUI

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

struct Gear_Previews: PreviewProvider {
    static let style = StrokeStyle(
        lineWidth: 2,
        lineCap: .round,
        lineJoin: .round,
        miterLimit: 0,
        dash: [],
        dashPhase: 0
    )

    static var previews: some View {
        Gear(center: CGPoint(x: 105, y: 105), radius: 100, toothHeigh: 20, toothWidth: 0.25, toothTipWidthPerchentOfRoot: 0.25, toothCount: 7, rotate: .zero)
            .stroke(
                Color.black,
                style: style
            )
            .frame(width: 210, height: 210)
            .previewLayout(.sizeThatFits)
    }
}
