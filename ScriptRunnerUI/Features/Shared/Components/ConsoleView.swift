//
//  ConsoleView.swift
//  ScriptRunnerUI
//
//  Created by Krazis on 24.09.2026.
//

import SwiftUI

struct ConsoleView: View {
    let value: String
    var body: some View {
        VStack(spacing: 16) {
            ScrollViewReader { proxy in
                ScrollView {
                    Text(value)
                        .font(Typography.mono)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
                .cornerRadius(8)
                .frame(height: 300)
            }
        }
    }
}

#Preview {
    ConsoleView(value: CONSOLE_RESULT)
}
