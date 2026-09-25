
import Foundation

enum TaskStatus {
    case none
    case start
    case ready
    case error
}



import Foundation

class TaskRunner {

    // Зберігаємо процес для перевірки стану та зупинки.
    private var task: Process?

    // Чи працює процес у цей момент.
    var isRunning: Bool {
        task?.isRunning ?? false
    }

    func runCommand(
        packageManager: String,
        projectPath: String,
        arguments: [String],

        // Процес успішно запущений операційною системою.
        onStart: @escaping () -> Void = {},

        // Сервер повідомив про готовність.
        // Для Nuxt визначаємо за повідомленням "Local:".
        onReady: @escaping () -> Void = {},

        // Вивід консолі в реальному часі.
        onOutput: @escaping (String) -> Void,

        // Процес завершився.
        onComplete: @escaping (Int32) -> Void
    ) {

        // MARK: - 1. Перевірка процесу

        // Не запускаємо другу команду, поки
        // попередня ще виконується.
        guard task == nil else {
            onOutput("A command is already running.\n")
            return
        }

        // MARK: - 2. Ініціалізація

        let process = Process()
        let pipe = Pipe()

        task = process

        process.executableURL = URL(
            fileURLWithPath: "/bin/zsh"
        )

        // MARK: - 3. Формування команди

        let manager = packageManager.isEmpty
            ? "npm"
            : packageManager

        // Екранування значень для shell.
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

        // MARK: - 4. Налаштування потоків

        process.standardOutput = pipe
        process.standardError = pipe

        // Прапорець, який запобігає повторному onReady.
        // Змінюємо його лише в головній черзі.
        var isReady = false

        // Тимчасовий буфер для пошуку повідомлення
        // про готовність сервера.
        var outputBuffer = ""

        // MARK: - 5. Отримання виводу

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

                // Передаємо текст у UI.
                onOutput(output)

                // Якщо сервер уже готовий,
                // повторно не перевіряємо вивід.
                guard !isReady else {
                    return
                }

                outputBuffer += output

                // Nuxt зазвичай виводить:
                // ➜ Local: http://localhost:3000/
                //
                // Це спрощений індикатор готовності.
                // Інші CLI-команди можуть не мати
                // такого повідомлення.
                if outputBuffer.contains("Local:") {
                    isReady = true
                    outputBuffer = ""

                    onReady()
                }

                // Не дозволяємо буферу
                // необмежено збільшуватися.
                if outputBuffer.count > 4096 {
                    outputBuffer = String(
                        outputBuffer.suffix(4096)
                    )
                }
            }
        }

        // MARK: - 6. Завершення процесу

        process.terminationHandler = { [weak self] finishedProcess in

            // Зупиняємо обробник нових повідомлень.
            pipe.fileHandleForReading.readabilityHandler = nil

            // Отримуємо залишок даних із Pipe.
            let remainingData = pipe.fileHandleForReading
                .readDataToEndOfFile()

            let remainingOutput = String(
                decoding: remainingData,
                as: UTF8.self
            )

            DispatchQueue.main.async {

                // Передаємо залишок виводу.
                if !remainingOutput.isEmpty {
                    onOutput(remainingOutput)
                }

                // Звільняємо процес після завершення.
                if self?.task === finishedProcess {
                    self?.task = nil
                }

                // onComplete викликається навіть тоді,
                // коли сервер так і не став готовим.
                onComplete(finishedProcess.terminationStatus)
            }
        }

        // MARK: - 7. Запуск процесу

        do {
            try process.run()

            DispatchQueue.main.async {

                // Успішний task.run() означає,
                // що zsh запустився.
                //
                // Це ще НЕ означає, що Nuxt
                // завершив компіляцію або готовий
                // приймати HTTP-запити.
                onStart()
            }

        } catch {

            pipe.fileHandleForReading.readabilityHandler = nil

            if task === process {
                task = nil
            }

            DispatchQueue.main.async {
                onOutput(
                    "Error: \(error.localizedDescription)\n"
                )

                onComplete(-1)
            }
        }
    }

    // MARK: - 8. Зупинка процесу

    func stopCommand() {
        guard let task, task.isRunning else {
            return
        }

        // Надсилаємо процесу SIGTERM.
        // Це не гарантує зупинку всіх
        // дочірніх процесів zsh.
        task.terminate()
    }
}
