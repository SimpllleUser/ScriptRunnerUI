//
//  ContentView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 03.09.2026.
//

import SwiftUI
import SwiftData
import AppKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var currentProject = "my-vue-app"
    @State var projectPath = "~/mu-pc/projects/CRM"
    @State var showAlertOpenProject = false
    var body: some View {
        VStack() {
            HeaderView(title: "Cardona", projectPath: projectPath, isMutipleLock: false)
            Spacer()
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
                            print("Refresah")
                        })
                        ButtonView(icon: "folder", onClick: {
                            showAlertOpenProject = true
                            
                        })
                    }.padding(.trailing, 15)
                }.sharedBackgroundVisibility(Visibility.hidden)
            }.background(Color.red)
            .customDialog(isPresented: $showAlertOpenProject) {
                SelectProjectAlertView {
                     url in
                        self.projectPath = url
                    self.showAlertOpenProject.toggle()
                    }
            }
    }
}

#Preview {
    ContentView()
        .frame(width: 1080, height: 832)
}
