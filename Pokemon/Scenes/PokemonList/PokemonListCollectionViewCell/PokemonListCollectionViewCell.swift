//
//  PokemonListTableViewCell.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit
import SDWebImage

class PokemonListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var abilityLabel: UILabel!
    @IBOutlet private weak var abilityView: UIView!
    @IBOutlet private weak var abilityLabel2: UILabel!
    @IBOutlet private weak var abilityView2: UIView!
    @IBOutlet private weak var abilityLabel3: UILabel!
    @IBOutlet private weak var abilityView3: UIView!
    
    private var pokemon: Pokemon?
    private var colors: (UIColor, UIColor)!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pokemonImageView.cornerRadius = pokemonImageView.frame.width / 2
    }
    
}

extension PokemonListCollectionViewCell {
    
    func update(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        colors = pokemon.colors ?? (UIColor(hex: "#48D0B0"), UIColor(hex: "#5EDFC5"))
        self.contentView.backgroundColor = colors.0
        pokemonImageView.backgroundColor = colors.1
        nameLabel.text = pokemon.name?.capitalized
        abilityView.isHidden = true
        abilityView2.isHidden = true
        abilityView3.isHidden = true
        abilityView.backgroundColor = colors.1
        abilityView2.backgroundColor = colors.1
        abilityView3.backgroundColor = colors.1
        
        for abilityInfo in pokemon.abilityList.prefix(3).reversed().enumerated() {
            switch abilityInfo.offset {
            case 0:
                abilityView.isHidden = false
                abilityLabel.text = abilityInfo.element
            case 1:
                abilityView2.isHidden = false
                abilityLabel2.text = abilityInfo.element
            case 2:
                abilityView3.isHidden = false
                abilityLabel3.text = abilityInfo.element
            default:
                break
            }
        }
        
        pokemonImageView.sd_setImage(with: pokemon.profilePicURL)
    }
}
