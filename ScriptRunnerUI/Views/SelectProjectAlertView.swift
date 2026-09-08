//
//  SelectProjectAlertView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 04.09.2026.
//

import SwiftUI

struct SelectProjectAlertView: View {
    
    var onProjectSelected: (String, [String]) -> Void
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "folder")
                    .foregroundStyle(Theme.Text.ink4)
                    .font(.system(size: 45))
            }.padding(.bottom, 10)
            HStack(spacing: 0) {
                Text("No projects")
                    .font(Typography.projectTitle)
                    .padding(15)
            }
            HStack {
                Text("Add a folder that contains package.json.")
                    .font(.system(.title3))
                    .foregroundStyle(Theme.Text.ink4)
            }
            .padding(15)
            HStack {
                Button(action: {
                    selectFile(onProjectSelected: onProjectSelected)
                }){
                    Text("Add project")
                        .foregroundStyle(Theme.Surface.paper)
                        .padding(.vertical, 3)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .padding(5)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: CornerRadius.toolbarSidebarItem)
                        .fill(Theme.Brand.brand)
                    
                )
            }
        }
    }
    
}

#Preview {
    SelectProjectAlertView(onProjectSelected: { url, commands in
        print("URL :\(url)")
    })
    .frame(width: 800, height: 800)
}
