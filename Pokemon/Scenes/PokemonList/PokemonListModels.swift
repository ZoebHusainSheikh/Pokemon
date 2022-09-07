//
//  PokemonListModels.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//


import UIKit

enum PokemonList
{
    // MARK: Use cases
    
    enum GetPokemons
    {
        struct Request
        {
            let url: String
            var params : Dictionary<String, Any>?
        }
        struct Response
        {
            let data: Data?
        }
        struct ViewModel
        {
            var pokemonInfo: PokemonInfo?
        }
    }
}

enum PokemonDetail
{
    // MARK: Use cases
    
    enum Fetch
    {
        struct Request
        {
            var url: String
            var params : Dictionary<String, Any>?
        }
        struct Response
        {
            let data: Data?
            var pokemonURL: String?
        }
        struct ViewModel
        {
            var pokemon: Pokemon?
            var pokemonURL: String?
        }
    }
}

final class Pokemon: NSObject, Codable {
    var pokemonId: Int?
    var name: String?
    var url: String?
    var abilities: [AbilityInfo]?
    var weight: Int?
    var height: Int?
    var baseExperience: Int?
    var sprites: SpritesInfo?
    var stats: [StatInfo]?
    var types: [TypeInfo]?
    
    var bgColors: (UIColor, UIColor)?
}

extension Pokemon {
    enum CodingKeys: String, CodingKey {
        case pokemonId = "id"
        case name = "name"
        case url = "url"
        case abilities = "abilities"
        case weight = "weight"
        case height = "height"
        case baseExperience = "base_experience"
        case sprites = "sprites"
        case stats = "stats"
        case types = "types"
    }
}

extension Pokemon {
    
    var abilitiesCSV: String {
        guard let abilities = abilities else { return "-" }
        var csv: String = String.empty
        for abilityInfo in abilities {
            if let name = abilityInfo.ability?.name {
                if csv.isEmpty == false {
                    csv += ", "
                }
                csv += name
            }
        }
        return csv
    }
    
    var abilityList: [String] {
        guard let abilities = abilities else { return [] }
        var names: [String] = []
        for abilityInfo in abilities {
            if let name = abilityInfo.ability?.name {
                names.append(name)
            }
        }
        return names
    }
    
    var statCSV: String {
        guard let stats = stats else { return "-" }
        var csv: String = String.empty
        for statInfo in stats {
            if let name = statInfo.stat?.name {
                if csv.isEmpty == false {
                    csv += ", "
                }
                csv += name
            }
        }
        return csv
    }
    
    var typeCSV: String {
        guard let types = types else { return "-" }
        var csv: String = String.empty
        for typeInfo in types {
            if let name = typeInfo.type?.name {
                if csv.isEmpty == false {
                    csv += ", "
                }
                csv += name
            }
        }
        return csv
    }
    
    var colors: (UIColor, UIColor)? {
        if self.bgColors == nil {
            self.bgColors = Pokemon.colorOptions.randomElement()
        }
        
        return self.bgColors
    }
    
    static var colorOptions: [(UIColor, UIColor)] = {
        var colorOptionList = [(UIColor, UIColor)]()
        colorOptionList.append((UIColor(hex: "#48D0B0"), UIColor(hex: "#5EDFC5")))
        colorOptionList.append((UIColor(hex: "#F76362"), UIColor(hex: "#FA8585")))
        colorOptionList.append((UIColor(hex: "#76BDFE"), UIColor(hex: "#8FD0FE")))
        colorOptionList.append((UIColor(hex: "#FED86F"), UIColor(hex: "#FBE17C")))
        return colorOptionList
    }()
    
    var profilePicURL: URL? {
        
        guard let imagePath = sprites?.other?.officialArtwork?.frontDefault ?? sprites?.frontDefault else {
            return nil
        }
        
        return URL(string: imagePath)
    }
}

final class PokemonInfo: NSObject, Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var pokemons: [Pokemon]?
}

extension PokemonInfo {
    enum CodingKeys: String, CodingKey {
        case count = "count"
        case next = "next"
        case previous = "previous"
        case pokemons = "results"
    }
}

final class AbilityInfo: NSObject, Codable {
    var ability: Ability?
}

extension AbilityInfo {
    enum CodingKeys: String, CodingKey {
        case ability = "ability"
    }
}

final class Ability: NSObject, Codable {
    var name: String?
    var url: String?
}

extension Ability {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

final class TypeInfo: NSObject, Codable {
    var type: TypeData?
}

extension TypeInfo {
    enum CodingKeys: String, CodingKey {
        case type = "type"
    }
}

final class TypeData: NSObject, Codable {
    var name: String?
    var url: String?
}

extension TypeData {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

final class StatInfo: NSObject, Codable {
    var stat: Stat?
}

extension StatInfo {
    enum CodingKeys: String, CodingKey {
        case stat = "stat"
    }
}

final class Stat: NSObject, Codable {
    var name: String?
    var url: String?
}

extension Stat {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

final class SpritesInfo: NSObject, Codable {
    var other: OtherInfo?
    var frontDefault: String?
}

extension SpritesInfo {
    enum CodingKeys: String, CodingKey {
        case other = "other"
        case frontDefault = "front_default"
    }
}

final class OtherInfo: NSObject, Codable {
    var officialArtwork: OfficialArtwork?
}

extension OtherInfo {
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

final class OfficialArtwork: NSObject, Codable {
    var frontDefault: String?
}

extension OfficialArtwork {
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
