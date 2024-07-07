//
//  MPAFilmRating.swift
//  HovieApp
//

import UIKit

enum MPAFilmRating: String {
    case G = "G"
    case PG = "PG"
    case PG13 = "PG-13"
    case R = "R"
    case NC17 = "NC-17"
    case Unrated = "Unrated"

    var color: UIColor {
        switch self {
        case .G:
            return UIColor.green
        case .PG:
            return UIColor.orange
        case .PG13:
            return UIColor.purple
        case .R:
            return UIColor.red
        case .NC17:
            return UIColor.blue
        case .Unrated:
            return UIColor.gray
        }
    }

    init?(rating: String) {
        self.init(rawValue: rating)
    }
}
