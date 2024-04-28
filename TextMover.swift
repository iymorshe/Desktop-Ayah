import SwiftUI

struct AdjustableTextPosition: View {
    @State private var sliderValue: Double = 0.5 // Default to center

    var body: some View {
        GeometryReader { geometry in

                VStack {
                    Text("Top Of Screen")
                    Text("Bottom Of Screen")
                    /*
                    Spacer(minLength: 0) // This allows the text to move freely along the horizontal axis

                    Text("Move Me!")
                        .frame(width: 100, alignment: .center)
                        .cornerRadius(10)
                        .offset(x: 0, y: CGFloat(sliderValue) * (geometry.size.width))
                    // Adjusting the offset based on the GeometryReader's width

                    Spacer(minLength: 0) // This allows the text to move freely along the horizontal axis
                     */
                }
                .frame(width: geometry.size.width)
            }
    }
}
#Preview {
    AdjustableTextPosition()
}
