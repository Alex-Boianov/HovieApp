//
//  CellViewModel.swift
//  Hovie App
//

import Foundation

struct CellViewModel {
    let name, year, rated, released: String
    let runtime, genre, director, writer: String
    let actors, plot, language, country: String
    let awards: String
    let imdbRating: String
    let boxOffice: String
    var imageURL: URL?
    
    init(movie: MovieModel) {
        self.name = movie.title
        self.country = movie.country
        self.actors = movie.actors
        self.awards = movie.awards
        self.boxOffice = movie.boxOffice
        self.director = movie.director
        self.genre = movie.genre
        self.imdbRating = movie.imdbRating
        self.language = movie.language
        self.plot = movie.plot
        self.rated = movie.rated
        self.released = movie.released
        self.runtime = movie.runtime
        self.writer = movie.writer
        self.year = movie.year
        self.imageURL = getImageURL(from: movie.poster)
    }
    
    private func getImageURL(from string: String) -> URL? {
        URL(string: string)
    }
}

extension CellViewModel: Hashable {
    static func == (lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        return lhs.name == rhs.name &&
        lhs.year == rhs.year &&
        lhs.rated == rhs.rated &&
        lhs.released == rhs.released &&
        lhs.runtime == rhs.runtime &&
        lhs.genre == rhs.genre &&
        lhs.director == rhs.director &&
        lhs.writer == rhs.writer &&
        lhs.actors == rhs.actors &&
        lhs.plot == rhs.plot &&
        lhs.language == rhs.language &&
        lhs.country == rhs.country &&
        lhs.awards == rhs.awards &&
        lhs.imdbRating == rhs.imdbRating &&
        lhs.boxOffice == rhs.boxOffice &&
        lhs.imageURL == rhs.imageURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(year)
        hasher.combine(rated)
        hasher.combine(released)
        hasher.combine(runtime)
        hasher.combine(genre)
        hasher.combine(director)
        hasher.combine(writer)
        hasher.combine(actors)
        hasher.combine(plot)
        hasher.combine(language)
        hasher.combine(country)
        hasher.combine(awards)
        hasher.combine(imdbRating)
        hasher.combine(boxOffice)
        hasher.combine(imageURL)
    }
}
