//
//  Cocktail.swift
//  CocktailBook
//
//  Created by Aniket Kumar on 15/04/25.
//

import Foundation

struct Cocktail: Decodable, Identifiable {
    let id: String
    let name: String
    let type: String
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]

    var isAlcoholic: Bool {
        type == "alcoholic"
    }
}

