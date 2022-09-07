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
        worker.fetchPokemons(request: request, { (status, apiResponse) in
            
            let response = PokemonList.GetPokemons.Response(data: apiResponse as? Data)
            self.presenter?.presentPokemons(response: response)
        })
        
    }
    
    func fetchPokemon(request: PokemonDetail.Fetch.Request) {
        worker.fetchPokemon(request: request, { (status, apiResponse) in
            
            let response = PokemonDetail.Fetch.Response(data: apiResponse as? Data, pokemonURL: request.url)
            self.presenter?.pokemonDetail(response: response)
        })
    }
}
