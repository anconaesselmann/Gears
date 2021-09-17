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
                    Gear(
                        center: center,
                        radius: 100,
                        toothHeigh: toothHeight,
                        toothWidth: toothWidthSlider,
                        toothTipWidthPerchentOfRoot: toothTipWidthPerchentOfRoot,
                        toothCount: toothNumber,
                        rotate: .radians(rotationSlider * 2 * .pi)
                    ).stroke(
                        Color.black,
                        style: style
                    )
                }.frame(width: 300, height: 300)
                .background(Color.white)
            }
        }.statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
