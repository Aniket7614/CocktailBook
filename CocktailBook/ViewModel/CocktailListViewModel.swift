//
//  CocktailListViewModel.swift
//  CocktailBook
//
//  Created by Aniket Kumar on 15/04/25.
//

import Foundation
import Combine

enum CocktailFilter: String, CaseIterable {
    case all = "All"
    case alcoholic = "Alcoholic"
    case nonAlcoholic = "Non-Alcoholic"
}

final class CocktailListViewModel {
    @Published private(set) var cocktails: [Cocktail] = []
    @Published var filter: CocktailFilter = .all
    @Published var errorMessage: String?
    
    private var allCocktails: [Cocktail] = []
    private var cancellables = Set<AnyCancellable>()
    private let api: CocktailsAPI
    private let favoritesKey = "favoriteCocktailIDs"
    
    private(set) var favoriteCocktailIDs: Set<String> = []
    
    init(api: CocktailsAPI = FakeCocktailsAPI()) {
        self.api = api
        loadFavorites()
        fetchCocktails()
        setupBindings()
    }
    
    private func setupBindings() {
        $filter
            .sink { [weak self] _ in
                self?.applyFilter()
            }
            .store(in: &cancellables)
    }
    
    private func fetchCocktails() {
        api.fetchCocktails { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let cocktails = try decoder.decode([Cocktail].self, from: data)
                        self?.allCocktails = cocktails
                        self?.applyFilter()
                    } catch {
                        self?.errorMessage = "Failed to decode cocktails."
                    }
                case .failure:
                    self?.errorMessage = "Unable to retrieve cocktails, API unavailable."
                }
            }
        }
    }
    
    private func applyFilter() {
        var filtered = allCocktails
        switch filter {
        case .alcoholic:
            filtered = filtered.filter { $0.isAlcoholic }
        case .nonAlcoholic:
            filtered = filtered.filter { !$0.isAlcoholic }
        case .all:
            break
        }
        
        // Sort alphabetically
        filtered.sort { $0.name < $1.name }
        
        // Separate favorites
        let favorites = filtered.filter { favoriteCocktailIDs.contains($0.id) }
        let others = filtered.filter { !favoriteCocktailIDs.contains($0.id) }
        
        cocktails = favorites + others
    }
    
    func toggleFavorite(for cocktail: Cocktail) {
        if favoriteCocktailIDs.contains(cocktail.id) {
            favoriteCocktailIDs.remove(cocktail.id)
        } else {
            favoriteCocktailIDs.insert(cocktail.id)
        }
        saveFavorites()
        applyFilter()
    }
    
    func isFavorite(_ cocktail: Cocktail) -> Bool {
        favoriteCocktailIDs.contains(cocktail.id)
    }
    
    private func loadFavorites() {
        if let saved = UserDefaults.standard.array(forKey: favoritesKey) as? [String] {
            favoriteCocktailIDs = Set(saved)
        }
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteCocktailIDs), forKey: favoritesKey)
    }
}

