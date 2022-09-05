//
//  PokemonDetailsPresenter.swift
//  Pokemon
//
//  Created by Zoeb on 05/09/22.
//

import Foundation

protocol PokemonDetailsPresentationLogic
{
    func presentPokemonDetails(pokemon: Pokemon?)
}

class PokemonDetailsPresenter: PokemonDetailsPresentationLogic
{
    weak var viewController: PokemonDetailsDisplayLogic?
    
    // MARK: Mapping
    
    func presentPokemonDetails(pokemon: Pokemon?) {
        self.viewController?.displayPokemonDetails(pokemon: pokemon)
    }
}
