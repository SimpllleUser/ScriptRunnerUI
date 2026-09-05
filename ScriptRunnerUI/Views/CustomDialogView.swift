//
//  CustomDialogView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 05.09.2026.
//

import SwiftUI

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
