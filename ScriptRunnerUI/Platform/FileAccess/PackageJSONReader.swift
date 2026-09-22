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
}

func extractScripts(from jsonString: String) -> [String: String]? {
    guard let jsonData = jsonString.data(using: .utf8) else {
        return nil
    }
    do {
        let decoded = try JSONDecoder().decode(PackageJSON.self, from: jsonData)
        return decoded.scripts
    } catch {
        print("Error of decoding JSON: \(error.localizedDescription)")
        return nil
    }
}
