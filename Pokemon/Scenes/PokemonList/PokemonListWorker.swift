//
//  PokemonListWorker.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//


import UIKit

class PokemonListWorker
{
    func fetchPokemons(request: PokemonList.GetPokemons.Request?, _ onCompletion: @escaping CompletionHandler) {
        
        NetworkHttpClient.shared.performAPICall(request?.url, parameters: request?.params, success: { (dataResponse) in
            onCompletion(true, dataResponse)
        }) { (error) in
            print(error as Any)
            onCompletion(false, error)
        }
    }
    
    func fetchPokemon(request: PokemonDetail.Fetch.Request?, _ onCompletion: @escaping CompletionHandler) {
        
        NetworkHttpClient.shared.performAPICall(request?.url, parameters: request?.params, success: { (dataResponse) in
            onCompletion(true, dataResponse)
        }) { (error) in
            print(error as Any)
            onCompletion(false, error)
        }
    }
}
