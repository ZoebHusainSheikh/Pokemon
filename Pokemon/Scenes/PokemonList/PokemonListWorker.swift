//
//  PokemonListWorker.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//


import UIKit

final class PokemonListWorker {
    func fetchPokemons(request: PokemonList.GetPokemons.Request?) async throws -> (success: Bool, response: Any?)? {
        let result = try? await NetworkHttpClient.shared.performAPICall(request?.url, parameters: request?.params)
        return result
    }
    
    func fetchPokemon(request: PokemonDetail.Fetch.Request?) async throws -> (success: Bool, response: Any?)? {
        let result = try? await NetworkHttpClient.shared.performAPICall(request?.url, parameters: request?.params)
        return result
    }
}
