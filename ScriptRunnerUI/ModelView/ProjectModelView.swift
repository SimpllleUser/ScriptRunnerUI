//
//  ProjectModelView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 06.09.2026.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
@MainActor
final class ProjectViewModel {
    
//    private let context: ModelContext
//    private var projects: [Project] = []
    
    init() {
        
    }
    
    func addProject(name: String, path: String, scripts: [String], context: ModelContext) {
        let newProject = Project(path: path, scripts: scripts,  name: name)
        context.insert(newProject)
    }
    
    func removeProject(project: Project, context: ModelContext) {
        context.delete(project)
    }
}
