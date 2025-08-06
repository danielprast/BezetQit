//
//  ConnectionReachability.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 06/08/25.
//

import Foundation
import Network


public actor ConnectionReachability {
  let monitor = NWPathMonitor()
  let queue = DispatchQueue.global(qos: .background)
  private weak var delegate: MainDelegate?

  private var _isConnected = false

  public var isConnected: Bool {
    get async {
      _isConnected
    }
  }

  public init() {}

  deinit {
    monitor.cancel()
  }

  public func setDelegate(_ delegate: MainDelegate) {
    self.delegate = delegate
  }

  public func startMonitoring() async {
    for await value in networkPaths() {
      _isConnected = value.status == .satisfied
      await delegate?.didUpdateConnectionState(isConnected: _isConnected)
    }
  }

  public func networkPaths() -> AsyncStream<NWPath> {
    AsyncStream { continuation in
      monitor.pathUpdateHandler = { path in
        continuation.yield(path)
      }

      continuation.onTermination = { [weak self] _ in
        self?.monitor.cancel()
      }

      monitor.start(queue: queue)
      print("🚀 monitor.start")
    }
  }

  // MARK: - •

  @MainActor public protocol MainDelegate: AnyObject, Sendable {
    func didUpdateConnectionState(isConnected: Bool)
  }
}
