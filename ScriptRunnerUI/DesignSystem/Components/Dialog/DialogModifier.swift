import SwiftUI


struct DialogModifier<DialogContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let dialogContent: () -> DialogContent

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    DialogSheet(
                        isShowing: $isPresented,
                        dialogContent: dialogContent
                    )
                    .zIndex(1)
                }
            }
    }
}
