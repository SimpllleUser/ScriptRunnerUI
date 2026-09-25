
import SwiftUI

struct SpinnerApp: View {
    let size: CGFloat
    @State private var isRotating = false
    
    private func getLineWidth() -> CGFloat {
        return self.size * 0.15
    }
    
    var body: some View {
        Circle()
            .stroke(
                Theme.Brand.brand50,
                lineWidth: getLineWidth()
            )
            .frame(width: size)
            .overlay {
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(
                        Theme.Brand.brand,
                        style: StrokeStyle(
                            lineWidth: getLineWidth(),
                            lineCap: .round
                        )
                    )
                    .rotationEffect(
                        .degrees(isRotating ? 360 : 0)
                    )
            }
            .animation(
                .linear(duration: 1)
                    .repeatForever(autoreverses: false),
                value: isRotating
            )
            .onAppear {
                isRotating = true
            }
    }
}

#Preview {
    SpinnerApp(size: 100).padding(20)
}
