//
//  PokemonListCollectionViewCell.swift
//  PokemonTests
//
//  Created by Zoeb on 06/09/22.
//

@testable import Pokemon
import XCTest
import Foundation

class PokemonListCollectionViewCellTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: PokemonListViewController!
    var window: UIWindow!
    var mockPokemon: Pokemon {
        let pokemon = Pokemon()
        pokemon.pokemonId = 1
        pokemon.name = "Test1"
        pokemon.bgColors = (UIColor(hex: "#48D0B0"), UIColor(hex: "#5EDFC5"))
        var abilities = [AbilityInfo]()
        let abilityInfo = AbilityInfo()
        let ability = Ability()
        ability.name = "Strong"
        abilityInfo.ability = ability
        abilities.append(abilityInfo)
        pokemon.abilities = abilities
        
        return pokemon
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
    
    func testCollectionViewCellName() {
        // Given
        let pokemon = mockPokemon
        
        // When
        loadView()
        
        guard let cell: PokemonListCollectionViewCell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? PokemonListCollectionViewCell else {
            XCTFail("cell is not PokemonListCollectionViewCell")
            return
        }
        
        cell.update(pokemon)
        
        // Then
        XCTAssertEqual(cell.nameLabel.text, "Test1", "update(_ pokemon:) should set the pokemon name in nameLabel's text")
    }
    
    func testCollectionViewCellAbilityView() {
        // Given
        let pokemon = mockPokemon
        
        // When
        loadView()
        
        guard let cell: PokemonListCollectionViewCell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? PokemonListCollectionViewCell else {
            XCTFail("cell is not PokemonListCollectionViewCell")
            return
        }
        
        cell.update(pokemon)
        
        // Then
        
        XCTAssertTrue(cell.abilityView.isHidden == false, "update(_ pokemon:) should show abilityView")
    }
    
    func testCollectionViewCellAbilityViewHidden() {
        // Given
        let pokemon = mockPokemon
        
        // When
        loadView()
        
        guard let cell: PokemonListCollectionViewCell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? PokemonListCollectionViewCell else {
            XCTFail("cell is not PokemonListCollectionViewCell")
            return
        }
        
        cell.update(pokemon)
        
        // Then
        
        XCTAssertTrue(cell.abilityView2.isHidden, "update(_ pokemon:) should hide abilityView")
    }
    
    func testAbilityLabelText() {
        // Given
        let pokemon = mockPokemon
        
        // When
        loadView()
        
        guard let cell: PokemonListCollectionViewCell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? PokemonListCollectionViewCell else {
            XCTFail("cell is not PokemonListCollectionViewCell")
            return
        }
        
        cell.update(pokemon)
        
        // Then
        
        XCTAssertEqual(cell.abilityLabel.text, "Strong", "update(_ pokemon:) should have ability label text 'Strong'")
    }
    
    func testCellBackgroundColor() {
        // Given
        let pokemon = mockPokemon
        
        // When
        loadView()
        
        guard let cell: PokemonListCollectionViewCell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? PokemonListCollectionViewCell else {
            XCTFail("cell is not PokemonListCollectionViewCell")
            return
        }
        
        cell.update(pokemon)
        
        // Then
        
        XCTAssertEqual(cell.contentView.backgroundColor, UIColor(hex: "#48D0B0"), "update(_ pokemon:) should set background color to '#48D0B0'")
    }
    
    func testAbilityViewBackgroundColor() {
        // Given
        let pokemon = mockPokemon
        
        // When
        loadView()
        
        guard let cell: PokemonListCollectionViewCell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? PokemonListCollectionViewCell else {
            XCTFail("cell is not PokemonListCollectionViewCell")
            return
        }
        
        cell.update(pokemon)
        
        // Then
        
        XCTAssertEqual(cell.abilityView.backgroundColor, UIColor(hex: "#5EDFC5"), "update(_ pokemon:) should set background color to '#5EDFC5'")
    }
}
