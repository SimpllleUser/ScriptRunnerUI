//
//  CustomDialogView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 05.09.2026.
//

import SwiftUI

import SwiftUI

struct CustomDialogView<DialogContent: View>: View {
    @Binding var isShowing: Bool
    @ViewBuilder let dialogContent: () -> DialogContent

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { isShowing = false }
                }

            VStack(spacing: 20) {
                dialogContent()
            }
            .padding(30)
            .background(Color(NSColor.windowBackgroundColor))
            .cornerRadius(16)
            .transition(.scale.combined(with: .opacity))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

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

extension View {
    func customDialog<DialogContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> DialogContent
    ) -> some View {
        self.modifier(
            CustomDialogModifier(
                isPresented: isPresented,
                dialogContent: content
            )
        )
    }
}
