//
//  MovieCollectionViewCell.swift
//  Hovie App
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCell"
    private var imageView = UIImageView()
    private let titleButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // Configure imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure button
        titleButton.setTitleColor(.white, for: .normal)
        titleButton.titleLabel?.font = UIFont(name: "SFMono-Regular", size: 16)
        titleButton.backgroundColor = .darkGray
        titleButton.layer.cornerRadius = 15
        contentView.addSubview(titleButton)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: titleButton.topAnchor, constant: -8),
            
            titleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            titleButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with movie: CellViewModel) {
        imageView.sd_setImage(with: movie.imageURL)
        titleButton.setTitle(movie.name, for: .normal)
    }
}
