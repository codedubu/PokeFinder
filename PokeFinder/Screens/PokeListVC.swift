//
//  PokeListVC.swift
//  PokeFinder
//
//  Created by River McCaine on 6/13/22.
//

import UIKit

class PokeListVC: UIViewController {
    
    enum Section { case main }
        
    var pokemon: [Pokemon]      = []
    var hasMorePokemon          = true
    var isLoadingMorePokemon    = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Pokemon>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureCollectionView()
        getPokemon()
        configureDatSource()

    }
    
    
    func getPokemon() {
        if isLoadingMorePokemon {
            print("OOPS YOU TRIED TO LOAD TOO SOON")
            return
        }
        isLoadingMorePokemon = true
        
        Task {
            do {
                let pokemon = try await NetworkManager.shared.getAllPokemon()
                updateUI(with: pokemon)
                isLoadingMorePokemon = false
                
            } catch {
                if let pokeError = error as? PokeError {
                    print(pokeError.localizedDescription)
                }
                isLoadingMorePokemon = false
            }
        }
    }
    
    
    func updateUI(with pokemon: [Pokemon]) {
        if pokemon.count < NetworkManager.pokemonPerPage { self.hasMorePokemon = false }
        
        self.pokemon.append(contentsOf: pokemon)
        
        self.updateData(on: self.pokemon)
    }
    
    
    func configureVC() {
        title                   = "Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .systemBackground
        view.backgroundColor = .systemBackground
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.reuseID)
    }
    
    
    func configureDatSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Pokemon>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, pokemon) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.reuseID, for: indexPath) as! PokemonCell
            
            cell.set(pokemon: pokemon)
            
            return cell
        })
    }
    
    
    func updateData(on pokemon: [Pokemon]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>()
        snapshot.appendSections([.main])
        snapshot.appendItems(pokemon)
        
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
} // END OF CLASS


// MARK: - Extensions
extension PokeListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if  (contentHeight - (1.8 * height) < offsetY) {
            
            guard hasMorePokemon, !isLoadingMorePokemon else { return }
            
            getPokemon()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        let selectedPokemon     = pokemon[indexPath.item]
        guard let snapshotPokemon = dataSource.itemIdentifier(for: indexPath) else { return }
//        let pokemonCell = collectionView.cellForItem(at: indexPath) as! PokemonCell
//        let selecetedPokemon = pokemonCell.pokemon
        
        
        let pokeStoryboard  = UIStoryboard(name: "PokeDetailVC", bundle: nil)
        let pokeDetailVC    = pokeStoryboard.instantiateViewController(withIdentifier: "PokeDetailVC") as? PokeDetailVC
        
        guard let pokeDetailVC = pokeDetailVC, let navController = self.navigationController else { return }
        
        pokeDetailVC.pokemon   = snapshotPokemon
        
        navController.pushViewController(pokeDetailVC, animated: true)
    }
} // END OF EXTENSION


