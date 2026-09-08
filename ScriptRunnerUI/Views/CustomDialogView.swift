//
//  CustomDialogView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 05.09.2026.
//

import SwiftUI

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
