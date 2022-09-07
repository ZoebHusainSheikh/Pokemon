//
//  PokemonDetailsInteractorTests.swift
//  Pokemon
//
//  Created by Zoeb on 05/09/22.
//

@testable import Pokemon
import XCTest

final class PokemonDetailsInteractorTests: XCTestCase {
    final class MockPokemonDetailsInteractor: PokemonDetailsInteractor {
        var mockPokemon: Pokemon {
            let pokemon = Pokemon()
            pokemon.pokemonId = 1
            pokemon.name = "Test1"
            return pokemon
        }
        
        override func fetchPokemonDetails() {
            self.presenter?.presentPokemonDetails(pokemon: mockPokemon)
        }
    }
    
    // MARK: Subject under test
    
    var sut: MockPokemonDetailsInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupPokemonDetailsInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPokemonDetailsInteractor() {
        sut = MockPokemonDetailsInteractor()
    }
    
    // MARK: Test doubles
    
    final class PokemonDetailsPresentationLogicSpy: PokemonDetailsPresentationLogic {
        var presentPokemonsCalled = false
        
        func presentPokemonDetails(pokemon: Pokemon?) {
            presentPokemonsCalled = true
        }
    }
    
    // MARK: Tests
    
    func testFetchPokemonDetails() {
        // Given
        let spy = PokemonDetailsPresentationLogicSpy()
        sut.presenter = spy
        
        // When
        sut.fetchPokemonDetails()
        
        // Then
        XCTAssertTrue(spy.presentPokemonsCalled, "fetchPokemonDetails() should ask the presenter to present pokemon details")
    }
}
