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
    var scripts: [String]
    var name: String
    
    init (path: String, scripts: [String], name: String) {
        self.id = UUID()
        self.path = path
        self.scripts = scripts
        self.name = name
    }
}
