import Foundation
import Realm
import Realm.Dynamic
import Realm.Private

@objc(RLMTextDataExporter)
open class TextDataExporter: DataExporter {
    func exportText(toFolderAtPath outputFolderPath: String, schemas: [String]? = nil) throws {
        for objectSchema in realm.schema.objectSchema {
            let filePath = Path(outputFolderPath) + Path("\(objectSchema.className).txt")

            if filePath.exists {
                try filePath.delete()
            }
            
            if let schemas = schemas {
                if !schemas.contains(objectSchema.className) {
                    continue
                }
            }
            
            try filePath.write("")
            
            let fileHandle = FileHandle(forWritingAtPath: String(describing: filePath))
            fileHandle?.seekToEndOfFile()
            
            let objects = realm.allObjects(objectSchema.className)
            
            for object in (0 ..< objects.count).map({ objects.object(at: $0) as RLMObject }) {
                let objectStr = "\(object)\n\n"
                print(objectStr)
                fileHandle?.write(objectStr.data(using: .utf8)!)
            }
            fileHandle?.closeFile()
        }
    }
}
