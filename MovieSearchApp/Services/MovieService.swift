//
//  MovieService.swift
//  MovieSearchApp
//
//  Created by Amit Sharma on 17/07/24.
//

import Foundation
import Alamofire

class MovieService {
    
    
    func fetchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(baseURL)/search/movie"
        let parameters: [String: Any] = ["api_key": apiKey, "query": query]
        
        AF.request(url, parameters: parameters).responseDecodable(of: APIResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                completion(.success(apiResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func fetchMovieDetails(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/movie/\(id)?api_key=\(apiKey)&append_to_response=credits") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                completion(.success(movie))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
