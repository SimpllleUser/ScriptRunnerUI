//
//  DecodeConfig.swift
//  ScriptRunnerUI
//
//  Created by Krazis on 23.09.2026.
//

import Foundation
import SwiftUI

struct PackageJSON: Decodable {
    let scripts: [String: String]?
    let packageManager: String?
}

func extractScripts(from jsonString: String) -> (scripts: [String: String]?, packageManager: String)? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
    }
    do {
        let decoded = try JSONDecoder().decode(PackageJSON.self, from: jsonData)
        let packageManager = decoded.packageManager?.components(separatedBy: "@").first ?? ""
        return (scripts: decoded.scripts, packageManager: packageManager)
    } catch {
        print("Error of decoding JSON: \(error.localizedDescription)")
        return nil
    }
}
