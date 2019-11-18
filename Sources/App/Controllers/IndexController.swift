import Vapor
import Leaf

struct IndexController: RouteCollection {
    
    func boot(router: Router) throws {
        // Pages
        router.get("", use: index)
        router.get("create", use: movieCreate)
        
        // Actions
        router.post(Movie.self, at: "movies", use: movies)
        router.post("update", Movie.parameter, Int.parameter, use: movieUpdate)
        router.post("delete", Movie.parameter, use: movieDelete)
    }
    
    // Index page
    func index(_ req: Request) throws -> Future<View> {
        return Movie.query(on: req)
            .sort(\.title, .ascending)
            .all()
            .flatMap(to: View.self) { movies in
                let indexContext = IndexContext(movies: movies)
                return try req.view().render("index", indexContext)
        }
    }
    
    // Create page
    func movieCreate(_ req: Request) throws -> Future<View> {
        return try req.view().render("create")
    }
    
    // Post a new movie and redirect to index page
    func movies(_ req: Request, movie: Movie) throws -> Future<Response> {
        return movie.save(on: req)
            .map(to: Response.self) { _ in
                return req.redirect(to: "/")
        }
    }
    
    // Update movie
    func movieUpdate(_ req: Request) throws -> Future<Response> {
        let movie = try req.parameters.next(Movie.self)
        let rating = try req.parameters.next(Int.self)
        return movie.flatMap { updateMovie in
            updateMovie.rating = rating
            return updateMovie.save(on: req)
                .map(to: Response.self) { savedMovie in
                    guard savedMovie.id != nil else {
                        throw Abort(.internalServerError)
                    }
                    return req.redirect(to: "/")
            }
        }
    }
    
    // Delete movie
    func movieDelete(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(Movie.self)
            .flatMap(to: Response.self) { movie in
                return movie.delete(on: req)
                    .transform(to: req.redirect(to: "/"))
        }
    }
}

struct IndexContext: Encodable {
    let movies: [Movie]?
}
