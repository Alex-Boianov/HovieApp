//
//  MoviesViewModel.swift
//  Hovie App
//

import UIKit

class MoviesViewModel {
    
    private(set) var filteredMovies: [CellViewModel] = []
    private var dataSourse: [MovieModel]?
    public var cellDataSourse: Observable<[CellViewModel]> = Observable(nil)
    
    func numbersOfSection() -> Int {
        return 1
    }
    
    func numbersOfRows(in section: Int) -> Int {
        return self.dataSourse?.count ?? 0
    }
    
    func getData() {
        ApiCaller.getData { [weak self] result in
            switch result {
            case .success(let data):
                guard let self else { return }
                dataSourse = data
                mapCellData()
            case .failure(let error):
                print("Get data error: \(error.localizedDescription)")
            }
        }
    }

    
    public func isInSearchMode(_ searchController: UISearchController) -> Bool {
        let isActive = searchController.isActive
        let selectedText = searchController.searchBar.text ?? ""
        
        return isActive && !selectedText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.filteredMovies = cellDataSourse.value ?? []
        
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { return }
            self.filteredMovies = filteredMovies.filter({ $0.name.lowercased().contains(searchText) })
        }
    }
}

extension MoviesViewModel {
    private func mapCellData() {
        self.cellDataSourse.value = self.dataSourse?.compactMap({ CellViewModel(movie: $0) })
    }
}
