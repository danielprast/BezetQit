//
//  NetworkConnectionCheckerImpl.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 06/08/25.
//

import Foundation
import Network

/// Deprecated, use NetworkConnectionCheckerImpl_V2 instead.
public actor NetworkConnectionCheckerImpl: NetworkConnectionChecker {

  let connectionReachability: ConnectionReachability

  public init(reachability: ConnectionReachability) {
    self.connectionReachability = reachability
  }

  public var isConnected: Bool {
    get async {
      await connectionReachability.isConnected
    }
  }
}
