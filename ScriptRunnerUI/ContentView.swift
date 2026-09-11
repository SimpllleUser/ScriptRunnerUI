import SwiftUI
import SwiftData
import AppKit

enum DialogStateTypes {
    case base
    case errror
    case success
}

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Project.name) private var projects: [Project]
    
    @State private var viewModel = ProjectViewModel()
    
    @State var currentProject = "my-vue-app"
    @State var projectPath = "~/mu-pc/projects/CRM"
    
    @State var showAlertOpenProject = false
    @State var dialogState = DialogStateTypes.base
    
    var body: some View {
        HStack(spacing: 0) {
            
            NavBarView(projects: DEV_PROJECTS)
                .frame(width: 300)
                .frame(maxHeight: .infinity)
                .overlay(
                    Rectangle()
                        .fill(Theme.Surface.paper3)
                        .frame(width: 2),
                    alignment: .trailing
                )
            
            VStack(spacing: 0) {
                HeaderView(
                    title: "Cardona",
                    projectPath: projectPath,
                    isMutipleLock: false
                )
                .padding(.top, 12)
                
                Spacer()
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .background(Theme.Surface.paper)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(currentProject)
                    .foregroundStyle(Theme.Text.ink)
                    .font(Typography.sidebarItem)
            }
            .sharedBackgroundVisibility(.hidden)
            
            ToolbarItem(placement: .automatic) {
                HStack(spacing: 15) {
                    ButtonView(
                        label: "Stop all",
                        icon: "stop.circle",
                        onClick: {
                            print("Stop")
                        }
                    )
                    
                    ButtonView(
                        icon: "arrow.trianglehead.clockwise.rotate.90",
                        onClick: {
                            viewModel.deleteAllProjects(context: modelContext)
                        }
                    )
                    
                    ButtonView(
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
                SelectProjectAlertView { result in
                    guard let result = result else {
                        dialogState = .errror
                        return
                    }
                    
                    projectPath = result.path
                    currentProject = String(
                        result.path.split(separator: "/").last ?? ""
                    )
                    
                    viewModel.addProject(
                        name: currentProject,
                        path: projectPath,
                        commands: result.commands,
                        context: modelContext
                    )
                    
                    showAlertOpenProject = false
                }
            } else if dialogState == .errror {
                ErrorSelectProjectAlert {
                    dialogState = .base
                }
            }
        }
        .onChange(of: showAlertOpenProject) { _, newValue in
            if !newValue {
                dialogState = .base
            }
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 1080, height: 832)
}
