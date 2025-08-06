//
//  ConnectionReachabilityModel.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 06/08/25.
//

import Foundation


@MainActor
public final class ConnectionReachabilityModel: ObservableObject {

  let connectionReachability: ConnectionReachability

  public init(connectionReachability: ConnectionReachability) {
    self.connectionReachability = connectionReachability
    startNetworkStateMonitoring()
  }

  @Published public var isInternetAvailable = false

  public func startNetworkStateMonitoring() {
    Task {
      await connectionReachability.setDelegate(self)
      await connectionReachability.startMonitoring()
    }
  }

  public func stopNetworkStateMonitoring() {
    Task {
      await connectionReachability.stopMonitoring()
    }
  }

  // MARK: - • ConnectionReachability.MainDelegate

  public func didUpdateConnectionState(isConnected: Bool) {
    isInternetAvailable = isConnected
    print("• is connected : \(isConnected)")
  }

}


extension ConnectionReachabilityModel: ConnectionReachability.MainDelegate {}
