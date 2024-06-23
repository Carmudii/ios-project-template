//
//  UIViewController+Swizzling.swift
//  AppCar
//
//  Created by Car mudi on 16/06/24.
//

import UIKit

extension UIViewController {

    static let swizzleViewDidDisappearImplementation: Void = {
        guard
            let originalViewDidDisappear = class_getInstanceMethod(UIViewController.self, #selector(viewDidDisappear(_:))),
            let swizzledViewDidDisappear = class_getInstanceMethod(UIViewController.self, #selector(swizzled_viewDidDisappear(_:)))
        else {
            return
        }

        method_exchangeImplementations(originalViewDidDisappear, swizzledViewDidDisappear)

        guard
            let originalViewDidLoad = class_getInstanceMethod(UIViewController.self, #selector(viewDidLoad)),
            let swizzledViewDidLoad = class_getInstanceMethod(UIViewController.self, #selector(swizzled_viewDidLoad))
        else {
            return
        }

        method_exchangeImplementations(originalViewDidLoad, swizzledViewDidLoad)

        let deallocSelector = sel_registerName("dealloc")
        guard
            let originalDealloc = class_getInstanceMethod(UIViewController.self, deallocSelector),
            let swizzledDealloc = class_getInstanceMethod(UIViewController.self, #selector(swizzled_deinit))
        else {
            return
        }

        method_exchangeImplementations(originalDealloc, swizzledDealloc)
    }()

    @objc func swizzled_viewDidDisappear(_ animated: Bool) {
        let name = NSStringFromClass(type(of: self))
        print("INFO: \(name) did disappear.")
    }

    @objc func swizzled_viewDidLoad() {
        MemoryLeakTracker.shared.track(self)
        MemoryLeakTracker.shared.checkForLeaks()
    }

    @objc func swizzled_deinit() {
        MemoryLeakTracker.shared.untrack(self)
    }
}

fileprivate class MemoryLeakTracker {

    public static let shared = MemoryLeakTracker()
    private var classReferences = [String: Int]()
    private let queue = DispatchQueue(label: "com.app.memoryLeakTracker")

    func track(_ object: AnyObject) {
        queue.sync {
            let name = NSStringFromClass(type(of: object))
            classReferences[name, default: 0] += 1
            print("INFO: Tracking object \(name)")
        }
    }

    func untrack(_ object: AnyObject) {
        queue.sync {
            let name = NSStringFromClass(type(of: object))
            if let count = classReferences[name], count > 1 {
                classReferences[name] = count - 1
            } else {
                classReferences.removeValue(forKey: name)
            }
            print("INFO: Untracking object \(name)")
        }
    }

    func checkForLeaks() {
        queue.sync {
            for (name, count) in classReferences where count > 1 {
                print("WARNING: \(name) has \(count) instances that were not deallocated properly.")
            }
        }
    }
}
