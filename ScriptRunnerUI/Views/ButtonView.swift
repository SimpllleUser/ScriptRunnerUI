//
//  ButtonView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 03.09.2026.
//

import SwiftUI

struct ButtonView: View {
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
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.toolbarSidebarItem)
                .stroke(Theme.Surface.paper4, lineWidth: 2)
            
        )
    }
}

#Preview {
    ButtonView(label: "Run", icon: "play", onClick: {
        print("onClick")
    })
    .padding(50)
}
