//
//  ViewController.swift
//  MovieSearchApp
//
//  Created by Amit Sharma on 17/07/24.
//

import UIKit
import Alamofire
import Kingfisher

class MovieSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    var movies: [Movie] = []
    let movieService = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(UINib(nibName: "MovieSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            movies = []
            movieTableView.reloadData()
            return
        }
        
        movieService.fetchMovies(query: searchText) { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.movieTableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showErrorAlert(message: "Failed to fetch movies: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieSearchTableViewCell
        let movie = movies[indexPath.row]
        cell.titleLabel?.text = movie.title
        cell.descriptionTextLabel?.text = movie.releaseDate
        if let posterPath = movie.posterPath {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            cell.posterImageView.kf.setImage(with: posterURL)
        } else {
            cell.posterImageView.image = UIImage(named: "placeholder_image")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        performSegue(withIdentifier: "showMovieDetail", sender: movie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovieDetail" {
            if let destinationVC = segue.destination as? MovieDetailViewController, let movie = sender as? Movie {
                destinationVC.movieId = movie.id
            }
        }
    }
}

