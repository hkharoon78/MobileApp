//
//  Ext_General.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 05/06/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import Foundation


extension Bool {
    var int: Int {
        return self ? 1 : 0
    }
}

extension Int {
    var bool: Bool {
        return self==1 ? true : false
    }
}

extension DispatchQueue {

    private static var tokens: [String] = [] // static, so tokens are cached

    class func once(executionToken: String, _ closure: () -> Void) {
        // objc_sync_enter/objc_sync_exit is a locking mechanism
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        // if we previously stored token then do nothing
        if tokens.contains(executionToken) { return }
        tokens.append(executionToken)
        closure()
    }
}
