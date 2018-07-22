//
//  Utils.swift
//  NasaService
//
//  Created by Alexey Averkin on 22/07/2018.
//  Copyright © 2018 Alexey Averkin. All rights reserved.
//

import Foundation

public var isDebug: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}

public func dprint(_ item: @autoclosure () -> Any, separator: String = " ", terminator: String = "\n") {
    guard isDebug else { return }
    Swift.print(item(), separator:separator, terminator: terminator)
}

