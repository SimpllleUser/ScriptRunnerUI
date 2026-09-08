//
//  ErrorSelectProjectAlert.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 08.09.2026.
//

import SwiftUI

struct ErrorSelectProjectAlert: View {
    
    var reload: (() -> Void)

    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundStyle(Theme.Status.stderr)
                    .font(.system(size: 45))
            }.padding(.bottom, 10)
            HStack(spacing: 0) {
                Text("Could not read package.json")
                    .font(Typography.projectTitle)
                    .padding(15)
            }
            HStack {
                Text("package.json has an incorrect format: The given data was not valid JSON.")
                    .padding(.horizontal, 15)
                    .font(.system(.title3))
                    .foregroundStyle(Theme.Text.ink4)
            }
            .padding(15)
            HStack {
                ButtonView(label: "Reload", onClick: reload)
            }
        }

    }
}

#Preview {
    ErrorSelectProjectAlert(reload: {
        print("Reload")
    }).frame(width: .infinity, height: 300)
}
