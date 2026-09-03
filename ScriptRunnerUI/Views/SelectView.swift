//
//  HeaderView.swift
//  ScriptRunnerUI
//
//  Created by v.pecheritsya on 03.09.2026.
//

import SwiftUI

struct SelectView: View {
    @Binding var selection: String
    let options = ["npm", "yarn", "pnpm"]
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    selection = option
                }
            }
        } label: {
            HStack(spacing: 6) {
                Text(selection)
                    .font(Typography.sidebarItem)
                Image(systemName: "circle.fill")
                    .foregroundStyle(Theme.Text.ink4)
                    .font(.system(size: 3))
                    .font(Typography.mono)
                Image(systemName: "chevron.down")
                    .foregroundStyle(Theme.Text.ink2)
                    .font(Typography.mono)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Theme.Surface.paper3)
            .clipShape(Capsule())
        }.buttonStyle(.plain)
    }
}

#Preview("Select") {
    SelectView(selection: .constant("npm"))
        .padding(100)
}
