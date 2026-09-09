//
//  ContentView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 03.09.2026.
//

import SwiftUI
import SwiftData
import AppKit

enum DialogStateTypes { case base, errror, success }

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Project.name) private var projects: [Project]
    @State private var viewModel = ProjectViewModel()
    
    @State var currentProject = "my-vue-app"
    @State var projectPath = "~/mu-pc/projects/CRM"
    @State var showAlertOpenProject = false
    //    @State var commands: [String: String]
    @State var dialogState = DialogStateTypes.base
    var body: some View {
        VStack() {
            HeaderView(title: "Cardona", projectPath: projectPath, isMutipleLock: false)
            Spacer()
            VStack {
                ForEach(projects) { project in
                    HStack {
                        Text(project.name).padding(2).background(Color.blue).foregroundStyle(Color.black)
                        Divider()
                        Text(project.path).padding(2).background(Color.blue).foregroundStyle(Color.black)
                        Divider()
                        ForEach(Array(project.commands.keys), id: \.self) { key in
                            HStack {
                                Text(key)
                                    .padding(2)
                                    .background(Color.green)
                                    .foregroundStyle(Color.black)
                                if let value = project.commands[key] {
                                    Text(value)
                                        .padding(2)
                                        .background(Color.gray)
                                        .foregroundStyle(Color.black)
                                }
                            }
                        }
                    }
                }
            }
        }.background(Theme.Surface.paper)
            .frame(alignment: .topLeading)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(currentProject)
                        .foregroundStyle(Theme.Text.ink)
                        .font(Typography.sidebarItem)
                }.sharedBackgroundVisibility(Visibility.hidden)
                ToolbarItem(placement: .automatic) {
                    HStack(spacing: 15) {
                        ButtonView(label: "Stop all", icon: "stop.circle", onClick: {
                            print("Stop")
                        })
                        ButtonView(icon: "arrow.trianglehead.clockwise.rotate.90",onClick: {
                            viewModel.deleteAllProjects(context: modelContext)
                        })
                        ButtonView(icon: "folder", onClick: {
                            showAlertOpenProject = true
                            
                        })
                    }.padding(.trailing, 15)
                }.sharedBackgroundVisibility(Visibility.hidden)
            }.background(Color.red)
            .customDialog(isPresented: $showAlertOpenProject) {
                if (dialogState == .base) {
                    SelectProjectAlertView { result in
                        guard let result = result else {
                            dialogState = .errror
                            return
                        }
                        self.projectPath = result.path
                        self.currentProject = String(result.path.split(separator: "/").last ?? "")
                        viewModel.addProject(
                            name: self.currentProject,
                            path: self.projectPath,
                            commands: result.commands,
                            context: modelContext
                        )
                        showAlertOpenProject = false
                    }
                } else if (dialogState == .errror) {
                    ErrorSelectProjectAlert(reload: {
                        dialogState = .base
                    })
                }
            }.onChange(of: showAlertOpenProject) { oldValue, newValue in
                if newValue == false {
                    dialogState = .base
                }
            }
    }
}

#Preview {
    ContentView()
        .frame(width: 1080, height: 832)
}
