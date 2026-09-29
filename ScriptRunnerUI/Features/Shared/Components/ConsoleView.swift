//
//  ConsoleView.swift
//  ScriptRunnerUI
//
//  Created by Krazis on 24.09.2026.
//

import SwiftUI

struct ConsoleView: View {
    @State private var consoleHeight: CGFloat = 260
    @GestureState private var dragOffset: CGFloat = 0
    
    private var currentHeight: CGFloat {
        min(
            max(consoleHeight - dragOffset, 120),
            600
        )
    }
    
    let value: String
    var body: some View {
        Rectangle()
            .fill(Theme.Surface.paper3)
            .frame(height: 8)
            .overlay{
                RoundedRectangle(cornerRadius: 5).fill(Theme.Status.idle).frame(width: 50, height: 4 ).onHover { isHovering in
                    if isHovering {
                        NSCursor.resizeUpDown.push()
                    } else {
                        NSCursor.pop()
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        consoleHeight = min(
                            max(consoleHeight - value.translation.height, 120),
                            600
                        )
                    }
            )
        VStack(spacing: 16) {
            ScrollViewReader { proxy in
                Text(value)
                    .font(Typography.mono)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .cornerRadius(8)
            }
        }
        .frame(height: currentHeight)
        .transaction { transaction in
            transaction.animation = nil
        }
        
    }
}

#Preview {
    ConsoleView(value: CONSOLE_RESULT)
}
