import SwiftUI

struct PackageJSON: Decodable {
    let scripts: [String: String]?
}


func selectFile(onProjectSelected: ((_ result: (path: String, commands: [String])?) -> Void)) {
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
    
    let commands = Array(scriptsDictionary.keys)
    onProjectSelected((path: url.path, commands: commands))
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

private func extractScripts(from jsonString: String) -> [String: String]? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
    }
    do {
        let decoded = try JSONDecoder().decode(PackageJSON.self, from: jsonData)
        return decoded.scripts
    } catch {
        print("Error of decoding JSON: \(error.localizedDescription)")
        return nil
    }
}
