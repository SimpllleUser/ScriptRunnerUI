import Foundation

class TaskRunner {
    
    func runCommand(
        packageManager: String,
        projectPath: String,
        arguments: [String],
        onOutput: @escaping (String) -> Void,
        onComplete: @escaping (Int32) -> Void
    ) {
        let task = Process()
        let pipe = Pipe()
        
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        
        let manager = packageManager.isEmpty ? "npm" : packageManager
        let commandArgs = arguments.joined(separator: " ")
        
        let fullCommand = """
        export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \\. "$NVM_DIR/nvm.sh"
        source $HOME/.zshrc 2>/dev/null
        cd '\(projectPath)' && \(manager) \(commandArgs)
        """
        
        task.arguments = ["-i", "-l", "-c", fullCommand]
        
        task.standardOutput = pipe
        task.standardError = pipe
        
        pipe.fileHandleForReading.readabilityHandler = { fileHandle in
            let data = fileHandle.availableData
            if !data.isEmpty, let output = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    onOutput(output)
                }
            }
        }
        
        task.terminationHandler = { process in
            pipe.fileHandleForReading.readabilityHandler = nil
            DispatchQueue.main.async {
                onComplete(process.terminationStatus)
            }
        }
        
        do {
            try task.run()
        } catch {
            DispatchQueue.main.async {
                onOutput("Error: \(error.localizedDescription)\n")
                onComplete(-1)
            }
        }
    }
}
