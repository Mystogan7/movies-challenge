//
//  MoviesListViewController.swift
//  iOSMoviesApplicationChallenge
//
//  Created by Mohamed Abdelhamid Mohamed Oshaiba on 02/11/2023.
//

import UIKit

class MoviesListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.rowHeight = 250
        return tableView
    }()
    
    var viewModel: MoviesListViewModelProtocol = MoviesListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchMovies()
    }
    
    func bindViewModel() {
        viewModel.onFetchSuccess = { [weak self] newIndexPaths in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let newIndexPaths = newIndexPaths {
                    self.tableView.insertRows(at: newIndexPaths, with: .fade)
                } else {
                    self.tableView.reloadData()
                }
            }
        }
        
        viewModel.onFetchFailure = { error in
            print("An error occured while fetching the movie list: \(error.localizedDescription)")
        }
    }
        
    private func setupUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MoviesListViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
      if indexPaths.contains(where: { indexPath in
          indexPath.row >= viewModel.currentCount() - 1
      }) {
          viewModel.fetchMovies()
    }
  }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        guard let movie = viewModel.movie(atIndex: indexPath.row) else { return UITableViewCell() }
        cell.configure(with: movie)
        return cell
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

