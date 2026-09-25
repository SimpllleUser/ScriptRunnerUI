import SwiftUI

struct ProjectCommandsView: View {
    let project: Project
    @State private var processManager: ProcessManagerCommand
    @State private var activeIndex: Int? = nil
    
    init(project: Project) {
        self.project = project
        let commandsArray = Array(project.commands.keys)
        self._processManager = State(initialValue: ProcessManagerCommand(commands: commandsArray, path: project.path))
    }
    
    private func getBackgroundColor(index: Int) -> Color {
        if (index == activeIndex) { return Theme.Brand.brand50 }
        return index % 2 == 0 ? Theme.Surface.paper2 : Theme.Surface.paper
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(project.commands).enumerated(), id: \.element.key) { index, element in
                    CommandRow(
                        name: element.key,
                        value: element.value,
                        status: CommandStatuses.base,
                        selectCommand: {
                            processManager.setActiveCommand(command: element.key)
                        }
                    ) {
                        Button(action: {
                            processManager.setActiveCommand(command: element.key)
                            processManager.runCommand(
                                packageManager: project.packageManager,
                                command: element.key,
                            )
                        }) {
                            Text("Run")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 7)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(AnimatedButtonStyle())
                    }
                    .onHover { isHovering in
                        if isHovering {
                            activeIndex = index
                        } else if activeIndex == index {
                            activeIndex = nil
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(getBackgroundColor(index: index))
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(.top, 12)
        }
        if (!processManager.getCommandResult().isEmpty) {
            ScrollView {
                ConsoleView(value: processManager.getCommandResult())
            }
        }
    }
}
