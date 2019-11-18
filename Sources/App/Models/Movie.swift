import FluentMySQL
import Vapor

final class Movie: Codable {
    
    var id: Int?
    var title: String
    var imageUrl: String
    var rating: Int

    init(id: Int? = nil, title: String, imageUrl: String, rating: Int) {
        self.id = id
        self.title = title
        self.imageUrl = imageUrl
        self.rating = rating
    }
}

extension Movie: MySQLModel { }
extension Movie: Migration { }
extension Movie: Content { }
extension Movie: Parameter { }
