import SwiftUI


struct ProjectData {
    let path: String
    let commands: [String: String]
    let packageManager: String
}

func selectFile(onProjectSelected: (ProjectData?) -> Void) {
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    
    guard panel.runModal() == .OK, let url = panel.url else {
        onProjectSelected(nil)
        return
    }
    
    let packagePath = url.appendingPathComponent("package.json").path
    
    guard let content = readFile(at: packagePath),
          let extractedData = extractScripts(from: content),
          let scriptsDictionary = extractedData.scripts else {
        onProjectSelected(nil)
        return
    }
    
    let projectData = ProjectData(
        path: url.path,
        commands: scriptsDictionary,
        packageManager: extractedData.packageManager
    )
    
    onProjectSelected(projectData)
}

private func readFile(at path: String) -> String? {
    let fileURL = URL(fileURLWithPath: path)
    
    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        return content
    } catch {
        print("Error of read package.json:\(error.localizedDescription)")
        return nil
    }
}

