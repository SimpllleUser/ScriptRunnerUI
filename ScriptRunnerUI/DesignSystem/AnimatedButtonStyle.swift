//
//  AnimatedButtonStyle.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 05.09.2026.
//

import SwiftUI

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: CornerRadius.toolbarSidebarItem)
                    .fill(configuration.isPressed ? Theme.Surface.paper.opacity(0.5) : Theme.Surface.paper)
            )
            .overlay(
                RoundedRectangle(cornerRadius: CornerRadius.toolbarSidebarItem)
                    .stroke(Theme.Surface.paper3, lineWidth: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
