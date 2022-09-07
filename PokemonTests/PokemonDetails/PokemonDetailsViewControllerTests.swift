//
//  PokemonDetailsViewControllerTests.swift
//  Pokemon
//
//  Created by Zoeb on 05/09/22.
//

@testable import Pokemon
import XCTest

final class PokemonDetailsViewControllerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: PokemonDetailsViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupPokemonDetailsViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupPokemonDetailsViewController() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        sut = storyboard.instantiateViewController(withIdentifier: PokemonDetailsViewController.className) as? PokemonDetailsViewController
    
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test PokemonDetailsBusinessLogicSpy
    
    final class PokemonDetailsBusinessLogicSpy: PokemonDetailsBusinessLogic {
        var fetchPokemonDetailCalled = false
        func fetchPokemonDetails() {
            fetchPokemonDetailCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldFetchPokemonWhenViewIsLoaded() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        // Then
        XCTAssertTrue(spy.fetchPokemonDetailCalled, "viewDidLoad() should ask the interactor to fetch pokemon")
    }
    
    func testDisplayPokemon() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertNotNil(sut.pokemon, "displayPokemonDetails(pokemon:) should initialise the optional pokemon with value")
    }
    
    func testDisplayPokemonName() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.pokemon?.name, "Test1", "displayPokemonDetails(pokemon::) should have name 'Test1'")
    }
    
    func testDisplayPokemonWeight() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.pokemon?.weight, 1, "displayPokemonDetails(pokemon::) should have weight value 1")
    }
    
    func testDisplayPokemonHeight() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.pokemon?.height, 2, "displayPokemonDetails(pokemon::) should have height value 2")
    }
    
    func testDisplayPokemonBasenceExperience() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.pokemon?.baseExperience, 10, "displayPokemonDetails(pokemon::) should have baseExperience value 10")
    }
    
    func testDisplayPokemonURL() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.pokemon?.url, "https://pokeapi.co", "displayPokemonDetails(pokemon::) should have url value 'www.apple.com'")
    }
    
    func testNameLabel() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.nameLabel.text, "Test1", "displayPokemonDetails(pokemon:) should set the pokemon name in nameLabel's text")
    }
    
    func testWeightLabelValue() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.weightLabel.attributedText?.string, "Weight: 1", "displayPokemonDetails(pokemon:) should set the pokemon wieght in weightLabel's text")
    }
    
    func testHeightLabelValue() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.heightLabel.attributedText?.string, "Height: 2", "displayPokemonDetails(pokemon:) should set the pokemon height in heightLabel's text")
    }
    
    func testStatsLabelValue() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.statsLabel.attributedText?.string, "Stats: Stat 0, Stat 1", "displayPokemonDetails(pokemon:) should set the pokemon stats in statsLabel's text")
    }
    
    func testTypesLabelValue() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.typesLabel.attributedText?.string, "Types: Type 0, Type 1", "displayPokemonDetails(pokemon:) should set the pokemon types in typesLabel's text")
    }
    
    func testBaseExpLabelValue() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.baseExpLabel.text, "Base Experience: 10", "displayPokemonDetails(pokemon:) should set the pokemon base experience in baseExpLabel's text")
    }
    
    func testAbilityViewHiddenStatus() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertTrue(sut.abilityView.isHidden == false, "displayPokemonDetails(pokemon:) should show abilityView")
    }
    
    func testAbilityViewHidden() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertTrue(sut.abilityView2.isHidden, "displayPokemonDetails(pokemon:) should hide abilityView")
    }
    
    func testAbilityLabelText() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.abilityLabel.text, "Strong", "displayPokemonDetails(pokemon:) should have ability label text 'Strong'")
    }
    
    func testAbilityLabelTextWhenNil() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.abilityLabel2.text, "", "displayPokemonDetails(pokemon:) should have 'NIL' ability label text")
    }
    
    func testHeaderViewBackgroundColor() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.headerView.backgroundColor, UIColor(hex: "#48D0B0"), "displayPokemonDetails(pokemon:) should set background color to '#48D0B0'")
    }
    
    func testAbilityViewBackgroundColor() {
        // Given
        let spy = PokemonDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        loadView()
        sut.displayPokemonDetails(pokemon: mockPokemon)
        // Then
        XCTAssertEqual(sut.abilityView.backgroundColor, UIColor(hex: "#5EDFC5"), "displayPokemonDetails(pokemon:) should set background color to '#5EDFC5'")
    }
}

extension PokemonDetailsViewControllerTests {
    var mockPokemon: Pokemon {
        let pokemon = Pokemon()
        pokemon.pokemonId = 1
        pokemon.name = "Test1"
        pokemon.bgColors = (UIColor(hex: "#48D0B0"), UIColor(hex: "#5EDFC5"))
        pokemon.url = "https://pokeapi.co"
        pokemon.weight = 1
        pokemon.height = 2
        pokemon.baseExperience = 10
        var abilities = [AbilityInfo]()
        let abilityInfo = AbilityInfo()
        let ability = Ability()
        ability.name = "Strong"
        abilityInfo.ability = ability
        abilities.append(abilityInfo)
        pokemon.abilities = abilities
        
        pokemon.stats = [StatInfo]()
        
        pokemon.types = [TypeInfo]()
        
        for index in (0..<2) {
            
            let statInfo = StatInfo()
            
            let stat = Stat()
            stat.name = "Stat \(index)"
            statInfo.stat = stat
            
            pokemon.stats?.append(statInfo)
            
            let typeInfo = TypeInfo()
            
            let type = TypeData()
            type.name = "Type \(index)"
            typeInfo.type = type
            
            pokemon.types?.append(typeInfo)
        }
        
        return pokemon
    }
}
