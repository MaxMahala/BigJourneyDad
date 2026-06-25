import SwiftUI
import UIKit

final class BAS_ImageStorage {
    static let shared = BAS_ImageStorage()

    private let folderName = "BAS_UserImages"

    private var folderURL: URL {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = base.appendingPathComponent(folderName, isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        return url
    }

    func saveImage(_ image: UIImage) -> String {
        let identifier = "bas_img_\(UUID().uuidString)"
        let fileURL = folderURL.appendingPathComponent("\(identifier).jpg")
        if let data = image.jpegData(compressionQuality: 0.88) {
            try? data.write(to: fileURL)
        }
        return identifier
    }

    func loadImage(named identifier: String) -> UIImage? {
        guard identifier.hasPrefix("bas_img_") else { return nil }
        let fileURL = folderURL.appendingPathComponent("\(identifier).jpg")
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    func deleteImage(named identifier: String) {
        guard identifier.hasPrefix("bas_img_") else { return }
        let fileURL = folderURL.appendingPathComponent("\(identifier).jpg")
        try? FileManager.default.removeItem(at: fileURL)
    }
}
