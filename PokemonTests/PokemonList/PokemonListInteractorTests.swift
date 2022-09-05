//
//  PokemonListInteractorTests.swift
//  Pokemon
//
//  Created by Zoeb on 04/09/22.
//

@testable import Pokemon
import XCTest

class PokemonListInteractorTests: XCTestCase
{
    class MockPokemonListInteractor: PokemonListInteractor {
        override func fetchPokemons(request: PokemonList.GetPokemons.Request) {
            let response = PokemonList.GetPokemons.Response(data: nil)
            self.presenter?.presentPokemons(response: response)
        }
        
        override func fetchPokemon(request: PokemonDetail.Fetch.Request) {
            let response = PokemonDetail.Fetch.Response(data: nil, pokemonURL: nil)
            self.presenter?.pokemonDetail(response: response)
        }
    }
    
    // MARK: Subject under test
    
    var sut: MockPokemonListInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupPokemonListInteractor()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPokemonListInteractor()
    {
        sut = MockPokemonListInteractor()
    }
    
    // MARK: Test doubles
    
    class PokemonListPresentationLogicSpy: PokemonListPresentationLogic
    {
        var presentPokemonsCalled = false
        var pokemonDetailCalled = false
        
        func presentPokemons(response: PokemonList.GetPokemons.Response) {
            presentPokemonsCalled = true
        }
        
        func pokemonDetail(response: PokemonDetail.Fetch.Response) {
            pokemonDetailCalled = true
        }
    }
    
    // MARK: Tests
    
    func testFetchPokemon()
    {
        // Given
        let spy = PokemonListPresentationLogicSpy()
        sut.presenter = spy
        let request = PokemonList.GetPokemons.Request(url: String.empty)
        
        // When
        sut.fetchPokemons(request: request)
        
        // Then
        XCTAssertTrue(spy.presentPokemonsCalled, "fetchPokemons(request:) should ask the presenter to format the result")
    }
    
    func testPokemonDetail()
    {
        // Given
        let spy = PokemonListPresentationLogicSpy()
        sut.presenter = spy
        let request = PokemonDetail.Fetch.Request(url: String.empty)
        
        // When
        sut.fetchPokemon(request: request)
        
        // Then
        XCTAssertTrue(spy.pokemonDetailCalled, "fetchPokemon(request:) should ask the presenter to display pokemon details")
    }
}
