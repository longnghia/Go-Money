import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getDocumentFilePath(fileName: String) -> URL {
    let documentPath = getDocumentsDirectory()
    let filePath = documentPath.appendingPathComponent(fileName)

    return filePath
}
