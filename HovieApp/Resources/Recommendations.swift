//
//  Recommendations.swift
//  HovieApp
//

class Recommendations {
    static func getRecommendations(for movie: CellViewModel, from movies: [CellViewModel]) -> [CellViewModel] {
        let filteredMovies = movies.filter { $0.name != movie.name }
        
        let movieGenres = movie.genre.components(separatedBy: ", ")

        var recommendationsSet: Set<CellViewModel> = []

        for genre in movieGenres {
            let genreMovies = filteredMovies.filter { $0.genre.contains(genre) }
            recommendationsSet.formUnion(genreMovies)
        }

        recommendationsSet.remove(movie)

        var recommendations = Array(recommendationsSet)

        while recommendations.count < 3, let randomMovie = filteredMovies.randomElement(), !recommendations.contains(where: { $0.name == randomMovie.name }) {
            recommendations.append(randomMovie)
        }
        
        recommendations.shuffle()

        return Array(recommendations.prefix(3))
    }
}
