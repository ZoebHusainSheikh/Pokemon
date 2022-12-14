//
//  PokemonListRouter.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//


import UIKit

@objc protocol PokemonListRoutingLogic {
    func routeToPokemonDetails()
}

protocol PokemonListDataPassing {
    var dataStore: PokemonListDataStore? { get }
}

final class PokemonListRouter: NSObject, PokemonListRoutingLogic, PokemonListDataPassing {
    weak var viewController: PokemonListViewController?
    var dataStore: PokemonListDataStore?
    
    // MARK: Routing
    
    func routeToPokemonDetails() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC: PokemonDetailsViewController = storyboard.instantiateViewController(withIdentifier: PokemonDetailsViewController.className) as! PokemonDetailsViewController
        var destinationDS = destinationVC.router!.dataStore!
        passDataToPokemonDetails(source: dataStore!, destination: &destinationDS)
        navigateToPokemonDetails(source: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToPokemonDetails(source: PokemonListViewController, destination: PokemonDetailsViewController) {
        source.present(destination, animated: true, completion: nil)
    }
    
    // MARK: Passing data
    
    func passDataToPokemonDetails(source: PokemonListDataStore, destination: inout PokemonDetailsDataStore) {
        destination.pokemon = source.pokemon
    }
}
