import UIKit

enum ImageStore {
    private static let directoryName = "item_images"

    private static func imagesDirectory() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent(directoryName)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    static func save(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let fileURL = imagesDirectory().appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
            return "\(directoryName)/\(filename)"
        } catch {
            return nil
        }
    }

    static func load(relativePath: String) -> UIImage? {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docs.appendingPathComponent(relativePath)
        return UIImage(contentsOfFile: fileURL.path)
    }

    static func delete(relativePath: String) {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docs.appendingPathComponent(relativePath)
        try? FileManager.default.removeItem(at: fileURL)
    }
}
