import SwiftUI
import SwiftData
import AppKit

enum DialogStateTypes {
    case base
    case error
    case success
}

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Project.name) private var projects: [Project]
    @State private var executionStore = ProjectExecutionStore()
    @State private var viewModel = ProjectStore()
    @AppStorage("projectId") private var projectIdString: String = DEV_PROJECTS.first?.id.uuidString ?? ""
    @State private var projectId: UUID? = nil
    @State var projectPath = "~/mu-pc/projects/CRM"
    
    @State var showAlertOpenProject = false
    @State var dialogState = DialogStateTypes.base
    @State var activeIndex: Int? = nil

    private var currentProject: Project? {
        guard let projectId else {
            return nil
        }

        return projects.first { $0.id == projectId }
    }

    private var currentManager: ProcessManagerCommand? {
        guard let currentProject else {
            return nil
        }

        return executionStore.manager(for: currentProject)
    }
    
    
    private func getBackgroundColor(index: Int) -> Color{
        if (index == activeIndex) {return Theme.Brand.brand50}
        return index % 2 == 0 ? Theme.Surface.paper2 : Theme.Surface.paper
    }
    
    var body: some View {
        HStack(spacing: 0) {
            
            ProjectSideBarView(projects: projects, activeProjectId: $projectId)
                .frame(maxHeight: .infinity)
                .overlay(
                    Rectangle()
                        .fill(Theme.Surface.paper3)
                        .frame(width: 2),
                    alignment: .trailing
                )
                .onChange(of: projectId) { _, newValue in
                    if let newValue = newValue {
                        projectIdString = newValue.uuidString
                    }
                }
                .onChange(of: projectIdString) { _, newValue in
                    projectId = UUID(uuidString: newValue)
                }
            
            VStack(spacing: 0) {
                if (currentProject != nil) {
                    if let currentProject, let currentManager {
                        ProjectCommandsView(
                            project: currentProject,
                            manager: currentManager
                        )
                    }
                } else {
                    Text("You dont have any project")
                        .font(Typography.projectTitle)
                        .foregroundStyle(Theme.Text.ink4)
                        .padding(15)
                }
                
                Spacer()
            }
        }
        .onChange(of: projects) { _, newProjects in
            if projectId == nil,
               let firstProject = newProjects.first {
                projectId = firstProject.id
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(Theme.Surface.paper)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(currentProject?.name ?? "")
                    .foregroundStyle(Theme.Text.ink)
                    .font(Typography.sidebarItem)
            }
            .sharedBackgroundVisibility(.hidden)
            
            ToolbarItem(placement: .automatic) {
                HStack(spacing: 15) {
                    AppButton(
                        label: "Stop all",
                        icon: "stop.circle",
                        onClick: {
                            currentManager?.stopAll()
                        }
                    )
                    
                    AppButton(
                        icon: "arrow.trianglehead.clockwise.rotate.90",
                        onClick: {
                            currentManager?.restartActiveCommands(packageManager: currentProject?.packageManager ?? "")
//                            viewModel.deleteAllProjects(context: modelContext)
                        }
                    )
                    
                    AppButton(
                        icon: "folder",
                        onClick: {
                            showAlertOpenProject = true
                        }
                    )
                }
                .padding(.trailing, 15)
            }
            .sharedBackgroundVisibility(.hidden)
        }
        .customDialog(isPresented: $showAlertOpenProject) {
            if dialogState == .base {
                AddProjectSheet{ result in
                    guard let result = result else {
                        dialogState = .error
                        return
                    }
                    
                    let name = String(result.path.split(separator: "/").last ?? "")
                    
                    viewModel.addProject(
                        name: name,
                        path: result.path,
                        commands: result.commands,
                        packageManager: result.packageManager,
                        context: modelContext,
                    )
                    
                    showAlertOpenProject = false
                }
            } else if dialogState == .error {
                InvalidPackageManifestView {
                    dialogState = .base
                }
            }
        }
        .onChange(of: showAlertOpenProject) { _, newValue in
            if !newValue {
                dialogState = .base
            }
        }
        .onAppear {
            if projectId == nil, let firstId = projects.first?.id {
                projectId = firstId
            }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 1080, height: 832)
}

