//
//  Cocktail.swift
//  CocktailBook
//
//  Created by Aniket Kumar on 13/04/25.
//

import Foundation

struct Cocktail: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let type: CocktailType
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
    
    var isFavorite: Bool = false
    
    enum CocktailType: String, Codable {
        case alcoholic
        case nonAlcoholic = "non-alcoholic"
    }
}
