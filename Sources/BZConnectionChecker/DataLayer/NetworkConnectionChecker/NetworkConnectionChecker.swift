//
//  NetworkConnectionChecker.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 06/08/25.
//

import Foundation


public protocol NetworkConnectionChecker: Sendable {
  var isConnected: Bool { get async }
}
