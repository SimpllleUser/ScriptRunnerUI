//
//  CommandRow.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 12.09.2026.
//

import SwiftUI

struct CommandRow: View {
    let name: String
    let value: String
    let status: String
    
    private func getStatusColor () -> Color {
        var color = Theme.Status.idle
        
        switch status {
        case CommandStatuses.error:
            color = Theme.Status.failed
        case CommandStatuses.base:
            color = Theme.Status.idle
        default:
            color = Theme.Status.running
        }
        return color
    }
    
    var body: some View {
        HStack {
            Circle().fill(getStatusColor()).frame(width: 10, height: 10)
            VStack(alignment: .leading) {
                Text(name).font(Typography.sidebarItem)
                Text(value).font(Typography.mono).foregroundStyle(Theme.Text.ink3)
            }
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    CommandRow(name: "dev", value: "npm run dev", status: CommandStatuses.error)
        .padding(20)
}
