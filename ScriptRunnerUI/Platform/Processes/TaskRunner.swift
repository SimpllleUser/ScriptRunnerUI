import Foundation

class TaskRunner {
    
    func runCommand(
        packageManager: String, // Назва менеджера (npm, yarn, bun)
        projectPath: String, // Шлях до папки з проєктом
        arguments: [String], // Масив аргументів (наприклад, ["run", "dev"])
        onOutput: @escaping (String) -> Void, // Коллбек для передачі тексту з консолі в UI
        onComplete: @escaping (Int32) -> Void // Коллбек для передачі статусу завершення (0 - успіх, інші - помилка)
    ) {
        // 1. Ініціалізація процесу та труби (Pipe) для перехоплення виводу
        let task = Process()
        let pipe = Pipe()
        
        // 2. Вказуємо шлях до оболонки (zsh), через яку будемо виконувати команди
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        
        // 3. Формуємо команду: якщо рядок порожній, використовуємо npm як фолбек
        let manager = packageManager.isEmpty ? "npm" : packageManager
        let commandArgs = arguments.joined(separator: " ") // Об'єднуємо масив ["run", "dev"] у рядок "run dev"
        
        // 4. Створюємо мультирядковий скрипт для налаштування середовища перед запуском
        let fullCommand = """
        export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH" # Додаємо шляхи Homebrew
        export NVM_DIR="$HOME/.nvm" # Вказуємо шлях до NVM (Node Version Manager)
        [ -s "$NVM_DIR/nvm.sh" ] && \\. "$NVM_DIR/nvm.sh" # Завантажуємо NVM, якщо він існує
        source $HOME/.zshrc 2>/dev/null # Примусово читаємо налаштування користувача (ігноруємо помилки)
        cd '\(projectPath)' && \(manager) \(commandArgs) # Переходимо в папку проєкту і запускаємо команду
        """
        
        // 5. Передаємо аргументи для zsh
        // -i: інтерактивний режим, -l: login shell (завантажує профілі), -c: виконати наступний рядок
        task.arguments = ["-i", "-l", "-c", fullCommand]
        
        // 6. Прив'язуємо нашу трубу (Pipe) до стандартного виводу та виводу помилок
        task.standardOutput = pipe
        task.standardError = pipe
        
        // 7. Налаштовуємо асинхронне читання даних, щойно вони з'являються в процесі
        pipe.fileHandleForReading.readabilityHandler = { fileHandle in
            let data = fileHandle.availableData
            if !data.isEmpty, let output = String(data: data, encoding: .utf8) {
                // Перемикаємось на головний потік, оскільки цей блок працює у фоні, а UI оновлюється лише в Main
                DispatchQueue.main.async {
                    onOutput(output)
                }
            }
        }
        
        // 8. Налаштовуємо дію при завершенні процесу
        task.terminationHandler = { process in
            pipe.fileHandleForReading.readabilityHandler = nil // Відключаємо слухача, щоб уникнути витоків пам'яті
            DispatchQueue.main.async {
                onComplete(process.terminationStatus) // Повертаємо код завершення (0 = ОК)
            }
        }
        
        // 9. Запуск процесу з обробкою можливої помилки старту
        do {
            try task.run()
        } catch {
            DispatchQueue.main.async {
                onOutput("Error: \(error.localizedDescription)\n")
                onComplete(-1) // Повертаємо -1, що означає помилку запуску
            }
        }
    }
}
