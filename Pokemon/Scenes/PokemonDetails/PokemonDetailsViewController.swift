//
//  PokemonDetailsViewController.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//

import UIKit
import SDWebImage

protocol PokemonDetailsDisplayLogic: AnyObject
{
    func displayPokemonDetails(pokemon: Pokemon?)
}

final class PokemonDetailsViewController: UIViewController, PokemonDetailsDisplayLogic {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var pokemonImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var baseExpLabel: UILabel!
    @IBOutlet weak var abilityLabel: UILabel!
    @IBOutlet weak var abilityLabel2: UILabel!
    @IBOutlet weak var abilityLabel3: UILabel!
    @IBOutlet weak var abilityView: UIView!
    @IBOutlet weak var abilityView2: UIView!
    @IBOutlet weak var abilityView3: UIView!
    
    var pokemon: Pokemon?
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
        let presenter = PokemonDetailsPresenter()
        let router = PokemonDetailsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
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
        interactor?.fetchPokemonDetails()
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
    
    func displayPokemonDetails(pokemon: Pokemon?)
    {
        if let pokemon = pokemon {
            update(pokemon)
        }
    }
}
