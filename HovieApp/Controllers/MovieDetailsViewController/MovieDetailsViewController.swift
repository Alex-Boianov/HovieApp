//
//  MovieDetailsViewController.swift
//  Hovie App
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {

    // MARK: @IBOutlets
    var collectionView: UICollectionView!
    var watchAlsoLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var customView: UIView!
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var language: UIButton!
    @IBOutlet weak var rated: UIButton!
    @IBOutlet weak var yearAndTime: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var plot: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var box: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var awards: UILabel!
    @IBOutlet weak var imdbRating: UILabel!
    
    private var movie: CellViewModel
    private var dataSourse: [CellViewModel]
    private var recMovies: [CellViewModel]

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        setupConstraintsForCustomView()
    }
    
    init(movie: CellViewModel, recMovies: [CellViewModel], dataSourse: [CellViewModel]) {
        self.movie = movie
        self.recMovies = recMovies
        self.dataSourse = dataSourse
        super.init(nibName: "MovieDetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Logic
    private func setupConstraintsForCustomView() {
        setupRecCollectionView()
        setupWatchAlsoLabel()
        
        NSLayoutConstraint.activate([
            customView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        customView.addSubview(watchAlsoLabel)
        customView.addSubview(collectionView)
        
        watchAlsoLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor).isActive = true
        watchAlsoLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: watchAlsoLabel.bottomAnchor, constant: 10).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: customView.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: customView.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: customView.bottomAnchor).isActive = true
    }
    
    private func setupRecCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MovieRecommendationCell", bundle: nil), forCellWithReuseIdentifier: "MovieRecommendationCell")
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
    }
    
    private func setupWatchAlsoLabel() {
        watchAlsoLabel = UILabel()
        
        let attributedString = NSAttributedString(string: "Watch also:", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)
        ])
        watchAlsoLabel.attributedText = attributedString
        
        watchAlsoLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .done, target: self, action: #selector(dismissDetailViewController))
    }

    @objc private func dismissDetailViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupUI() {
        scrollView.contentInsetAdjustmentBehavior = .never
        
        self.actors.text = movie.actors
        self.awards.text = movie.awards
        self.box.text = movie.boxOffice
        self.country.text = movie.country
        self.director.text = movie.director
        self.genre.text = movie.genre
        self.imdbRating.text = movie.imdbRating
        self.language.setTitle(movie.language, for: .normal)
        language.sizeToFit()
        self.movieTitle.text = movie.name
        self.plot.text = movie.plot
        self.poster.sd_setImage(with: movie.imageURL)
        self.rated.setTitle(movie.rated, for: .normal)
        setButtonColor(button: rated, rating: movie.rated)
        rated.sizeToFit()
        self.released.text = movie.released
        self.writer.text = movie.writer
        self.yearAndTime.text = String(movie.year + " • " + movie.runtime)
    }
    
    
    private func setButtonColor(button: UIButton, rating: String) {
        if let filmRating = MPAFilmRating(rating: rating) {
            button.setTitleColor(filmRating.color, for: .normal)
        } else {
            button.setTitleColor(UIColor.black , for: .normal)
        }
        
        button.setTitle(rating, for: .normal)
    }
}

// MARK: - UICollectionView extension
extension MovieDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieRecommendationCell", for: indexPath) as! MovieRecommendationCell
        
        cell.setUp(with: recMovies[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = recMovies[indexPath.item]
        let recMovies = Recommendations.getRecommendations(for: selectedMovie, from: dataSourse)
        
        let detailVC = MovieDetailsViewController(movie: selectedMovie, recMovies: recMovies, dataSourse: dataSourse)
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: false, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 160)
    }
}
