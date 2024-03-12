//
//  HomeViewController.swift
//  AppCar
//
//  Created by Car mudi on 12/03/24.
//

import UIKit
import Swinject
import AppCoreModule
import SecondModule
import ThirdModule

class HomeViewController: BaseViewController {

    typealias ViewModel = AnyViewModel<HomeViewModel.State, HomeViewModel.Event>

    // MARK: - Private components

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, World!"
        label.textColor = .black

        return label
    }()

    private lazy var firstButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open Second Screen", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(didTapFirstButton(_:)), for: .touchUpInside)

        return button
    }()

    private lazy var secondButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open Third Screen", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(didTapFirstButton(_:)), for: .touchUpInside)

        return button
    }()

    // MARK: - Private properties

    private let resolver: Resolver
    private let viewModel: ViewModel

    // MARK: - Initializers

    init(resolver: Resolver, viewModel: ViewModel) {
        self.resolver = resolver
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureUI()
    }

    // MARK: - Private methods

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubviews(label, firstButton, secondButton)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // Label
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 50),

            // First Button
            firstButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            firstButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstButton.widthAnchor.constraint(equalToConstant: 200),
            firstButton.heightAnchor.constraint(equalToConstant: 50),

            // Second Button
            secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: 10),
            secondButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            secondButton.widthAnchor.constraint(equalToConstant: 200),
            secondButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func openSceondScreen() {
        let navigation = resolver.receive() as SecondNavigationService
        navigation.openSecondScreen()
    }

    private func openThirdScreen() {
        let navigation = resolver.receive() as ThirdNavigationService
        navigation.openThirdScreen()
    }

    // MARK: - Actions

    @objc
    private func didTapFirstButton(_ sender: UIButton) {
        switch sender {
            case firstButton:
            openSceondScreen()

            case secondButton:
            openThirdScreen()
            
        default:
            break
        }
    }
}
