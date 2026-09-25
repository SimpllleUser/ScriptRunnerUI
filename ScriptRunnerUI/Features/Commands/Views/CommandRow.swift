//
//  CommandRow.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 12.09.2026.
//

import SwiftUI

struct CommandRow<Content: View>: View {
    let name: String
    let value: String
    let status: TaskStatus
    @ViewBuilder let content: () -> Content
    var selectCommand: (() -> Void)? = nil
    
    init(
        name: String,
        value: String,
        status: TaskStatus,
        selectCommand: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.name = name
        self.value = value
        self.status = status
        self.selectCommand = selectCommand
        self.content = content
    }
    
    init(name: String, value: String, status: TaskStatus) where Content
    == EmptyView {
        self.name = name
        self.value = value
        self.status = status
        self.content = { EmptyView() }
    }
    
    
    private var statusColor: Color? {
        switch status {
        case .error: Theme.Status.failed
        case .none: Theme.Status.idle
        case .ready: Theme.Status.running
        case .start: nil
        }
    }
    
    var body: some View {
        HStack {
            if (statusColor != nil) {
                Circle().fill(statusColor ?? Theme.Status.idle).frame(width: 10, height: 10)
            } else {
                SpinnerApp(size: 10)
            }
            VStack(alignment: .leading) {
                Text(name).font(Typography.sidebarItem).onTapGesture {
                    selectCommand?()
                }
                Text(value).font(Typography.mono).foregroundStyle(Theme.Text.ink3)
            }
            Spacer()
            content()
            
        }
        .padding(20)
    }
}

#Preview {
    CommandRow(
        name: "dev",
        value: "npm run dev",
        status: TaskStatus.ready) {
            Text("Run")
        }
}
