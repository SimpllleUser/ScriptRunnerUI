//
//  Project.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 06.09.2026.
//

import SwiftData
import Foundation
 
@Model
final class Project: Equatable {
    var id: UUID
    var path: String
    var commands: [String: String]
    var name: String
    var packageManager: String
    
    init (path: String, commands: [String: String], name: String, packageManager: String) {
        self.id = UUID()
        self.path = path
        self.commands = commands
        self.name = name
        self.packageManager = packageManager
    }
}
