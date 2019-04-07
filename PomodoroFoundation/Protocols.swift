//
//  Protocols.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 07/04/2019.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation
import CoreData

public protocol PMAppDelegate: UIApplicationDelegate {
    var persistentContainer: NSPersistentContainer { get }
    func saveContext() 
}
