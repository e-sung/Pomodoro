//
//  Protocols.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 07/04/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import CoreData
import Foundation

public protocol PMAppDelegate: UIApplicationDelegate {
    var persistentContainer: NSPersistentContainer { get }
    func saveContext()
}
