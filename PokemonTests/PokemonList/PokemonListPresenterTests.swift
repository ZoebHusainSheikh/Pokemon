//
//  PokemonListPresenterTests.swift
//  Pokemon
//
//  Created by Zoeb on 04/09/22.
//

@testable import Pokemon
import XCTest

class PokemonListPresenterTests: XCTestCase
{
    class MockPokemonListPresenter: PokemonListPresenter {
        override func presentPokemons(response: PokemonList.GetPokemons.Response) {
            self.viewController?.displayPokemons(viewModel: PokemonList.GetPokemons.ViewModel())
            self.viewController?.stopAnimation()
        }
        
        override func pokemonDetail(response: PokemonDetail.Fetch.Response) {
            self.viewController?.updatePokemon(viewModel: PokemonDetail.Fetch.ViewModel())
        }
    }
    // MARK: Subject under test
    
    var sut: MockPokemonListPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupPokemonListPresenter()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPokemonListPresenter()
    {
        sut = MockPokemonListPresenter()
    }
    
    // MARK: Test doubles
    
    class PokemonListDisplayLogicSpy: PokemonListDisplayLogic
    {
        var displayPokemonsCalled = false
        var updatePokemonsCalled = false
        func displayPokemons(viewModel: PokemonList.GetPokemons.ViewModel) {
            displayPokemonsCalled = true
        }
        
        func updatePokemon(viewModel: PokemonDetail.Fetch.ViewModel) {
            updatePokemonsCalled = true
        }
        
        var stopAnimationCalled = false
        func stopAnimation() {
            stopAnimationCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentPokemons()
    {
        // Given
        let spy = PokemonListDisplayLogicSpy()
        sut.viewController = spy
        let response = PokemonList.GetPokemons.Response(data: nil)
        
        // When
        sut.presentPokemons(response: response)
        
        // Then
        XCTAssertTrue(spy.displayPokemonsCalled, "presentPokemons(response:) should ask the view controller to display the result")
    }
    
    func testUpdatePokemon()
    {
        // Given
        let spy = PokemonListDisplayLogicSpy()
        sut.viewController = spy
        let response = PokemonDetail.Fetch.Response(data: nil)
        
        // When
        sut.pokemonDetail(response: response)
        
        // Then
        XCTAssertTrue(spy.updatePokemonsCalled, "pokemonDetail(response:) should ask the view controller to display the result")
    }
    
    func testStopAnimations()
    {
        // Given
        let spy = PokemonListDisplayLogicSpy()
        sut.viewController = spy
        let response = PokemonList.GetPokemons.Response(data: nil)
        
        // When
        sut.presentPokemons(response: response)
        
        // Then
        XCTAssertTrue(spy.stopAnimationCalled, "presentPokemons(response:) should ask the view controller to stop the animation")
    }
}
