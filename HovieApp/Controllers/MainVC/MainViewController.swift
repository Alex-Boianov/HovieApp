//
//  MainViewController.swift
//  Hovie App
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: Variables
    private var collectionView: UICollectionView!
    private let searchController = UISearchController(searchResultsController: nil)

    private var viewModel = MoviesViewModel()
    private var cellDataSourse: [CellViewModel] = []
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupNavBar()
        createCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getData()
        setupsSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCollectionView()
    }

    override func viewDidLayoutSubviews() {
        setupGradientBackground()
    }
    
    // MARK: setup methods
    private func bindViewModel() {
        viewModel.cellDataSourse.bind { [weak self] countries in
            guard let self, let countries = countries else { return }
            
            cellDataSourse = countries
        }
    }
    
    private func setupGradientBackground() {
        let firstColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            firstColor.cgColor,
            UIColor.lightGray.cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupsSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search..."
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
    }
    
    private func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.width / 2) - 16, height: 300)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
        ]
        self.title = "Hovie"
    }
    
    private func makeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        return transition
    }
}

// MARK: - UICollectionView extension
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let inSerchMode = self.viewModel.isInSearchMode(searchController)
        
        return inSerchMode ? self.viewModel.filteredMovies.count : 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            fatalError("Unable to dequeue MovieCell")
        }
        
        let inSerchMode = self.viewModel.isInSearchMode(searchController)
        let movie = inSerchMode ? self.viewModel.filteredMovies[indexPath.item] : cellDataSourse[indexPath.item]
        
        cell.configure(with: movie)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let inSerchMode = self.viewModel.isInSearchMode(searchController)
        let movie = inSerchMode ? self.viewModel.filteredMovies[indexPath.item] : cellDataSourse[indexPath.item]
        let recMovies = Recommendations.getRecommendations(for: movie, from: cellDataSourse)
        
        let detailVC = MovieDetailsViewController(movie: movie, recMovies: recMovies, dataSourse: cellDataSourse)
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen

        view.window!.layer.add(makeTransition(), forKey: kCATransition)
        
        present(navigationController, animated: false, completion: nil)
    }
}

// MARK: - UISearchBar extension
extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
        self.collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.collectionView.reloadData()
    }
}

