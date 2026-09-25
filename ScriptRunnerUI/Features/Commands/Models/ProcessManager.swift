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
    var commandsStatuses: [String: TaskStatus]
    var activeComand: String? = ""
    private var processOutput: [String: String]
    var runner = TaskRunner()
    var path: String
    
    init(commands: [String], path: String) {
        self.commands = commands
        self.activeComand = ""
        self.processOutput = commands.reduce(into: [String: String]()) { result, key in result[key] = "" }
        self.path = path
        self.commandsStatuses = commands.reduce(into: [String: TaskStatus]()) { result, key in result[key] = TaskStatus.none }
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
    
    private func setCommandStatus(command: String, taskStatus: TaskStatus) {
        self.commandsStatuses[command] = taskStatus
    }
    func getCommandStatus(command: String) -> TaskStatus {
        return self.commandsStatuses[command] ?? TaskStatus.none
    }
    
    func runCommand(packageManager: String, command: String) {
        self.runner.runCommand(
            packageManager: packageManager,
            projectPath: self.path,
            arguments: [command],
            onStart: {
                self.setCommandStatus(command: command, taskStatus: .start)
            },
            onReady: {
                self.setCommandStatus(command: command, taskStatus: .ready)
            },
            onOutput: {
                output in
                self.setCommandResult(command: command, result: output)
            },
            onComplete: {
                status in
                if (status == -1) {
                    self.setCommandStatus(command: command, taskStatus: .error)
                }
            },
        )
    }
}
