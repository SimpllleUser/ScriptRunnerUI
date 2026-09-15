//
//  CUstomDialogModifire.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 05.09.2026.
//

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
