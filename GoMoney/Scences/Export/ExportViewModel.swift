import RealmSwift

enum ExportType {
    case csv, json, txt, realm
}

class ExportViewModel {
    func export(type: ExportType, completion: @escaping (Result<URL, Error>) -> Void) {
        DispatchQueue.global().async {
            do {
                let exporter = RealmConverter()
                let url: URL
                switch type {
                case .csv:
                    url = try exporter.exportCSV()

                case .txt:
                    url = try exporter.exportTxt()

                case .json:
                    url = try exporter.exportJSON()

                case .realm:
                    url = try exporter.exportRealm()
                }
                completion(.success(url))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
