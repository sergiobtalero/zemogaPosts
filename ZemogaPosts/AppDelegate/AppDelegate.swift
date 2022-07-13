//
//  AppDelegate.swift
//  ZemogaPosts
//
//  Created by Sergio Bravo on 12/07/22.
//

import Foundation
import Injector
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Injector.DependencyContainer.getPostsProvider()
        return true
    }
}
