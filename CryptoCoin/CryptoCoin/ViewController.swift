//
//  ViewController.swift
//  CryptoCoin
//
//  Created by Suresh M on 26/11/24.
//

import UIKit

class ViewController: UIViewController {

    let viewModel = ViewModel()
    
    override func loadView() {
        super.loadView()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Coin"
    }


}

