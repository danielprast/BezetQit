//
//  ConnectionReachability.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 06/08/25.
//

import Foundation
import Network


public actor ConnectionReachability {

  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue.global(qos: .background)

  public init() {}

  deinit {
    print("💥 \(Self.self) • destroyed")
  }

  private weak var delegate: MainDelegate?
  private var _isConnected = false
  private var streamContinuation: AsyncStream<NWPath>.Continuation?

  private lazy var networkPathsStream: AsyncStream<NWPath> = {
    AsyncStream { continuation in
      streamContinuation = continuation

      monitor.pathUpdateHandler = { path in
        continuation.yield(path)
      }

      continuation.onTermination = { [weak self] _ in
        self?.monitor.cancel()
      }

      monitor.start(queue: queue)
      print("🚀 network state monitoring • start")
    }
  }()

  public var isConnected: Bool {
    get async { _isConnected }
  }

  public func setDelegate(_ delegate: MainDelegate) {
    self.delegate = delegate
  }

  public func startMonitoring() async {
    for await value in networkPathsStream {
      _isConnected = value.status == .satisfied
      await delegate?.didUpdateConnectionState(isConnected: _isConnected)
    }
  }

  public func stopMonitoring() async {
    streamContinuation?.finish()
  }

  // MARK: - •

  @MainActor public protocol MainDelegate: AnyObject, Sendable {
    func didUpdateConnectionState(isConnected: Bool)
  }
}
