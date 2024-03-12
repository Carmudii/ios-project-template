//
//  BaseUIView.swift
//  __MODULE_PREFIX__
//
//  Created by Car mudi on 04/04/23.
//

import UIKit

open class BaseUIView: UIView {

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        viewDidLoad()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        viewDidLoad()
    }

    // MARK: - Public Methods

    open func viewDidLoad() {
    }

}
