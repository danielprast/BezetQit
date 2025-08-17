//
//  ConnectionReachabilityModel.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 06/08/25.
//

import Foundation


@MainActor open class ConnectionReachabilityModel: ObservableObject {

  let connectionReachability: ConnectionReachability

  public init(connectionReachability: ConnectionReachability) {
    self.connectionReachability = connectionReachability
    startNetworkStateMonitoring()
  }

  @Published open var isInternetAvailable = false

  open func startNetworkStateMonitoring() {
    Task {
      await connectionReachability.setDelegate(self)
      await connectionReachability.startMonitoring()
    }
  }

  open func stopNetworkStateMonitoring() {
    Task {
      await connectionReachability.stopMonitoring()
    }
  }

  // MARK: - • ConnectionReachability.MainDelegate

  open func didUpdateConnectionState(isConnected: Bool) {
    isInternetAvailable = isConnected
    print("• is connected : \(isConnected)")
  }

}


extension ConnectionReachabilityModel: ConnectionReachability.MainDelegate {}


extension ConnectionReachabilityModel {

  public enum Factory {

    @MainActor public static func newInstance() -> ConnectionReachabilityModel {
      ConnectionReachabilityModel(connectionReachability: ConnectionReachability())
    }
  }

}
