//
//  ButtonView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 03.09.2026.
//

import SwiftUI

struct AppButton: View {
    var label: String = ""
    var icon: String = ""
    
    
    var onClick: (() -> Void)? = nil
    var body: some View {
        Button(action: {onClick?()}) {
            HStack {
                if (!icon.isEmpty) {
                    Image(systemName: icon)
                        .foregroundStyle(Theme.Text.ink)
                }
                if (!label.isEmpty) {
                    Text(label)
                        .foregroundStyle(Theme.Text.ink)
                }
            }
            .padding(10)
            .contentShape(Rectangle())
        }
        .buttonStyle(AnimatedButtonStyle())
    }
}

#Preview {
    AppButton(label: "Run", icon: "play", onClick: {
        print("onClick")
    })
    .padding(50)
}
