//
//  HeaderView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 03.09.2026.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let projectPath: String
    let isMutipleLock: Bool
    @State var packageManager = "npm"
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .foregroundStyle(Theme.Text.ink)
                    .font(Typography.projectTitle)
                Spacer()
            }
            .padding(.leading, 15)
            HStack(spacing: 0) {
                SelectView(selection: $packageManager)
                if (isMutipleLock) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundStyle(Theme.Status.stderr)
                        Text("Multiple lock files")
                    }.padding(.leading, 15)
                }
                Text(projectPath)
                    .foregroundStyle(Theme.Text.ink4)
                    .padding(.leading, 15)
            }.padding(.leading, 15)
            Divider()
        }
        .padding(.top, 15)
        .background(Theme.Surface.paper)
    }
}

#Preview("13\" MacBook - Default") {
    HeaderView(title: "web-dashboard", projectPath: "~/dev/web-dashboard", isMutipleLock: true)
        .frame(width: 1280, height: 832, alignment: .topLeading)
}
