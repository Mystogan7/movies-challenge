//
//  MovieDetailsViewController.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 03/11/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let genresLabel = UILabel()
    private let overviewLabel = UILabel()
    private let ratingLabel = UILabel()
    
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
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        posterImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        
        genresLabel.font = UIFont.systemFont(ofSize: 14)
        
        overviewLabel.font = UIFont.systemFont(ofSize: 14)
        overviewLabel.numberOfLines = 0
        
        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        
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

