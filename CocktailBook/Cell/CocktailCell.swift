//
//  CocktailCell.swift
//  CocktailBook
//
//  Created by Aniket Kumar on 15/04/25.
//

import Foundation
import UIKit

final class CocktailCell: UITableViewCell {
    static let identifier = "CocktailCell"


    private let cocktailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let favoriteIcon = UIImageView(image: UIImage(systemName: "star.fill"))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        cocktailImageView.translatesAutoresizingMaskIntoConstraints = false
        cocktailImageView.contentMode = .scaleAspectFill
        cocktailImageView.clipsToBounds = true
        cocktailImageView.layer.cornerRadius = 8

        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping


        favoriteIcon.translatesAutoresizingMaskIntoConstraints = false
        favoriteIcon.tintColor = .systemYellow
        favoriteIcon.isHidden = true

        contentView.addSubview(cocktailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(favoriteIcon)

        NSLayoutConstraint.activate([
            cocktailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cocktailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cocktailImageView.widthAnchor.constraint(equalToConstant: 60),
            cocktailImageView.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: cocktailImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteIcon.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: favoriteIcon.leadingAnchor, constant: -8),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            favoriteIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 20),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with cocktail: Cocktail, isFavorite: Bool) {
        titleLabel.text = cocktail.name
        subtitleLabel.text = cocktail.shortDescription
        cocktailImageView.image = UIImage(named: cocktail.imageName)
        favoriteIcon.isHidden = !isFavorite
    }
}
