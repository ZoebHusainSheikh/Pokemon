//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit
import SDWebImage

class PokemonDetailsViewController: UIViewController
{
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var detailsView: UIView!
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statsLabel: UILabel!
    @IBOutlet private weak var typesLabel: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var baseExpLabel: UILabel!
    @IBOutlet private weak var abilityLabel: UILabel!
    @IBOutlet private weak var abilityLabel2: UILabel!
    @IBOutlet private weak var abilityLabel3: UILabel!
    @IBOutlet private weak var abilityView: UIView!
    @IBOutlet private weak var abilityView2: UIView!
    @IBOutlet private weak var abilityView3: UIView!
    
    private var pokemon: Pokemon?
    var interactor: PokemonDetailsBusinessLogic?
    var router: (NSObjectProtocol & PokemonDetailsDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = PokemonDetailsInteractor()
        let router = PokemonDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        initialiseView()
    }
}

private extension PokemonDetailsViewController {
    
    func initialiseView() {
        self.view.backgroundColor = .white
        displayPokemonDetails()
    }
    
    // MARK: - Update UI
    func update(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        headerView.backgroundColor = pokemon.bgColors?.0
        nameLabel.text = pokemon.name?.capitalized
        statsLabel.attributedText = NSMutableAttributedString().bold("Stats: ").normal(pokemon.statCSV.capitalized)
        typesLabel.attributedText = NSMutableAttributedString().bold("Types: ").normal(pokemon.typeCSV.capitalized)
        weightLabel.attributedText = NSMutableAttributedString().bold("Weight: ").normal("\(pokemon.weight ?? 0)")
        heightLabel.attributedText = NSMutableAttributedString().bold("Height: ").normal("\(pokemon.height ?? 0)")
        baseExpLabel.attributedText = NSMutableAttributedString().bold("Base Experience: ").normal("\(pokemon.baseExperience ?? 0)")
        
        let colors = pokemon.colors ?? (UIColor(hex: "#48D0B0"), UIColor(hex: "#5EDFC5"))
        abilityView.backgroundColor = colors.1
        abilityView2.backgroundColor = colors.1
        abilityView3.backgroundColor = colors.1
        
        for abilityInfo in pokemon.abilityList.prefix(3).reversed().enumerated() {
            switch abilityInfo.offset {
            case 0:
                abilityView.isHidden = false
                abilityLabel.text = abilityInfo.element.capitalized
            case 1:
                abilityView2.isHidden = false
                abilityLabel2.text = abilityInfo.element.capitalized
            case 2:
                abilityView3.isHidden = false
                abilityLabel3.text = abilityInfo.element.capitalized
            default:
                break
            }
        }
        pokemonImageView.sd_setImage(with: pokemon.profilePicURL)
    }
}

extension PokemonDetailsViewController {
    
    // MARK: PokemonDetails Display Logic
    
    func displayPokemonDetails()
    {
        if let pokemon = interactor?.pokemon {
            update(pokemon)
        }
    }
}
