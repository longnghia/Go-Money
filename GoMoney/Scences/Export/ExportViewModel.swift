import RealmSwift

enum ExportType {
    case csv, json, txt, realm
}

class ExportViewModel {
    func export(type: ExportType, outputFolderPath: String = FileUtil.documentPath, completion: @escaping (Error?) -> Void) {
        DispatchQueue.global().async {
            do {
                guard let realmFilePath = FileUtil.realmPath else {
                    completion(FileError.fileNotFound)
                    return
                }

                switch type {
                case .csv:
                    let exporter = try CSVDataExporter(realmFilePath: realmFilePath)
                    try exporter.exportSchemas(
                        toFolderAtPath: outputFolderPath,
                        schemas: [String(describing: Expense.self)])

                case .txt:
                    let exporter = try TextDataExporter(realmFilePath: realmFilePath)
                    try exporter.exportText(
                        toFolderAtPath: outputFolderPath,
                        schemas: [String(describing: Expense.self)])

                case .json:
                    // TODO: export json
                    break

                case .realm:
                    // TODO: copy realm file to outputFolderPath
                    break
                }
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
