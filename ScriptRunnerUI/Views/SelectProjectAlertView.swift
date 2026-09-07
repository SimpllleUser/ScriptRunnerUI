//
//  SelectProjectAlertView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 04.09.2026.
//

import SwiftUI

struct SelectProjectAlertView: View {
    
    struct PackageJSON: Codable {
        let scripts: [String: String]?
    }
    
    var onProjectSelected: (String) -> Void
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
                    selectFile()
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
    
    private func selectFile() {
        // Open dialog for select project
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                onProjectSelected(url.path)
                if let content = readFile(at: "\(url.path)/package.json") {
                    if let scriptsDictionary = extractScripts(from: content) {
                        for (name, command) in scriptsDictionary {
                            print("Назва: \(name) | Команда: \(command)")
                        }
                    }
                }
            }
        }
    }
    
    func readFile(at path: String) -> String? {
        let fileURL = URL(fileURLWithPath: path)
        
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            return content
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func extractScripts(from jsonString: String) -> [String: String]? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }
        do {
            let decoded = try JSONDecoder().decode(PackageJSON.self, from: jsonData)
            return decoded.scripts
        } catch {
            print("Помилка парсингу JSON: \(error.localizedDescription)")
            return nil
        }
    }
}

#Preview {
    SelectProjectAlertView(onProjectSelected: { url in
        print("URL :\(url)")
    })
    .frame(width: 800, height: 800)
}
