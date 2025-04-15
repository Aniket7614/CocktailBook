//
//  CocktailDetailViewModel.swift
//  CocktailBook
//
//  Created by Aniket Kumar on 15/04/25.
//

import Foundation

final class CocktailDetailViewModel {
    let cocktail: Cocktail
    private let listViewModel: CocktailListViewModel
    
    init(cocktail: Cocktail, listViewModel: CocktailListViewModel) {
        self.cocktail = cocktail
        self.listViewModel = listViewModel
    }
    
    var isFavorite: Bool {
        listViewModel.isFavorite(cocktail)
    }
    
    func toggleFavorite() {
        listViewModel.toggleFavorite(for: cocktail)
    }
}

