//
//  ViewController.swift
//  __TEMPLATE__
//
//  Created by Car mudi on 12/03/24.
//

import UIKit
import Swinject
import SecondModule

class ViewController: UIViewController {

    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("WELCOME TO __TEMPLATE__ APP", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        return button
    }()

    private let resolver: Resolver

    init(resolver: Resolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 46)
        ])
    }

    @objc
    private func buttonTapped() {
        // TODO: - Add your navigation logic here
        // let secondScreen = resolver.receive(SecondModuleNavigationService.self)
        // secondScreen?.openSecondScreen()
    }
}

