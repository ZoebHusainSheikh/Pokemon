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
    
    // MARK: - UI elements
    
    lazy var headerView: UIView = {
       let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var detailsView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()
    
    lazy var pokemonImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    lazy var statsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var typesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        return label
    }()
    
    lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .right
        return label
    }()
    
    lazy var baseExpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
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
    
    lazy var abilityLabel2: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    lazy var abilityLabel3: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    lazy var abilityView: UIView = {
       let view = UIView()
        view.isHidden = true
        view.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var abilityView2: UIView = {
       let view = UIView()
        view.isHidden = true
        view.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    lazy var abilityView3: UIView = {
       let view = UIView()
        view.isHidden = true
        view.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
}

private extension PokemonDetailsViewController {
    
    func initialiseView() {
        self.view.backgroundColor = .white
        setupUI()
        displayPokemonDetails()
    }
    
    func setupUI() {
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        self.view.addSubview(detailsView)
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        detailsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        detailsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        detailsView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: -50).isActive = true
        detailsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.headerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 25).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.headerView.topAnchor, constant: 30).isActive = true
        
        addAbilityView(abilityView: abilityView, abilityLabel: abilityLabel, leadingViewAnchor: self.headerView.leadingAnchor, leadingAnchorValue: 25)
        addAbilityView(abilityView: abilityView2, abilityLabel: abilityLabel2, leadingViewAnchor: abilityView.trailingAnchor)
        addAbilityView(abilityView: abilityView3, abilityLabel: abilityLabel3, leadingViewAnchor: abilityView2.trailingAnchor)
        
        
        self.view.addSubview(pokemonImageView)
        pokemonImageView.topAnchor.constraint(equalTo: self.abilityView.bottomAnchor, constant: 50).isActive = true
        pokemonImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pokemonImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        let size: CGFloat = 200
        pokemonImageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        pokemonImageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        
        self.detailsView.addSubview(weightLabel)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.leadingAnchor.constraint(equalTo: self.detailsView.leadingAnchor, constant: 25).isActive = true
        weightLabel.trailingAnchor.constraint(equalTo: self.detailsView.trailingAnchor, constant: 25).isActive = true
        weightLabel.topAnchor.constraint(equalTo: self.detailsView.topAnchor, constant: 50).isActive = true
        
        self.detailsView.addSubview(heightLabel)
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.trailingAnchor.constraint(equalTo: self.detailsView.trailingAnchor, constant: -25).isActive = true
        heightLabel.topAnchor.constraint(equalTo: self.detailsView.topAnchor, constant: 50).isActive = true
        
        self.detailsView.addSubview(statsLabel)
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.leadingAnchor.constraint(equalTo: self.detailsView.leadingAnchor, constant: 25).isActive = true
        statsLabel.trailingAnchor.constraint(equalTo: self.detailsView.trailingAnchor, constant: 25).isActive = true
        statsLabel.topAnchor.constraint(equalTo: self.heightLabel.bottomAnchor, constant: 20).isActive = true
        
        self.detailsView.addSubview(typesLabel)
        typesLabel.translatesAutoresizingMaskIntoConstraints = false
        typesLabel.leadingAnchor.constraint(equalTo: self.detailsView.leadingAnchor, constant: 25).isActive = true
        typesLabel.trailingAnchor.constraint(equalTo: self.detailsView.trailingAnchor, constant: 25).isActive = true
        typesLabel.topAnchor.constraint(equalTo: self.statsLabel.bottomAnchor, constant: 20).isActive = true
        
        self.detailsView.addSubview(baseExpLabel)
        baseExpLabel.translatesAutoresizingMaskIntoConstraints = false
        baseExpLabel.leadingAnchor.constraint(equalTo: self.detailsView.leadingAnchor, constant: 25).isActive = true
        baseExpLabel.trailingAnchor.constraint(equalTo: self.detailsView.trailingAnchor, constant: 25).isActive = true
        baseExpLabel.topAnchor.constraint(equalTo: self.typesLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    func addAbilityView(abilityView: UIView, abilityLabel: UILabel, leadingViewAnchor: NSLayoutXAxisAnchor, leadingAnchorValue: CGFloat = 10) {
        self.headerView.addSubview(abilityView)
        abilityView.translatesAutoresizingMaskIntoConstraints = false
        abilityView.leadingAnchor.constraint(equalTo: leadingViewAnchor, constant: leadingAnchorValue).isActive = true
        abilityView.trailingAnchor.constraint(greaterThanOrEqualTo: self.view.leadingAnchor, constant: leadingAnchorValue).isActive = true
        abilityView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15).isActive = true
        abilityView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        abilityView.addSubview(abilityLabel)
        abilityLabel.translatesAutoresizingMaskIntoConstraints = false
        abilityLabel.leadingAnchor.constraint(equalTo: abilityView.leadingAnchor, constant: 10).isActive = true
        abilityLabel.trailingAnchor.constraint(equalTo: abilityView.trailingAnchor, constant: -10).isActive = true
        abilityLabel.centerYAnchor.constraint(equalTo: abilityView.centerYAnchor).isActive = true
    }
    
    // MARK: - Update UI
    func update(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        headerView.backgroundColor = pokemon.bgColors?.0
        nameLabel.text = pokemon.name?.capitalized
//        statsLabel.attributedText = NSMutableAttributedString().bold("Stats: ").normal(pokemon.statCSV.capitalized)
//        typesLabel.attributedText = NSMutableAttributedString().bold("Types: ").normal(pokemon.typeCSV.capitalized)
//        weightLabel.attributedText = NSMutableAttributedString().bold("Weight: ").normal("\(pokemon.weight ?? 0)")
//        heightLabel.attributedText = NSMutableAttributedString().bold("Height: ").normal("\(pokemon.height ?? 0)")
//        baseExpLabel.attributedText = NSMutableAttributedString().bold("Base Experience: ").normal("\(pokemon.baseExperience ?? 0)")
        
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
