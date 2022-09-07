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
        pokemonInfo.next = "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20"
        return pokemonInfo
    }
    var mockPokemons: [Pokemon] {
        var pokemons = [Pokemon]()
        
        for index in (1..<5) {
            let pokemon = Pokemon()
            pokemon.pokemonId = index
            pokemon.name = "Test\(index)"
            pokemon.url = "https://pokeapi.co"
            pokemon.height = 1
            pokemon.weight = 2
            pokemons.append(pokemon)
        }
        
        return pokemons
    }
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupPokemonListViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPokemonListViewController() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        sut = storyboard.instantiateViewController(withIdentifier: PokemonListViewController.className) as? PokemonListViewController
    
    }
    
    func loadView() {
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
    
    func testShouldFetchPokemonsWhenViewIsLoaded() {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.fetchPokemonsCalled, "viewDidLoad() should ask the interactor to fetch pokemons")
    }
    
    func testDisplayPokemons() {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = PokemonList.GetPokemons.ViewModel(pokemonInfo: mockPokemonInfo)
        
        // When
        loadView()
        sut.displayPokemons(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.pokemons.count, 4, "displayPokemons(viewModel:) should update the pokemons count to 4")
    }
    
    func testDisplayPokemonName() {
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
    
    func testPerformSearch() {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = PokemonList.GetPokemons.ViewModel(pokemonInfo: mockPokemonInfo)
        
        // When
        loadView()
        
        //set searchbar text
        sut.searchBar.text = "Test2"
        sut.displayPokemons(viewModel: viewModel)
        
        
        // Then
        XCTAssertEqual(sut.filteredPokemons.first?.name, "Test2", "displayPokemons(viewModel:) should update the pokemons count with 1 pokemon")
    }
    
    func testPerformSearchCount() {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = PokemonList.GetPokemons.ViewModel(pokemonInfo: mockPokemonInfo)
        
        // When
        loadView()
        
        //set searchbar text
        sut.searchBar.text = "Test4"
        sut.displayPokemons(viewModel: viewModel)
        
        
        // Then
        XCTAssertEqual(sut.filteredPokemons.count, 1, "displayPokemons(viewModel:) should update the filteredPokemons's count with 1 pokemon")
    }
    
    func testPerformSort() {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = PokemonList.GetPokemons.ViewModel(pokemonInfo: mockPokemonInfo)
        
        // When
        loadView()
        sut.selectedSorting = .nameDesc
        sut.displayPokemons(viewModel: viewModel)
        
        // Then
        XCTAssertEqual(sut.filteredPokemons.first?.name, "Test4", "displayPokemons(viewModel:) should update the pokemons count with 1 pokemon")
    }
    
    func testFetchNextPokemons() {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        let viewModel = PokemonList.GetPokemons.ViewModel(pokemonInfo: mockPokemonInfo)
        
        // When
        loadView()
        sut.displayPokemons(viewModel: viewModel)
        spy.fetchPokemonsCalled = false
        
        sut.fetchNextPokemons()
        
        // Then
        XCTAssertTrue(spy.fetchPokemonsCalled, "fetchNextPokemons() should ask the interactor to fetch pokemons")
    }
    
    func testEmptyFetchNextPokemons() {
        // Given
        let spy = PokemonListBusinessLogicSpy()
        sut.interactor = spy
        let mockPokemonInfo = PokemonInfo()
        let viewModel = PokemonList.GetPokemons.ViewModel(pokemonInfo: mockPokemonInfo)
        
        // When
        loadView()
        sut.displayPokemons(viewModel: viewModel)
        spy.fetchPokemonsCalled = false
        
        sut.fetchNextPokemons()
        
        // Then
        XCTAssertFalse(spy.fetchPokemonsCalled, "fetchNextPokemons() should not ask the interactor to fetch pokemons")
    }
}
