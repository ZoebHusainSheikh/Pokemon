//
//  PokemonDetailsViewControllerTests.swift
//  Pokemon
//
//  Created by Zoeb on 05/09/22.
//

@testable import Pokemon
import XCTest

class PokemonDetailsViewControllerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: PokemonDetailsViewController!
    var window: UIWindow!
    var mockPokemon: Pokemon {
        let pokemon = Pokemon()
        pokemon.pokemonId = 1
        pokemon.name = "Test1"
        pokemon.url = "https://pokeapi.co"
        pokemon.height = 1
        pokemon.weight = 2
        pokemon.baseExperience = 10
        pokemon.sprites = SpritesInfo()
        pokemon.abilities = [AbilityInfo]()
        pokemon.stats = [StatInfo]()
        pokemon.types = [TypeInfo]()
        
        return pokemon
    }
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupPokemonDetailsViewController()
    }
    
    override func tearDown()
    {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPokemonDetailsViewController()
    {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        sut = storyboard.instantiateViewController(withIdentifier: PokemonDetailsViewController.className) as? PokemonDetailsViewController
    
    }
    
    func loadView()
    {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test PokemonDetailsBusinessLogicSpy
    
    class PokemonDetailsBusinessLogicSpy: PokemonDetailsBusinessLogic
    {
        var fetchPokemonDetailCalled = false
        
        func fetchPokemonDetails() {
            fetchPokemonDetailCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldFetchPokemonWhenViewIsLoaded()
    {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.fetchPokemonDetailCalled, "viewDidLoad() should ask the interactor to fetch pokemon")
    }
    
    func testDisplayPokemon()
    {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        
        // Then
        XCTAssertNotNil(sut.pokemon, "displayPokemonDetails(pokemon:) should initialise the optional pokemon with value")
    }
    
    func testDisplayPokemonName()
    {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        
        // Then
        XCTAssertEqual(sut.pokemon?.name, "Test1", "displayPokemonDetails(pokemon::) should have name 'Test1'")
        XCTAssertEqual(sut.pokemon?.height, 1, "displayPokemonDetails(pokemon::) should have height value 1")
        XCTAssertEqual(sut.pokemon?.weight, 2, "displayPokemonDetails(pokemon::) should have weight value 2")
        XCTAssertEqual(sut.pokemon?.baseExperience, 10, "displayPokemonDetails(pokemon::) should have baseExperience value 10")
    }
}
