
import Foundation

enum TaskStatus {
    case none
    case start
    case ready
    case error
}


@MainActor
class TaskRunner {

    // Унікальний ключ команди в межах проєкту.
    struct CommandKey: Hashable {
        let projectId: UUID
        let command: String
    }

    // Внутрішня інформація про кожен запуск.
    private struct RunningTask {
        let id: UUID
        let key: CommandKey
        let process: Process
    }

    // Усі активні процеси.
    private var tasks: [UUID: RunningTask] = [:]

    var isRunning: Bool {
        !tasks.isEmpty
    }

    var runningCount: Int {
        tasks.count
    }

    // Перевірка стану конкретної команди.
    func isRunning(
        projectId: UUID,
        command: String
    ) -> Bool {
        let key = CommandKey(
            projectId: projectId,
            command: command
        )

        return tasks.values.contains {
            $0.key == key && $0.process.isRunning
        }
    }

    // MARK: - Запуск команди

    @discardableResult
    func runCommand(
        projectId: UUID,
        packageManager: String,
        projectPath: String,
        arguments: [String],
        onStart: @escaping () -> Void = {},
        onReady: @escaping () -> Void = {},
        onOutput: @escaping (String) -> Void,
        onComplete: @escaping (Int32) -> Void
    ) -> UUID {

        let id = UUID()

        // Використовуємо назву скрипта як ключ.
        // Наприклад: ["run", "dev"] -> "dev".
        let command = arguments.last ?? ""

        let key = CommandKey(
            projectId: projectId,
            command: command
        )

        let process = Process()
        let pipe = Pipe()

        process.executableURL = URL(
            fileURLWithPath: "/bin/zsh"
        )

        // MARK: - Формування команди

        let manager = packageManager.isEmpty
            ? "npm"
            : packageManager

        func shellEscape(_ value: String) -> String {
            "'" + value.replacingOccurrences(
                of: "'",
                with: "'\\''"
            ) + "'"
        }

        let commandArgs = arguments
            .map(shellEscape)
            .joined(separator: " ")

        let fullCommand = """
        export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        source "$HOME/.zshrc" 2>/dev/null
        cd \(shellEscape(projectPath)) && \
        \(shellEscape(manager)) \(commandArgs)
        """

        process.arguments = [
            "-i",
            "-l",
            "-c",
            fullCommand
        ]

        process.standardOutput = pipe
        process.standardError = pipe

        var isReady = false
        var outputBuffer = ""

        // MARK: - Вивід процесу

        pipe.fileHandleForReading.readabilityHandler = {
            fileHandle in

            let data = fileHandle.availableData

            guard !data.isEmpty else {
                return
            }

            let output = String(
                decoding: data,
                as: UTF8.self
            )

            DispatchQueue.main.async {
                onOutput(output)

                guard !isReady else {
                    return
                }

                outputBuffer += output

                if outputBuffer.contains("Local:") {
                    isReady = true
                    outputBuffer = ""
                    onReady()
                }

                if outputBuffer.count > 4096 {
                    outputBuffer = String(
                        outputBuffer.suffix(4096)
                    )
                }
            }
        }

        // MARK: - Завершення

        process.terminationHandler = { [weak self] finishedProcess in

            pipe.fileHandleForReading.readabilityHandler = nil

            let remainingData = pipe.fileHandleForReading
                .readDataToEndOfFile()

            let remainingOutput = String(
                decoding: remainingData,
                as: UTF8.self
            )

            DispatchQueue.main.async {
                if !remainingOutput.isEmpty {
                    onOutput(remainingOutput)
                }

                self?.tasks.removeValue(forKey: id)

                onComplete(finishedProcess.terminationStatus)
            }
        }

        // MARK: - Запуск

        do {
            try process.run()

            tasks[id] = RunningTask(
                id: id,
                key: key,
                process: process
            )

            onStart()

        } catch {
            pipe.fileHandleForReading.readabilityHandler = nil

            onOutput(
                "Error: \(error.localizedDescription)\n"
            )

            onComplete(-1)
        }

        return id
    }

    // MARK: - Зупинка конкретної команди

    func stopCommand(
        projectId: UUID,
        command: String
    ) -> Bool {
        let key = CommandKey(
            projectId: projectId,
            command: command
        )
        
        var stopped = false

        for task in tasks.values where task.key == key {
            if task.process.isRunning {
                task.process.terminate()
            }
        }
        
        return true
    }

    // MARK: - Зупинка конкретного запуску

    func stopCommand(id: UUID) {
        guard let task = tasks[id],
              task.process.isRunning else {
            return
        }

        task.process.terminate()
    }

    // MARK: - Зупинка всіх процесів

    func stopAll() {
        for task in tasks.values {
            if task.process.isRunning {
                task.process.terminate()
            }
        }
    }
}
