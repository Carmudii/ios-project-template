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
import AVFoundation

class HomeViewController: BaseViewController {

    typealias ViewModel = AnyViewModel<HomeViewModel.State, HomeViewModel.Event>

    // MARK: - Private components

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, World!"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)

        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, World!"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)

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

    private lazy var openPIPButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open PiP", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(didTapFirstButton(_:)), for: .touchUpInside)

        return button
    }()

    private let pipView: PictureInPictureView = {
        let view = PictureInPictureView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .yellow

        return view
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
        view.addSubviews(pipView, label, firstButton, secondButton, openPIPButton)

        pipView.addSubview(label2)

        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: pipView.topAnchor),
            label2.centerXAnchor.constraint(equalTo: pipView.centerXAnchor),
            label2.heightAnchor.constraint(equalToConstant: 50),
        ])

        NSLayoutConstraint.activate([
            // PIPView
            pipView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pipView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pipView.widthAnchor.constraint(equalToConstant: 200),
            pipView.heightAnchor.constraint(equalToConstant: 300),

            // Label
            label.topAnchor.constraint(equalTo: pipView.bottomAnchor, constant: 10),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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

            // OpenPIPButton
            openPIPButton.topAnchor.constraint(equalTo: secondButton.bottomAnchor, constant: 10),
            openPIPButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openPIPButton.widthAnchor.constraint(equalToConstant: 200),
            openPIPButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func bindViewModel() {
        viewModel.bindStateDidChange { [weak self] state in
            switch state {
            case .navigateToSecond:
                self?.openSceondScreen()

            case .navigateToThird:
                self?.openThirdScreen()

            case .enterPipMode:
                self?.enterPipMode()

            case .updateTimer(let date):
                self?.label.text = date
                self?.label2.text = date
            }
        }
    }

    private func openSceondScreen() {
        let navigation = resolver.receive() as SecondNavigationService
        navigation.openSecondScreen()
    }

    private func openThirdScreen() {
        let navigation = resolver.receive() as ThirdNavigationService
        navigation.openThirdScreen()
    }

    private func enterPipMode() {
        pipView.togglePictureInPictureMode()
    }

    // MARK: - Actions

    @objc
    private func didTapFirstButton(_ sender: UIButton) {
        switch sender {
        case firstButton:
            viewModel.onReceiveEvent(.navigateToSecond)

        case secondButton:
            viewModel.onReceiveEvent(.navigateToThird)

        case openPIPButton:
            viewModel.onReceiveEvent(.enterPipMode)

        default:
            break
        }
    }
}
