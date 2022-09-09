//
//  PokemonListInteractor.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//


import UIKit

protocol PokemonListBusinessLogic {
    func fetchPokemons(request: PokemonList.GetPokemons.Request)
    func fetchPokemon(request: PokemonDetail.Fetch.Request)
    var pokemon: Pokemon? { get set }
}

protocol PokemonListDataStore {
    var pokemon: Pokemon? { get set }
}

class PokemonListInteractor: PokemonListBusinessLogic, PokemonListDataStore {
    var pokemon: Pokemon?
    
    var presenter: PokemonListPresentationLogic?
    var worker = PokemonListWorker()
    
    // MARK: Fetch Pokemons from API
    
    func fetchPokemons(request: PokemonList.GetPokemons.Request) {
        Task {
            if let (_, apiResponse) = try await worker.fetchPokemons(request: request) {
                let response = PokemonList.GetPokemons.Response(data: apiResponse as? Data)
                self.presenter?.presentPokemons(response: response)
            }
        }
        
    }
    
    func fetchPokemon(request: PokemonDetail.Fetch.Request) {
        Task {
            if let (_, apiResponse) = try await worker.fetchPokemon(request: request) {
                let response = PokemonDetail.Fetch.Response(data: apiResponse as? Data, pokemonURL: request.url)
                self.presenter?.pokemonDetail(response: response)
            }
        }
    }
}
