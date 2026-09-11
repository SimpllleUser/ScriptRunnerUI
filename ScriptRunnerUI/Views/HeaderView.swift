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
            }.padding(.horizontal, 10)
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
                    .padding(.bottom, projectPath.isEmpty ? 15 : 0)
            }.padding(.horizontal, 10)
            Divider()
            Spacer()
        }
        .background(Theme.Surface.paper)
    }
}

#Preview("13\" MacBook - Default") {
    HeaderView(title: "web-dashboard", projectPath: "test", isMutipleLock: true)
        .frame(width: 1280, height: 832, alignment: .topLeading)
}
