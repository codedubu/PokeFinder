//
//  PokeFavoritesVC.swift
//  PokeFinder
//
//  Created by River McCaine on 6/13/22.
//

import UIKit

class PokeFavoritesVC: UIViewController {
    
    let tableView               = UITableView()
    var favorites: [Pokemon]    = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFavorites()
    }
    
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case.success(let favorites):
                DispatchQueue.main.async {
                    self.updateUI(with: favorites)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func updateUI(with favorites: [Pokemon]) {
        if favorites.isEmpty {
            print("it's empty")
        } else {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func configureVC() {
        title                   = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
} // END OF CLASS


// MARK: - Extensions
extension PokeFavoritesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell        = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        let favorite    = favorites[indexPath.row]
        cell.set(favorite: favorite)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        
        let pokeStoryboard  = UIStoryboard(name: "PokeDetailVC", bundle: nil)
        let pokeDetailVC    = pokeStoryboard.instantiateViewController(withIdentifier: "PokeDetailVC") as? PokeDetailVC
        
        guard let pokeDetailVC = pokeDetailVC, let navController = self.navigationController else { return }
        
        pokeDetailVC.pokemon   = favorite
        
        navController.pushViewController(pokeDetailVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                return
            }
            
            print(error.localizedDescription)
        }
    }
} // END OF EXTENSION
