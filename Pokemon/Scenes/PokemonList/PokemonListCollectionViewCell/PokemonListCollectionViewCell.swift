//
//  PokemonListTableViewCell.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit

class PokemonListCollectionViewCell: UICollectionViewCell {
    private var pokemon: Pokemon?
    private var colors: (UIColor, UIColor)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.cornerRadius = 10
        self.contentView.clipsToBounds = true
        self.contentView.addSubview(pokemonImageView)
        pokemonImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        pokemonImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5).isActive = true
        let size = self.contentView.frame.width / 2
        pokemonImageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        pokemonImageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        
        self.contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
        
        addAbilityView(abilityView: abilityView, abilityLabel: abilityLabel, topView: nameLabel, trailingAnchorValue: self.contentView.frame.width / 2)
        addAbilityView(abilityView: abilityView2, abilityLabel: abilityLabel2, topView: abilityView)
        addAbilityView(abilityView: abilityView3, abilityLabel: abilityLabel3, topView: abilityView2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI elements
    
    lazy var pokemonImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.cornerRadius = self.contentView.frame.width / 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textAlignment = .left
        return label
    }()
    
    lazy var abilityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    lazy var abilityView: UIView = {
       let view = UIView()
        view.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var abilityLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    lazy var abilityView2: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        view.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var abilityLabel3: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    lazy var abilityView3: UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        view.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
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
        
        DispatchQueue.global().async {
            if let imageURL = pokemon.profilePicURL, let itemNumber = self.pokemon?.pokemonId {
                self.pokemonImageView.setImage(url: imageURL, itemNumber: NSNumber(value: itemNumber))
            }
        }
    }
}

private extension PokemonListCollectionViewCell {
    
    func addAbilityView(abilityView: UIView, abilityLabel: UILabel, topView: UIView, trailingAnchorValue: CGFloat = -5) {
        self.contentView.addSubview(abilityView)
        abilityView.translatesAutoresizingMaskIntoConstraints = false
        abilityView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        abilityView.trailingAnchor.constraint(lessThanOrEqualTo: pokemonImageView.leadingAnchor, constant: trailingAnchorValue).isActive = true
        abilityView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10).isActive = true
        abilityView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        abilityView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        abilityView.addSubview(abilityLabel)
        abilityLabel.translatesAutoresizingMaskIntoConstraints = false
        abilityLabel.leadingAnchor.constraint(equalTo: abilityView.leadingAnchor, constant: 10).isActive = true
        abilityLabel.trailingAnchor.constraint(equalTo: abilityView.trailingAnchor, constant: -10).isActive = true
        abilityLabel.centerYAnchor.constraint(equalTo: abilityView.centerYAnchor).isActive = true
    }
}
