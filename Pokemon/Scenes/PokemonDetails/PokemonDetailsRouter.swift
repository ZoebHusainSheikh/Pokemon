//
//  PokemonDetailsRouter.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit

protocol PokemonDetailsDataPassing
{
  var dataStore: PokemonDetailsDataStore? { get }
}

class PokemonDetailsRouter: NSObject, PokemonDetailsDataPassing
{
  weak var viewController: PokemonDetailsViewController?
  var dataStore: PokemonDetailsDataStore?
}
