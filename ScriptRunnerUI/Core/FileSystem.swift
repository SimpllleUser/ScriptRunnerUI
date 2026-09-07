import Foundation

let rawJSON = """
{
    "dynamicKey1": "якийсь текст",
    "dynamicKey2": 42,
    "dynamicKey3": true,
    "nestedObject": {
        "innerKey": "innerValue"
    }
}
"""

func parseUnknownJSON(jsonString: String) {
    guard let data = jsonString.data(using: .utf8) else { return }
    
    do {
        if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            print(jsonDictionary)
            for (key, value) in jsonDictionary {
                print("Ключ: \(key)")
                
                if let stringValue = value as? String {
                    print("Значення (Рядок): \(stringValue)")
                } else if let intValue = value as? Int {
                    print("Значення (Число): \(intValue)")
                } else if let boolValue = value as? Bool {
                    print("Значення (Булеве): \(boolValue)")
                } else if let nestedDict = value as? [String: Any] {
                    print("Значення (Вкладений об'єкт): \(nestedDict)")
                    
                    if let innerValue = nestedDict["innerKey"] as? String {
                        print("Дістали вкладене значення: \(innerValue)")
                    }
                } else if let arrayValue = value as? [Any] {
                    print("Значення (Масив): \(arrayValue)")
                } else {
                    print("Невідомий тип: \(value)")
                }
                
                print("---")
            }
        }
    } catch {
        print(error)
    }
}


func readFile(at path: String) -> String? {
    let fileURL = URL(fileURLWithPath: path)
    
    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        return content
    } catch {
        print(error.localizedDescription)
        return nil
    }
}
