//
//  PFTabBarController.swift
//  PokeFinder
//
//  Created by River McCaine on 6/13/22.
//

import UIKit

class PFTabBarController: UITabBarController {

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().barTintColor = .systemBackground

        self.viewControllers = [createPokeListNC(), createFavoritesNC()]
    }


    // MARK: - Helper Methods
    func createPokeListNC() -> UINavigationController {
        let pokeListVC = PokeListVC()
        
        pokeListVC.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "list.bullet"), tag: 0)

        return UINavigationController(rootViewController: pokeListVC)
    }
    
    
    func createPokeSearch() -> UINavigationController {
        let pokeStoryboard  = UIStoryboard(name: "PokeSearchVC", bundle: nil)
        let pokeSearchVC    = pokeStoryboard.instantiateViewController(withIdentifier: "PokeSearchVC")
        
        pokeSearchVC.tabBarItem = UITabBarItem(title: "PokeDex", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        
        return UINavigationController(rootViewController: pokeSearchVC)
    }
    
    
    func createFavoritesNC() -> UINavigationController {
        let pokeFavoritesListVC         = PokeFavoritesVC()
        
        pokeFavoritesListVC.title       = "Favorites"
        pokeFavoritesListVC.tabBarItem  = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        return UINavigationController(rootViewController: pokeFavoritesListVC)
    }
} // END OF CLASS
