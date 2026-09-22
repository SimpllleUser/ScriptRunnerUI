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
final class ProjectStore {
    
//    private let context: ModelContext
//    private var projects: [Project] = []
    
    init() {
        
    }
    
    func addProject(name: String, path: String, commands: [String: String], context: ModelContext) {
        let newProject = Project(path: path, commands: commands,  name: name)
        context.insert(newProject)
    }
    
    func removeProject(project: Project, context: ModelContext) {
        context.delete(project)
    }
    
    func deleteAllProjects(context: ModelContext) {
            do {
                try context.delete(model: Project.self)
                print("Базу даних успішно очищено!")
            } catch {
                print("Помилка очищення БД: \(error.localizedDescription)")
            }
        }
}
