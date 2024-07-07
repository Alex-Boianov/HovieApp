//
//  ApiCaller.swift
//  Hovie App
//

import Foundation

enum NetworkError: Error {
    case urlError
    case parsingError(String)
}

class ApiCaller {
    static let imdbIDs = ["tt0111162", "tt0068646", "tt0468569", "tt0110912", "tt0108052", "tt1375666", "tt0137523", "tt0109830", "tt0133093", "tt0099685", "tt0080684", "tt0073486", "tt0120737", "tt0107290", "tt0172495", "tt0816692", "tt0120689", "tt0110357", "tt0088247", "tt0088763"]
    static let apiKey = "5766c4a6"
    
    static func getData(complitionHandler: @escaping (_ inresult: Result<[MovieModel], NetworkError>) -> Void ) {
        var movies: [MovieModel] = []
        let group = DispatchGroup()

        for imdbID in imdbIDs {
            group.enter()
            let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&i=\(imdbID)"
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                group.leave()
                continue
            }

            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }
                guard let data = data, let movie = try? JSONDecoder().decode(MovieModel.self, from: data) else {
                    print("Error decoding data")
                    return
                }
                DispatchQueue.main.async {
                    movies.append(movie)
                }
            }.resume()
        }

        group.wait()
        
        group.notify(queue: .main) {
            complitionHandler(.success(movies))
        }
    }
}
