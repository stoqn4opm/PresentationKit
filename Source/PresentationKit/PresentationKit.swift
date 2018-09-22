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
        checkForAlertController()
        let newWindow = UIWindow.new
        newWindow.makeKeyAndVisible()
        let options = RootViewController.PresentationOptions(viewController: self, animated: animated, completion: completion)
        (newWindow.rootViewController as? RootViewController)?.presentationOptions = options
    }
    
    /// Checking whether someone is trying to present alert controller which does not have only `PAlertAction`s. Even if only one action is not of class `PAlertAction`, the execution is stopped fatalError is reached
    private func checkForAlertController() {
        guard self is UIAlertController else { return }
        let countOfUnappropriateAlerts = (self as? UIAlertController)?.actions.filter({ !($0 is PAlertAction) }).count
        assert(countOfUnappropriateAlerts == 0, "When presenting UIAlertController from PresentationKit, YOU HAVE TO USE UIAlertAction.AlertAction(title:, style:, handler:) so that the internally created window can be dismissed properly when executing the action handlers")
        guard countOfUnappropriateAlerts != 0 else { return }
        fatalError("If you are using UIAlertController with PresentationKit, you have to add PAlertActions to it instead of UIAlertActions. Get the right action with UIAlertAction.AlertAction(title:, style:, handler:)")
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
        dismissWindow()
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

// MARK - Destroying Windows

extension RootViewController {
    
    func dismissWindow() {
        guard hasPresentedViewController else { return }
        windowReference?.resignKey()
        windowReference = nil
        presentationOptions = nil
    }
}

// MARK: - Helper Methods

extension Int {
    
    /// Tag used for distinguishing PresentationKit's window from all windows of the app.
    static fileprivate var newWindowTag: Int { return 0xdeadBeef }
}

extension UIWindow {
    
    static fileprivate var new: UIWindow {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = RootViewController(nibName: nil, bundle: nil)
        rootViewController.windowReference = window
        window.rootViewController = rootViewController
        window.tag = .newWindowTag
        return window
    }
}

extension UIAlertAction {
    
    /// Create and return an action with the specified title and behavior **that can be used with** `UIAlertController`s **presented by PresentationKit**
    ///
    /// Actions are enabled by default when you create them **and when they execute their handlers they also destroy the** `UIWindow` **created by PresentationKit**
    
    /// - Parameters:
    ///   - title: The text to use for the button title. The value you specify should be localized for the user’s current language. This parameter must not be nil, except in a tvOS app where a nil title may be used with UIAlertAction.Style.cancel.
    ///   - style: Additional styling information to apply to the button. Use the style information to convey the type of action that is performed by the button. For a list of possible values, see the constants in UIAlertAction.Style.
    ///   - handler: A block to execute when the user selects the action. This block has no return value and takes the selected action object as its only parameter.
    /// - Returns: A new alert action object.
    public static func AlertAction(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> PAlertAction {
        
        let alert = PAlertAction(title: title, style: style) { (action) in
            let rootViewController = UIApplication.shared.windows.filter( { $0.tag == .newWindowTag } ).first?.rootViewController as? RootViewController
            rootViewController?.dismissWindow()
            handler?(action)
        }
        return alert
    }
}

/// Class that exists only to mark wheter a `UIAlertAction` instance is properly prepared to destroy the `UIWindow` which PresentationKit uses.
public class PAlertAction: UIAlertAction { }
