//
//  ConnectionReachability.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 06/08/25.
//

import Foundation
import Network
import SystemConfiguration


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

  public func getNetworkConnectionState() async -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)

    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        SCNetworkReachabilityCreateWithAddress(nil, $0)
      }
    }) else {
      return false
    }

    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
      return false
    }

    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)

    return (isReachable && !needsConnection)
  }

  // MARK: - •

  @MainActor public protocol MainDelegate: AnyObject, Sendable {
    func didUpdateConnectionState(isConnected: Bool)
  }
}
