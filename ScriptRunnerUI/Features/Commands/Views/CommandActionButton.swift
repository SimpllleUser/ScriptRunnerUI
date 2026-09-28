//
//  CommandActionButton.swift
//  ScriptRunnerUI
//
//  Created by Krazis on 28.09.2026.
//

import SwiftUI

struct CommandActionButton: View {
    let status: TaskStatus
    var onClick: ((_ isRuning: Bool) -> Void)? = nil
    
    private var isRunned: Bool {
        return self.status == TaskStatus.ready || self.status == TaskStatus.start
    }
    
    private var labelButton: String {
        if (isRunned) {
            return "Stop"
        } else {
            return "Run"
        }
    }
    
    var body: some View {
        Button(action: {onClick?(isRunned)}) {
            Text(labelButton)
                .padding(.horizontal, 20)
                .padding(.vertical, 7)
                .contentShape(Rectangle())
        }
        .buttonStyle(AnimatedButtonStyle())
    }
}

#Preview {
    CommandActionButton(status: TaskStatus.none).frame(width: 100, height: 100)
}
