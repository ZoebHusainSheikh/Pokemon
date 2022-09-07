//
//  PokemonDetailsInteractor.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit

protocol PokemonDetailsBusinessLogic {
    func fetchPokemonDetails()
}

protocol PokemonDetailsDataStore {
    var pokemon: Pokemon? { get set }
}

class PokemonDetailsInteractor: PokemonDetailsBusinessLogic, PokemonDetailsDataStore {
    var pokemon: Pokemon?
    
    var presenter: PokemonDetailsPresentationLogic?
    
    func fetchPokemonDetails() {
        self.presenter?.presentPokemonDetails(pokemon: pokemon)
    }
}
