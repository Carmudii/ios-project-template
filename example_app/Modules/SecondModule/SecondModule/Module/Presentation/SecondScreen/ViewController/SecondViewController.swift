//
//  SecondViewController.swift
//  SecondModule
//
//  Created by Car mudi on 12/03/24.
//

import UIKit
import Swinject
import AppCoreModule

final class SecondViewController: BaseViewController, SecondPresentableScreen {

    typealias ViewModel = AnyViewModel<SecondViewModel.State, SecondViewModel.Event>

    // MARK: - Private components

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This ViewController is from Second Module"
        label.textColor = .black

        return label
    }()

    private lazy var firstButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go Back", for: .normal)
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
        bindViewModel()
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

    private func bindViewModel() {
        viewModel.bindStateDidChange { [weak self] state in
            switch state {
            case .goBack:
                self?.resolver.receive(SecondNavigationService.self).back()

            case .navigateToThird:
                self?.navigateToThirdScreen()
            }
        }
    }

    private func navigateToThirdScreen() {
        let navigation = resolver.receive() as SecondNavigationService
        let secondScreen = resolver.receive() as ThirdPresentableScreen
        navigation.app.pushViewController(secondScreen.viewController(), animated: true)
    }

    // MARK: - Actions

    @objc
    private func didTapFirstButton(_ sender: UIButton) {
        switch sender {
        case firstButton:
            viewModel.onReceiveEvent(.goBack)
        case secondButton:
            viewModel.onReceiveEvent(.navigateToThird)
        default:
            break
        }
    }
}
