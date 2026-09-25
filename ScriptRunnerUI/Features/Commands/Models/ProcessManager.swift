//
//  ProcessManager.swift
//  ScriptRunnerUI
//
//  Created by Krazis on 25.09.2026.
//

import SwiftUI

@Observable
class ProcessManagerCommand {
    var commands: [String]
    var activeComand: String? = ""
    private var processOutput: [String: String]
    var runner = TaskRunner()
    var path: String

    init(commands: [String], path: String) {
        self.commands = commands
        self.activeComand = ""
        self.processOutput = commands.reduce(into: [String: String]()) { result, key in result[key] = "" }
        self.path = path
    }
    
    private func setCommandResult(command: String, result: String)  {
        self.processOutput[command] = (self.processOutput[command] ?? "") + result
    }
    
    func resetCommandResult(command: String) {
        self.processOutput[command] = ""
    }
    
    func setActiveCommand(command: String) {
        self.activeComand = command
    }
    
    func getCommandResult() -> String {
        return self.processOutput[self.activeComand ?? ""] ?? ""
    }
    
    func runCommand(packageManager: String, command: String) {
        self.runner.runCommand(
            packageManager: packageManager,
            projectPath: self.path,
            arguments: [command],
            onOutput: {
                output in
                self.setCommandResult(command: command, result: output)
            },
            onComplete: {
                complete in
                print(complete)
            })
    }
}
