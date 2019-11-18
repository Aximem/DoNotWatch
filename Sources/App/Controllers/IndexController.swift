import Vapor
import Leaf

struct IndexController: RouteCollection {
    
    func boot(router: Router) throws {
        // Pages
        router.get("", use: index)
        router.get("create", use: movieCreate)
        
        // Actions
        router.post(Movie.self, at: "movies", use: movies)
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
}

struct IndexContext: Encodable {
    let movies: [Movie]?
}
