import RealmSwift

enum FileError: Error {
    case fileNotFound

    var localizedDescription: String {
        switch self {
        case .fileNotFound:
            return "File not found!"
        }
    }
}

enum FileUtil {
    static let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    static let documentPath = documentURL.relativePath
    static let realmPath = Realm.Configuration.defaultConfiguration.fileURL?.relativePath
}
