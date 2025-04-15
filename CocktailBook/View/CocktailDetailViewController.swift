//
//  CocktailDetailViewController.swift
//  CocktailBook
//
//  Created by Aniket Kumar on 15/04/25.
//

import Foundation
import UIKit

final class CocktailDetailViewController: UIViewController {
    private let viewModel: CocktailDetailViewModel

    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let ingredientsLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    init(viewModel: CocktailDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateFavoriteIcon()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.cocktail.name

        imageView.image = UIImage(named: viewModel.cocktail.imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        descriptionLabel.text = viewModel.cocktail.longDescription
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        ingredientsLabel.text = "Ingredients -\n\n" + viewModel.cocktail.ingredients.joined(separator: "\n")
        ingredientsLabel.numberOfLines = 0
        ingredientsLabel.font = .boldSystemFont(ofSize: 14)
        ingredientsLabel.textColor = .gray
        ingredientsLabel.translatesAutoresizingMaskIntoConstraints = false

        favoriteButton.setTitle("★ Favorite", for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        [imageView, descriptionLabel, ingredientsLabel, favoriteButton].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            ingredientsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            ingredientsLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            ingredientsLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),

            favoriteButton.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 20),
            favoriteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func updateFavoriteIcon() {
        let title = viewModel.isFavorite ? "★ Favorited" : "☆ Mark as Favorite"
        favoriteButton.setTitle(title, for: .normal)
    }

    @objc private func toggleFavorite() {
        viewModel.toggleFavorite()
        updateFavoriteIcon()
    }
}
