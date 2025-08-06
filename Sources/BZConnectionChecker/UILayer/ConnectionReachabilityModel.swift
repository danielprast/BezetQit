//
//  ConnectionReachabilityModel.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 06/08/25.
//

import Foundation


@MainActor
public final class ConnectionReachabilityModel: ObservableObject {

  let networkConnectionChecker: NetworkConnectionChecker
  let connectionReachability: ConnectionReachability

  public init(
    networkConnectionChecker: NetworkConnectionChecker,
    connectionReachability: ConnectionReachability
  ) {
    self.networkConnectionChecker = networkConnectionChecker
    self.connectionReachability = connectionReachability
    Task {
      await connectionReachability.setDelegate(self)
      await connectionReachability.startMonitoring()
    }
  }

  @Published public var isInternetAvailable = false

  public func didUpdateConnectionState(isConnected: Bool) {
    isInternetAvailable = isConnected
    print("• is connected : \(isConnected)")
  }

}


extension ConnectionReachabilityModel: ConnectionReachability.MainDelegate {}
