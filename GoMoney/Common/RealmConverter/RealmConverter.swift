import Foundation
import RealmSwift

class RealmConverter {
    let realm = try! Realm()

    let delimiter = ","

    let escapeQuotes = "\""

    func exportCSV() throws -> URL {
        let fileName = "Transactions-\(DateFormatter.ddmmyyyy.string(from: Date())).csv"

        let filePath = Path(getDocumentFilePath(fileName: fileName).relativePath)

        if filePath.exists {
            try filePath.delete()
        }

        let objectSchema = realm.schema.objectSchema.first(
            where: { $0.className == String(describing: Expense.self) })!

        // Build the initial row of property names and write to disk
        try filePath.write(
            objectSchema.properties.map { $0.name }.joined(separator: delimiter) + "\n"
        )

        // Write the remaining objects
        let fileHandle = FileHandle(forWritingAtPath: String(describing: filePath))
        fileHandle?.seekToEndOfFile()

        let objects = realm.objects(Expense.self)

        // Loop through each object in the table
        for object in objects {
            let row = objectSchema.properties.map { property in
                var value = object[property.name] as AnyObject
                if property.name == "tag" {
                    value = object.tag?.name as AnyObject
                }
                return sanitizedValue(value.description!)
            }
            let rowString: String = row.joined(separator: delimiter) + "\n"
            fileHandle?.write(rowString.data(using: .utf8)!)
        }
        fileHandle?.closeFile()

        return filePath.url
    }

    func exportTxt() throws -> URL {
        let fileName = "Transactions-\(DateFormatter.ddmmyyyy.string(from: Date())).txt"

        let filePath = Path(getDocumentFilePath(fileName: fileName).relativePath)

        if filePath.exists {
            try filePath.delete()
        }

        try filePath.write("")
        let fileHandle = FileHandle(forWritingAtPath: String(describing: filePath))
        fileHandle?.seekToEndOfFile()

        let objects = realm.objects(Expense.self)

        for object in objects {
            let rowString = "\(object.toRemoteTransaction())\n"
            fileHandle?.write(rowString.data(using: .utf8)!)
        }
        fileHandle?.closeFile()

        return filePath.url
    }

    func exportRealm() throws -> URL {
        return Realm.Configuration.defaultConfiguration.fileURL!
    }

    func exportJSON() throws -> URL {
        var arrayJson: [Any] = []

        let fileName = "Transactions-\(DateFormatter.ddmmyyyy.string(from: Date())).json"

        let filePath = Path(getDocumentFilePath(fileName: fileName).relativePath)

        if filePath.exists {
            try filePath.delete()
        }

        let objectSchema = realm.schema.objectSchema.first(
            where: { $0.className == String(describing: Expense.self) })!

        try filePath.write("")

        let fileHandle = FileHandle(forWritingAtPath: String(describing: filePath))
        fileHandle?.seekToEndOfFile()

        let objects = realm.objects(Expense.self)

        for object in objects {
            var jsonObject = [AnyHashable: Any]()
            objectSchema.properties.forEach { property in
                var value = object[property.name] as AnyObject
                if property.name == "tag" {
                    value = object.tag?.name as AnyObject
                }
                jsonObject[property.name] = value.description!
            }
            arrayJson.append(jsonObject)
        }

        let transactionJsonObject = ["Transactions": arrayJson]

        let data = try JSONSerialization.data(withJSONObject: transactionJsonObject, options: [.prettyPrinted])
        let transactionJsonStr = String(data: data, encoding: .utf8)

        if let transactionJsonStr = transactionJsonStr {
            fileHandle?.write(transactionJsonStr.data(using: .utf8)!)
        }

        fileHandle?.closeFile()

        return filePath.url
    }

    private func sanitizedValue(_ value: String) -> String {
        func valueByEscapingQuotes(_ string: String) -> String {
            return escapeQuotes + string + escapeQuotes
        }

        // Value already contains quotes, replace with 2 sets of quotes
        if value.range(of: escapeQuotes) != nil {
            return valueByEscapingQuotes(
                value.replacingOccurrences(of: escapeQuotes, with: escapeQuotes + escapeQuotes)
            )
        } else if value.range(of: " ") != nil || value.range(of: delimiter) != nil {
            return valueByEscapingQuotes(value)
        }
        return value
    }
}
