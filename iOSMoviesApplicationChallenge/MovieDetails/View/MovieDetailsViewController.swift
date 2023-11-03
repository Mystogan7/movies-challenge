//
//  MovieDetailsViewController.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
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
        label.numberOfLines = 0
        return label
    }()
    
    private let genresLabel: UILabel = {
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
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    var movieId: Int!
    
    private var viewModel: MovieDetailsViewModelProtocol = MovieDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchDetails(for: movieId)
        
        self.view.accessibilityIdentifier = "movieDetails"
    }
    
    func bindViewModel() {
        viewModel.onFetchSuccess = { [weak self] details in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let url = MoviesAPI.Endpoint.moviePoster(path: details.backdropPath).url() {
                    self.posterImageView.loadImage(for: url)
                }
                self.titleLabel.text = details.title
                self.releaseDateLabel.text = "Release Date: \(details.releaseDate)"
                self.overviewLabel.text = details.overview
                self.ratingLabel.text = "Rating: \(details.voteAverage)/10"
                
                let genreNames = details.genres.map { $0.name }
                let genreText = genreNames.joined(separator: ", ")
                self.genresLabel.text = genreText
            }
        }
        
        viewModel.onFetchFailure = { error in
            print("An error occured while fetching the movie details: \(error.localizedDescription)")
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [posterImageView, titleLabel, releaseDateLabel, genresLabel, overviewLabel, ratingLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}

