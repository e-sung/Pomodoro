//
//  KeyChain.swift
//  PomodoroFoundation
//
//  Created by 류성두 on 2019/10/16.
//  Copyright © 2019 Sungdoo. All rights reserved.
//

import Foundation


public func saveToKeychain(credentials: Credentials) {
    let host = credentials.host
    let account = credentials.username
    let password = credentials.password.data(using: String.Encoding.utf8)!
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrAccount as String: account,
                                kSecAttrServer as String: host,
                                kSecValueData as String: password]

    let status = SecItemAdd(query as CFDictionary, nil)
    print(status)
}

public func removeFromKeychain(credentials: Credentials) {
    let host = credentials.host
    let account = credentials.username
    let password = credentials.password.data(using: String.Encoding.utf8)!
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrAccount as String: account,
                                kSecAttrServer as String: host,
                                kSecValueData as String: password]

    let status = SecItemDelete(query as CFDictionary)
    print(status)
}

public func retreiveSavedCredentials(for server:String) throws -> Credentials {
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrServer as String: server,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true]

    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else { throw KeychainError.noPassword }
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }

    guard let existingItem = item as? [String: Any],
        let passwordData = existingItem[kSecValueData as String] as? Data,
        let password = String(data: passwordData, encoding: String.Encoding.utf8),
        let host = existingItem[kSecAttrServer as String] as? String,
        let account = existingItem[kSecAttrAccount as String] as? String
    else {
        throw KeychainError.unexpectedPasswordData
    }
    
    return Credentials(host:host, username: account, password: password)
}
