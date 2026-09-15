import SwiftUI


func selectFile(onProjectSelected: ((_ result: (path: String, commands: [String: String])?) -> Void)) {
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    
    guard panel.runModal() == .OK,
          let url = panel.url,
          let content = readFile(at: "\(url.path)/package.json"),
          let scriptsDictionary = extractScripts(from: content) else {
        onProjectSelected(nil)
        return
    }
    
    onProjectSelected((path: url.path, commands: scriptsDictionary))
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

