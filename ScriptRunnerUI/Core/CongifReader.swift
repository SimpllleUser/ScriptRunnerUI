import SwiftUI

struct PackageJSON: Decodable {
    let scripts: [String: String]?
}


func selectFile(onProjectSelected: ((_ path: String, _ commands: [String]) -> Void)) {
    var commands: [String] = []
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = true
    panel.canChooseFiles = false
    
    if panel.runModal() == .OK {
        if let url = panel.url {
            if let content = readFile(at: "\(url.path)/package.json") {
                if let scriptsDictionary = extractScripts(from: content) {
                    for (name, _) in scriptsDictionary {
                        commands.append(name)
                    }
                }
                onProjectSelected(url.path, commands)
            }
        }
    }
}

private func readFile(at path: String) -> String? {
    let fileURL = URL(fileURLWithPath: path)
    
    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        return content
    } catch {
        print(error.localizedDescription)
        return nil
    }
}

private func extractScripts(from jsonString: String) -> [String: String]? {
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
