//
//  NetworkConnectionCheckerImpl_V2.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 22/08/25.
//

import Foundation


public actor NetworkConnectionCheckerImpl_V2: NetworkConnectionChecker {

  let connectionReachability: ConnectionReachability

  public init(reachability: ConnectionReachability) {
    self.connectionReachability = reachability
  }

  public var isConnected: Bool {
    get async {
      await connectionReachability.getNetworkConnectionState()
    }
  }
}
