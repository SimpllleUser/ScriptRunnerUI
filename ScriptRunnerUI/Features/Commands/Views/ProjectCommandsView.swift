import SwiftUI

struct ProjectCommandsView: View {
    let project: Project
    let manager: ProcessManagerCommand
    @State private var activeIndex: Int? = nil
    
    init(project: Project, manager: ProcessManagerCommand) {
        self.project = project
        self.manager = manager
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
                        status: manager.getCommandStatus(command: element.key),
                        selectCommand: {
                            manager.setActiveCommand(command: element.key)
                        }
                    ) {
                        CommandActionButton(status: manager.getCommandStatus(command: element.key)) {
                            isRunned in
                            manager.setActiveCommand(command: element.key)
                            if(isRunned) {
                                manager.stopCommand(command: element.key)
                            } else {
                                manager.runCommand(packageManager: project.packageManager, command: element.key)
                                
                            }
                        }
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
        if (!manager.getCommandResult().isEmpty) {
            ConsoleView(value: manager.getCommandResult())
        }
    }
}
