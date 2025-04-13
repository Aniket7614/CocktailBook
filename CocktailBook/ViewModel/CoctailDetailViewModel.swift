//
//  CoctailDetailViewModel.swift
//  CocktailBook
//
//  Created by Aniket Kumar on 13/04/25.
//

import Foundation
import Combine

enum CocktailFilter: String, CaseIterable {
    case all = "All Cocktails"
    case alcoholic = "Alcoholic Cocktails"
    case nonAlcoholic = "Non-Alcoholic Cocktails"
}
