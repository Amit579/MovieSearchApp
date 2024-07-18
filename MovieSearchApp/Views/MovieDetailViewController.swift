//
//  MovieDetailViewController.swift
//  MovieSearchApp
//
//  Created by Amit Sharma on 17/07/24.
//

import UIKit
import Alamofire


class MovieDetailViewController: UIViewController {
    
    var movieId: Int?
    var movie: Movie?
    var castValue = [CastMember]()
    let movieService = MovieService()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movieId = movieId else { return }
        fetchMovieDetails(id: movieId)
    }
    
    func fetchMovieDetails(id: Int) {
        movieService.fetchMovieDetails(id: id) { [weak self] result in
            switch result {
            case .success(let movie):
                self?.movie = movie
                DispatchQueue.main.async {
                    self?.updateUI()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorAlert(message: "Failed to fetch movie details: \(error.localizedDescription)")
                }
            }
        }
    }
    func updateUI() {
        guard let movie = movie else { return }
        titleLabel.text = movie.title
        ratingLabel.text = "Rating: \(movie.voteAverage ?? 0.0)"
        descriptionLabel.text = movie.overview
        posterImageView.kf.setImage(with: URL(string: movie.posterPath ?? ""))
        if let cast = movie.credits?.cast {
            castLabel.text = cast.compactMap { $0.name }.joined(separator: ", ")
        } else {
            castLabel.text = "Cast information not available."
        }
        if let posterPath = movie.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.kf.setImage(with: posterURL)
        } else {
            posterImageView.image = UIImage(named: "placeholder_image")
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func toggleFavorite(_ sender: UIButton) {
        guard let movie = movie else { return }
        let isFavorite = PersistenceManager.shared.fetchFavorites().contains(where: { $0.id == movie.id })
        if isFavorite {
            PersistenceManager.shared.removeFavorite(id: movie.id)
        } else {
            PersistenceManager.shared.addFavorite(movie: movie)
        }
        updateFavoriteButton()
    }
    
    func updateFavoriteButton() {
        guard let movie = movie else { return }
        let isFavorite = PersistenceManager.shared.fetchFavorites().contains(where: { $0.id == movie.id })
        print(isFavorite)
    }
}
