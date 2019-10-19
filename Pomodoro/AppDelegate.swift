//
//  AppDelegate.swift
//  Pomodoro
//
//  Created by 류성두 on 22/12/2018.
//  Copyright © 2018 Sungdoo. All rights reserved.
//

import CoreData
// import GoogleMobileAds
import JiraSupport
import PomodoroFoundation
import PomodoroUIKit
import UIKit
import UserNotifications

var dateBackgroundEnter: Date?
var hasOpenedByWidgetPlayPauseButton = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_: UIApplication, open url: URL, options _: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        hasOpenedByWidgetPlayPauseButton = url.absoluteString.has("playOrPause")
        return true
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let savedInterval = retreiveInterval(from: UserDefaults(suiteName: "group.pomodoro.com")!) {
            IntervalManager.shared = savedInterval
        } else {
            IntervalManager.shared = FocusInterval()
        }

        if let credentials = try? retreiveSavedCredentials() {
            loginJira(with: credentials, then: { result in
                if result.hasFailed {
                    removeFromKeychain(credentials: credentials)
                }
                print(result)
            })
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        var storyboard: UIStoryboard!
        if #available(macCatalyst 13, *) {
            storyboard = UIStoryboard(name: "MacMain", bundle: nil)
        } else {
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }

        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        saveDateBackgroundEntered(Date(), to: UserDefaults.shared)
        if let interval = IntervalManager.shared {
            saveIntervalContext(of: interval, to: UserDefaults.shared)
            registerBackgroundTimer(with: interval)
        }

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        retreiveIntervalContext()
        resetIntervalContext(on: UserDefaults.shared)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func retreiveIntervalContext() {
        guard let interval = IntervalManager.shared else { return }
        if retreiveBool(for: .enhancedFocusMode, from: UserDefaults.shared) == nil {
            save(false, for: .enhancedFocusMode, to: UserDefaults.shared)
        }
        if let dateBackgroundEnter = retreiveDateBackgroundEntered(from: UserDefaults.shared),
            let isEnhancedFocusMode = retreiveBool(for: .enhancedFocusMode, from: UserDefaults.shared),
            isEnhancedFocusMode == false,
            interval.isActive == true {
            let timeIntervalSinceBackground = Date().timeIntervalSince(dateBackgroundEnter)
            interval.elapsedSeconds += timeIntervalSinceBackground
            if interval.elapsedSeconds >= interval.targetSeconds {
                interval.stopTimer(by: .time, isFromBackground: true)
            }
        } else if hasOpenedByWidgetPlayPauseButton, let widgetInterval = retreiveInterval(from: UserDefaults.shared) {
            interval.elapsedSeconds = widgetInterval.elapsedSeconds
            interval.startOrPauseTimer()
            hasOpenedByWidgetPlayPauseButton = false
        }
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
//        saveContext()
    }

    // MARK: - Core Data stack

//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//         */
//        let container = TLPersistantContainer(name: "TimeLine")
//        container.loadPersistentStores(completionHandler: { _, error in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()

    // MARK: - Core Data Saving support

//    func saveContext() {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }
}

func infoForKey(_ key: String) -> String? {
    return (Bundle.main.infoDictionary?[key] as? String)?
        .replacingOccurrences(of: "\\", with: "")
}
