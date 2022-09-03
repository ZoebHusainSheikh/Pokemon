//
//  PokemonDetailsInteractor.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit

protocol PokemonDetailsBusinessLogic
{
    var pokemon: Pokemon? { get set }
}

protocol PokemonDetailsDataStore
{
    var pokemon: Pokemon? { get set }
}

class PokemonDetailsInteractor: PokemonDetailsBusinessLogic, PokemonDetailsDataStore
{
    var pokemon: Pokemon?
}
