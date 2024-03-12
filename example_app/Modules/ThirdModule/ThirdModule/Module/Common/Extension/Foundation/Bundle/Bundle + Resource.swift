//
//  Bundle + Resource.swift
//  ThirdModule
//
//  Created by Car mudi on 20/06/23.
//

import Foundation

extension Bundle {

    public var resource: Bundle {
        // static framework
        if let resourceURL = resourceURL,
           let resourceBundle = Bundle(url: resourceURL.appendingPathComponent(ModuleName.name + ".bundle")) {
            return resourceBundle
        } else {
            // dynamic framework
            return self
        }
    }
}

fileprivate struct ModuleName {
    static var name: String = {
        String(reflecting: ModuleName.self).components(separatedBy: ".").first ?? ""
    }()
}
