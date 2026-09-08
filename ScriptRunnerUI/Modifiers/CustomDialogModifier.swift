import SwiftUI


struct CustomDialogModifier<DialogContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let dialogContent: () -> DialogContent

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    CustomDialogView(
                        isShowing: $isPresented,
                        dialogContent: dialogContent
                    )
                    .zIndex(1)
                }
            }
    }
}
