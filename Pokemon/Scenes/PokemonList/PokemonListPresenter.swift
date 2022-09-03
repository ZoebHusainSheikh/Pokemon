//
//  PokemonListPresenter.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//


import UIKit

protocol PokemonListPresentationLogic
{
    func presentPokemons(response: PokemonList.GetPokemons.Response)
    func pokemonDetail(response: PokemonDetail.Fetch.Response)
}

class PokemonListPresenter: PokemonListPresentationLogic
{
    weak var viewController: PokemonListDisplayLogic?
    
    // MARK: Mapping
    
    func presentPokemons(response: PokemonList.GetPokemons.Response)
    {
        if let dataResponse = response.data {
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(PokemonInfo.self, from:
                    dataResponse) //Decode JSON Response Data
                
                DispatchQueue.main.async { [weak self] in
                    self?.viewController?.displayPokemons(viewModel: PokemonList.GetPokemons.ViewModel(pokemonInfo: model))
                    self?.viewController?.stopAnimation()
                }
            } catch let parsingError {
                print("Error", parsingError)
                AlertViewController.sharedInstance.alertWindow(message: parsingError.localizedDescription)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.stopAnimation()
            }
        }
    }
    
    func pokemonDetail(response: PokemonDetail.Fetch.Response) {
        if let dataResponse = response.data {
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(Pokemon.self, from:
                    dataResponse) //Decode JSON Response Data
                
                DispatchQueue.main.async { [weak self] in
                    self?.viewController?.updatePokemon(viewModel: PokemonDetail.Fetch.ViewModel(pokemon: model, pokemonURL: response.pokemonURL))
                    self?.viewController?.stopAnimation()
                }
            } catch let parsingError {
                print("Error", parsingError)
                AlertViewController.sharedInstance.alertWindow(message: parsingError.localizedDescription)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.stopAnimation()
            }
        }
    }
}
