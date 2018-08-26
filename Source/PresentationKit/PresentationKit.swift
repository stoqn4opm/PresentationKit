//
//  PresentationKit.swift
//  Testbr
//
//  Created by Stoyan Stoyanov on 25.08.18.
//  Copyright © 2018 Stoyan Stoyanov. All rights reserved.
//

import UIKit

// MARK: - Public Interface

extension UIViewController {
    
    /// Presents a view controller modally as if presented from another view controller, but here a new window is created with root view controller that presents the current view controller. On `dismiss(animated:, completion:)` on this instance the newly created window is destroyed and last used window becomes the `keyWindow` of the app again.
    ///
    /// - Parameters:
    ///   - animated: Pass true to animate the presentation; otherwise, pass false.
    ///   - completion: The completion handler, if provided, will be invoked after the presented controllers viewDidAppear: callback is invoked.
    public func present(animated: Bool, completion: (() -> Void)?) {
        let newWindow = UIWindow.new
        newWindow.makeKeyAndVisible()
        let options = RootViewController.PresentationOptions(viewController: self, animated: animated, completion: completion)
        (newWindow.rootViewController as? RootViewController)?.presentationOptions = options
    }
}

// MARK: - Presentation Options

extension RootViewController {
    struct PresentationOptions {
        let viewController: UIViewController
        let animated:       Bool
        let completion:    (() -> Void)?
    }
}

// MARK: - RootViewController Class Definition

class RootViewController: UIViewController {
    
    /// Someone needs to hold a strong reference to the new window so its here
    fileprivate var windowReference: UIWindow?
    private var hasPresentedViewController = false
    fileprivate var presentationOptions: RootViewController.PresentationOptions?
}

// MARK: - RootViewController Overrides

extension RootViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard hasPresentedViewController else { return }
        windowReference?.resignKey()
        windowReference = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if hasPresentedViewController {
            windowReference?.resignKey()
            windowReference = nil
        } else {
            guard let options = presentationOptions else { return }
            present(options.viewController, animated: options.animated, completion: options.completion)
        }
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        hasPresentedViewController = presentedViewController != nil
    }
}

// MARK: - Helper Methods

extension UIWindow {
    
    static fileprivate var new: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = RootViewController(nibName: nil, bundle: nil)
        rootViewController.windowReference = window
        window.rootViewController = rootViewController
        return window
    }
}
