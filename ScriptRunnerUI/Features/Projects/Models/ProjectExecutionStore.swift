//
//  ProjectExecutionStore.swift
//  ScriptRunnerUI
//
//  Created by Krazis on 28.09.2026.
//

import SwiftUI

@Observable
class ProjectExecutionStore {
    private var mannagers: [UUID: ProcessManagerCommand] = [:]
    
    func mannager(for project: Project) -> ProcessManagerCommand {
        if let mannager = mannagers[project.id] {
            return mannager
        }
        
        let mannager = ProcessManagerCommand(
            projectId: project.id,
            commands: Array(project.commands.keys),
            path: project.path
        )
        mannagers[project.id] = mannager
        return mannager
    }
}
