import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var category: String
    var imagePath: String?
    var createdAt: Date

    init(title: String, category: String, imagePath: String? = nil) {
        self.title = title
        self.category = category
        self.imagePath = imagePath
        self.createdAt = Date()
    }
}
