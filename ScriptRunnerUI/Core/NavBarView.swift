//
//  NavBarView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 09.09.2026.
//

import SwiftUI

struct NavBarView: View {
    let projects: [Project]
    @State var activeProjectId: UUID

    init(projects: [Project]) {
        self.projects = projects
        _activeProjectId = State(initialValue: projects.first?.id ?? UUID())
    }

    private func isActive(id: UUID) -> Bool {
        return activeProjectId == id
    }
    var selectable: ((_ id: UUID) -> Void)? = nil
    var body: some View {
        VStack {
            HStack {
                Text("Projects").textCase(.uppercase).font(Font.body.bold()).font(.caption).tracking(2)
            }.padding(.bottom, 5)
            ForEach(projects) {
                project in
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(project.name)
                            .font(Typography.sidebarItem)
                            .foregroundStyle(isActive(id: project.id) ? Theme.Surface.paper2 : Theme.Text.ink)
                        Text(project.path)
                            .font(.caption)
                            .foregroundStyle(Theme.Text.ink4).lineLimit(1)
                    }
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(isActive(id: project.id) ? Theme.Brand.brand : Theme.Surface.paper2)
                .cornerRadius(5)
                .onTapGesture{
                    withAnimation(.easeInOut) {
                        activeProjectId = project.id
                        selectable?(project.id)
                    }
                }
            
                
            }
            Spacer()
        }
        .padding(.top, 15)
        .padding(.horizontal, 10)
        .background(Theme.Surface.paper2)
        .frame(maxHeight: CGFloat.infinity)
        
    }
}

#Preview {
    NavBarView(projects: DEV_PROJECTS)
}
