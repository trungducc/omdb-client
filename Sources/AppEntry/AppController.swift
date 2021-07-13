//
//  AppController.swift
//  OMDBClient
//
//  Created by duc on 13/07/2021.
//

import UIKit

struct AppController {
    func attachInitialUI(with window: UIWindow?) {
        guard let window = window else { return }

        window.rootViewController = makeRootViewController()
        window.makeKeyAndVisible()
    }
}

private extension AppController {
    func makeRootViewController() -> UIViewController {
        return ViewController()
    }
}
