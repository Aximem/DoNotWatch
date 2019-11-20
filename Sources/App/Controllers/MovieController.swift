import Vapor
import Fluent

struct MovieController: RouteCollection {
    
    func boot(router: Router) throws {
        
        // CRUD
        
        // READ : Get Movies
        router.get("v1", "movies") { req -> Future<[Movie]> in
            return Movie.query(on: req)
                .all()
        }
        
        // CREATE : Add Movie
        router.post("v1", "movies") { req -> Future<Movie> in
            return try req.content.decode(Movie.self)
                .flatMap(to: Movie.self) { movie in
                    return movie.save(on: req)
                }
        }
        
        // UPDATE : Edit Movie
        router.put("v1", "movies", Movie.parameter) { req -> Future<Movie> in
            return try flatMap(to: Movie.self,
                               req.parameters.next(Movie.self),
                               req.content.decode(Movie.self)) { movie, updatedMovie in
                                movie.title = updatedMovie.title
                                movie.imageUrl = updatedMovie.imageUrl
                                movie.rating = updatedMovie.rating
                                return movie.save(on: req)
                               }
        }
        
        // DELETE : Delete Movie
        router.delete("v1", "movies", Movie.parameter) { req -> Future<HTTPStatus> in
            return try req.parameters.next(Movie.self)
                .delete(on: req)
                .transform(to: HTTPStatus.noContent)
        }
    }
}
