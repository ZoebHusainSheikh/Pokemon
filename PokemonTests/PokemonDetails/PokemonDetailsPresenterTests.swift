//
//  PokemonDetailsPresenterTests.swift
//  Pokemon
//
//  Created by Zoeb on 05/09/22.
//

@testable import Pokemon
import XCTest

final class PokemonDetailsPresenterTests: XCTestCase {
    var mockPokemon: Pokemon {
        let pokemon = Pokemon()
        pokemon.pokemonId = 1
        pokemon.name = "Test1"
        return pokemon
    }
    
    final class MockPokemonDetailsPresenter: PokemonDetailsPresenter {
        var mockPokemon: Pokemon {
            let pokemon = Pokemon()
            pokemon.pokemonId = 1
            pokemon.name = "Test1"
            return pokemon
        }
        
        override func presentPokemonDetails(pokemon: Pokemon?) {
            self.viewController?.displayPokemonDetails(pokemon: mockPokemon)
        }
    }
    
    // MARK: Subject under test
    
    var sut: MockPokemonDetailsPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupPokemonDetailsPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPokemonDetailsPresenter() {
        sut = MockPokemonDetailsPresenter()
    }
    
    // MARK: Test doubles
    
    final class PokemonDetailsDisplayLogicSpy: PokemonDetailsDisplayLogic {
        var displayPokemonsCalled = false
        
        func displayPokemonDetails(pokemon: Pokemon?) {
            displayPokemonsCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentPokemonDetails() {
        // Given
        let spy = PokemonDetailsDisplayLogicSpy()
        sut.viewController = spy
        
        // When
        sut.presentPokemonDetails(pokemon: mockPokemon)
        
        // Then
        XCTAssertTrue(spy.displayPokemonsCalled, "presentPokemonDetails(pokemon:) should ask the view controller to display the pokemon details")
    }
}
