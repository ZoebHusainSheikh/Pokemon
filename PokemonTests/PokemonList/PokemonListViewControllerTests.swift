//
//  PokemonListViewControllerTests.swift
//  Pokemon
//
//  Created by Zoeb on 04/09/22.
//

@testable import Pokemon
import XCTest

final class PokemonListViewControllerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: PokemonListViewController!
    var window: UIWindow!
    var mockPokemonInfo: PokemonInfo {
        let pokemonInfo = PokemonInfo()
        pokemonInfo.pokemons = mockPokemons
        return pokemonInfo
    }
    var mockPokemons: [Pokemon] {
        let pokemon = Pokemon()
        pokemon.pokemonId = 1
        pokemon.name = "Test1"
        pokemon.url = "https://pokeapi.co"
        pokemon.height = 1
        pokemon.weight = 2
        
        return [pokemon]
    }
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupPokemonListViewController()
    }
    
    override func tearDown()
    {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPokemonListViewController()
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        sut = storyboard.instantiateViewController(withIdentifier: PokemonListViewController.className) as? PokemonListViewController
    
    }
    
    func loadView()
    {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test PokemonListBusinessLogicSpy
    
    final class PokemonListBusinessLogicSpy: PokemonListBusinessLogic
    {
        var fetchPokemonsCalled = false
        var fetchPokemonDetailCalled = false
        
        func fetchPokemons(request: PokemonList.GetPokemons.Request) {
            fetchPokemonsCalled = true
        }
        
        func fetchPokemon(request: PokemonDetail.Fetch.Request) {
            fetchPokemonDetailCalled = true
        }
        
        var pokemon: Pokemon?
    }
    
    // MARK: Tests
    
    func testShouldFetchPokemonsWhenViewIsLoaded()
    {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.fetchPokemonsCalled, "viewDidLoad() should ask the interactor to fetch pokemons")
    }
    
    func testDisplayPokemons()
    {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = PokemonList.GetPokemons.ViewModel(pokemonInfo: mockPokemonInfo)
        
        // When
        loadView()
        sut.displayPokemons(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.pokemons.count, 1, "displayPokemons(viewModel:) should update the pokemons count with 1 pokemon")
    }
    
    func testDisplayPokemonName()
    {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = PokemonList.GetPokemons.ViewModel(pokemonInfo: mockPokemonInfo)
        
        // When
        loadView()
        sut.displayPokemons(viewModel: viewModel)
        guard let pokemon = sut.pokemons.first as Pokemon? else {
            XCTFail("displayPokemons(viewModel:) don't have any pokemon")
            return
        }
        
        // Then
        XCTAssertEqual(pokemon.name, "Test1", "displayPokemons(viewModel:) should have name 'Test1'")
    }
}
