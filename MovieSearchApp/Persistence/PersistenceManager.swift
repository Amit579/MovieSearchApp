//
//  PersistenceManager.swift
//  MovieSearchApp
//
//  Created by Amit Sharma on 17/07/24.
//

import Foundation
import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "MovieSearchApp")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchFavorites() -> [FavoriteMovie] {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorites: \(error)")
            return []
        }
    }
    
    func addFavorite(movie: Movie) {
        let context = container.viewContext
        let favorite = FavoriteMovie(context: context)
        favorite.id = Int64(movie.id)
        favorite.title = movie.title
        favorite.posterPath = movie.posterPath
        favorite.releaseDate = movie.releaseDate
        favorite.overview = movie.overview
        favorite.voteAverage = movie.voteAverage ?? 0.0
        
        saveContext()
    }
    
    func removeFavorite(id: Int) {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            if let favorite = try context.fetch(fetchRequest).first {
                context.delete(favorite)
                saveContext()
            }
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }
}
