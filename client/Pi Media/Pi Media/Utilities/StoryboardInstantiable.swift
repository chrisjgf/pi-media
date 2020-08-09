//
//  StoryboardInstantiable.swift
//  Pi Media
//
//  Created by Chris on 05/04/2020.
//  Copyright © 2020 chris. All rights reserved.
//

import UIKit

public protocol StoryboardInstantiatable: class {
    static var storyboardName: String { get }
    static var storyboard: UIStoryboard { get }
}

public extension StoryboardInstantiatable {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
    }
}

public extension StoryboardInstantiatable where Self: UIViewController {
    static func instantiate() -> Self {
        guard
            let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? Self
        else {
            fatalError("The VC of \(storyboard) is not of class \(self)")
        }
        return viewController
    }
}
