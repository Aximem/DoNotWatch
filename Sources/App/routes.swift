import Vapor
import Fluent

public func routes(_ router: Router) throws {
    
    // Rest API
    let movieController = MovieController()
    try router.register(collection: movieController)
    
    // Front IHM
    let indexController = IndexController()
    try router.register(collection: indexController)
    
}
