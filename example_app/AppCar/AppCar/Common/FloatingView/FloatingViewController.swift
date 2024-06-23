//
//  FloatingViewController.swift
//  AppCar
//
//  Created by Car mudi on 21/06/24.
//

import UIKit

final class FloatingViewController: UIViewController {

    // MARK: - Private properties

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Yey we presented from a FloatingView"
        label.textColor = .black

        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor

        return button
    }()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }

    // MARK: - Private methods

    private func configureUI() {
        view.addSubviews(closeButton, label)

        NSLayoutConstraint.activate([
            // CloseButton
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            // HelloWorldLabel
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func bindUI() {
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc
    private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}
