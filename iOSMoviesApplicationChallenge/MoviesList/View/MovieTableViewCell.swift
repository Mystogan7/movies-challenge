//
//  MovieTableViewCell.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieCell"
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 9
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 12)
        return label
    }()
    
    private let voteLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    private func setupUI() {
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, overviewLabel, releaseDateLabel, voteLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        
        let mainStackView = UIStackView(arrangedSubviews: [posterImageView, textStackView])
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.alignment = .top
        mainStackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(mainStackView)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    private func resetCell() {
        if let imageUrl = posterImageView.imageURL {
            ImageLoader.shared.cancelOngoingTask(for: imageUrl)
        }
        
        titleLabel.text = nil
        overviewLabel.text = nil
        releaseDateLabel.text = nil
        posterImageView.image = nil
    }
    
    private func loadImage(for url: URL, into imageView: UIImageView) {
        imageView.image = nil
        imageView.imageURL = url
        
        ImageLoader.shared.loadImage(from: url) { [weak imageView] image in
            if let image = image, let currentURL = imageView?.imageURL, currentURL == url {
                imageView?.image = image
            }
        }
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
        voteLabel.text = "Rating: \(movie.voteAverage)/10"
        
        guard let url = MoviesAPI.Endpoint.moviePoster(path: movie.posterPath).url() else {
            print("Invalid poster url: \(movie.posterPath)")
            return
        }
        
        loadImage(for: url, into: posterImageView)
    }
}
