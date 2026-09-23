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
      let status: CommandStatuses
      @ViewBuilder let content: () -> Content
    
      init(
          name: String,
          value: String,
          status: CommandStatuses,
          @ViewBuilder content: @escaping () -> Content
      ) {
          self.name = name
          self.value = value
          self.status = status
          self.content = content
      }

      init(name: String, value: String, status: CommandStatuses) where Content
      == EmptyView {
          self.name = name
          self.value = value
          self.status = status
          self.content = { EmptyView() }
      }

    
    private var statusColor: Color {
        switch status {
        case .error: Theme.Status.failed
        case .base: Theme.Status.idle
        case .active: Theme.Status.running
        }
    }
    
    var body: some View {
        HStack {
            Circle().fill(statusColor).frame(width: 10, height: 10)
            VStack(alignment: .leading) {
                Text(name).font(Typography.sidebarItem)
                Text(value).font(Typography.mono).foregroundStyle(Theme.Text.ink3)
            }
            Spacer()
            content()

        }
        .padding(20)
    }
}

#Preview {
    CommandRow(name: "dev", value: "npm run dev", status: CommandStatuses.error) {
        Text("Run")
    }
}
