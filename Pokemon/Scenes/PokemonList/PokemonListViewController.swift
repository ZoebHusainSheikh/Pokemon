//
//  PokemonListViewController.swift
//  Pokemon
//
//  Created by Zoeb on 03/09/22.
//


import UIKit

protocol PokemonListDisplayLogic: AnyObject
{
    func displayPokemons(viewModel: PokemonList.GetPokemons.ViewModel)
    func updatePokemon(viewModel: PokemonDetail.Fetch.ViewModel)
    func stopAnimation()
}

final class PokemonListViewController: UIViewController, PokemonListDisplayLogic
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pokemons = [Pokemon]()
    private var pokemonInfo = PokemonInfo()
    private var filteredPokemons = [Pokemon]()
    private var selectedSorting: SortPokemon = .none
    private lazy var cellSize = (self.view.frame.width - 30) / 2
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    // cell reuse id (cells that scroll out of view can be reused)
    private let cellReuseIdentifier = PokemonListCollectionViewCell.className
    var interactor: PokemonListBusinessLogic?
    private var router: (NSObjectProtocol & PokemonListRoutingLogic & PokemonListDataPassing)?
    
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
        let interactor = PokemonListInteractor()
        let presenter = PokemonListPresenter()
        let router = PokemonListRouter()
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

private extension PokemonListViewController {
    enum Constants {
        static let imageName: String = "PokemonBG"
        static let rowHeight: CGFloat = 65
        static let pokemonBaseURL = "https://pokeapi.co/api/v2/pokemon/"
    }
    
    enum SortPokemon {
        case none
        case nameAsc
        case nameDesc
    }
    
    func initialiseView() {
        navigationItem.titleView = searchBar
        setupBarButtonItem()
        setupCollectionView()
        fetchPokemons()
    }
    
    func setupBarButtonItem() {
        // Instead of Sort button as a text, I use image in V2
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "sortIcon"), style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        collectionView.collectionViewLayout = layout
    }
    
    // MARK: Fetch Pokemons
    
    func fetchPokemons(url: String = Constants.pokemonBaseURL) {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        let request = PokemonList.GetPokemons.Request(url: url)
        interactor?.fetchPokemons(request: request)
    }
    
    func fetchPokemonDetails(_ pokemon: Pokemon) {
        guard pokemon.pokemonId == nil else { return }
        if let url = pokemon.url {
            let request = PokemonDetail.Fetch.Request(url: url)
            interactor?.fetchPokemon(request: request)
        }
    }
    
    func fetchNextPokemons() {
        guard let nextPokemonsURL = pokemonInfo.next else {
            return
        }
        
        fetchPokemons(url: nextPokemonsURL)
    }
    
    @objc func sortButtonTapped() {
        sortActionSheet()
    }
    
    func sortActionSheet() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Sort Pokemons by: ", message: "", preferredStyle: .actionSheet)
            let nameAscAction = UIAlertAction(title: "Name - Ascending", style: .default, handler: { action in
                self.selectedSorting = .nameAsc
                self.reloadData()
            })
            let nameDescAction = UIAlertAction(title: "Name - Descending", style: .default, handler: { action in
                self.selectedSorting = .nameDesc
                self.reloadData()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(nameAscAction)
            alertController.addAction(nameDescAction)
            alertController.addAction(cancelAction)
            let alertWindow = UIApplication.shared.keyWindow
            alertWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func performSort(_ sort: SortPokemon) {
        switch sort {
        case .nameAsc:
            self.filteredPokemons.sort(by: { $0.name ?? String.empty < $1.name ?? String.empty })
        case .nameDesc:
            self.filteredPokemons.sort(by: { $0.name ?? String.empty > $1.name ?? String.empty })
        case .none:
            break
        }
    }
    
    func performSearch() {
        guard let searchText = searchBar.text, !searchText.trim.isEmpty else {
            self.filteredPokemons = pokemons
            return
        }
        
        // Search by Pokemon's name
        let filterPokemons = self.pokemons.filter {
            ($0.name?.lowercased().contains(searchText.lowercased()) ?? false)
        }
        
        // Search by Pokemon's Ability
        let pokemonsAbilities = self.pokemons.filter {
            let data = $0.abilities?.filter {
                ($0.ability?.name?.lowercased().contains(searchText.lowercased()) ?? false)
            }
            return data?.isEmpty == false
        }
        
        // Combine Pokemons to make unique list
        self.filteredPokemons = Array(Set(filterPokemons + pokemonsAbilities))
    }
    
    func reloadData() {
        performSearch()
        performSort(selectedSorting)
        self.collectionView.reloadData()
    }
}

extension PokemonListViewController {
    
    // MARK: PokemonList Display Logic
    
    func displayPokemons(viewModel: PokemonList.GetPokemons.ViewModel) {
        if let pokemonInfo = viewModel.pokemonInfo, let pokemons = pokemonInfo.pokemons {
            self.pokemonInfo = pokemonInfo
            self.pokemons.append(contentsOf: pokemons)
        }
        self.collectionView.isHidden = false
        self.reloadData()
    }
    
    func updatePokemon(viewModel: PokemonDetail.Fetch.ViewModel) {
        if let pokemonDetails = viewModel.pokemon, let url = viewModel.pokemonURL {
            pokemonDetails.url = viewModel.pokemonURL
            let selectedPokemons = self.pokemons.filter {
                $0.url == url
            }
            if let pokemon = selectedPokemons.first {
                if let index = self.pokemons.firstIndex(of: pokemon) {
                    self.pokemons[index] = pokemonDetails
                    if let item = self.filteredPokemons.firstIndex(of: pokemon) {
                        self.filteredPokemons[item] = pokemonDetails
                        self.collectionView.reloadItems(at: [IndexPath(item: item, section: 0)])
                    }
                }
            }
        }
    }
    
    func stopAnimation() {
        self.activityIndicator.stopAnimating()
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? PokemonListCollectionViewCell else { return UICollectionViewCell() }
        if filteredPokemons.count > indexPath.row {
            let pokemon = filteredPokemons[indexPath.row]
            fetchPokemonDetails(pokemon)
            cell.update(pokemon)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = filteredPokemons[indexPath.row]
        interactor?.pokemon = selectedPokemon
        router?.routeToPokemonDetails()
    }
}

extension PokemonListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData()
    }
}

extension PokemonListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom <= height {
            // Reached to last cell, now we can perform for new pokemons
            fetchNextPokemons()
        }
    }
}
