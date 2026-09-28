//
//  ProjectExecutionStore.swift
//  ScriptRunnerUI
//
//  Created by Krazis on 28.09.2026.
//

import SwiftUI

@Observable
class ProjectExecutionStore {
    private var managers: [UUID: ProcessManagerCommand] = [:]
    
    func manager(for project: Project) -> ProcessManagerCommand {
        if let manager = managers[project.id] {
            return manager
        }
        
        let manager = ProcessManagerCommand(
            projectId: project.id,
            commands: Array(project.commands.keys),
            path: project.path
        )
        managers[project.id] = manager
        return manager
    }
}
