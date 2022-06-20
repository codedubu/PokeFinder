//
//  ViewController.swift
//  PokeFinder
//
//  Created by River McCaine on 6/13/22.
//

import UIKit

class PokeSearchVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    
    func configureViewController() {
        title = "PokeDex"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
} // END OF CLASS

