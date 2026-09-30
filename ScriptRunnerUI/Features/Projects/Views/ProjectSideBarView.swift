//
//  NavBarView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 09.09.2026.
//

import SwiftUI

struct ProjectSideBarView: View {
    let projects: [Project]
    let executionStore: ProjectExecutionStore
    
    @Binding var activeProjectId: UUID?
    
    var body: some View {
        VStack {
            HStack {
                Text("Projects")
                    .textCase(.uppercase)
                    .font(.body.bold())
                    .font(.caption)
                    .tracking(2)
            }
            .padding(.bottom, 5)
            
            ForEach(projects, id: \.id) { project in
                let isActive = activeProjectId == project.id
                let foregroundColor = isActive ? Theme.Surface.paper2 : Theme.Text.ink
                let backgroundColor = isActive ? Theme.Brand.brand : Theme.Surface.paper2
                let processManager = executionStore.manager(for: project)
                
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            VStack(alignment: HorizontalAlignment.leading){
                                Text(project.name)
                                    .font(Typography.sidebarItem)
                                    .foregroundStyle(foregroundColor)
                                
                                Text(project.path)
                                    .font(.caption)
                                    .foregroundStyle(Theme.Text.ink4)
                                    .lineLimit(1)
                            }
                            Spacer()
                            if (processManager.getAmountActiveCommands() > 0) {
                                Text(String(processManager.getAmountActiveCommands())).font(.caption)
                                    .opacity(1)
                                    .frame(width: 10, height: 10)
                                    .background(
                                        Circle()
                                            .fill(Theme.Surface.paper.opacity(0.5))                            ).frame(width: 8, height: 8, alignment: Alignment.center)
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(backgroundColor)
                .cornerRadius(5)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        activeProjectId = project.id
                    }
                }
            }
            
            Spacer()
        }
        .frame(width: 300)
        .frame(maxHeight: .infinity)
        .padding(.top, 15)
        .padding(.horizontal, 10)
        .background(Theme.Surface.paper2)
    }
}

#Preview {
    @Previewable @State var activeProjectId: UUID? = DEV_PROJECTS.first?.id
    
    ProjectSideBarView(
        projects: DEV_PROJECTS,
        executionStore: ProjectExecutionStore(),
        activeProjectId: $activeProjectId
    )
}

