//
//  NetworkServiceUnit.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 18/08/25.
//

import Foundation


public protocol NetworkServiceUnit: Actor {

  func performRequest<T>(
    decodable: T.Type,
    url: URL,
    method: NTKRequestMethod,
    headers: [String : String]?,
    parameters: [String : Any & Sendable]?,
    encoding: NTKEncoding
  ) async throws -> T where T: Decodable

  func performRequestData(
    url: URL,
    method: NTKRequestMethod,
    headers: [String : String],
    parameters: [String : Any & Sendable],
    encoding: NTKEncoding
  ) async throws -> Data

  func validateNetworkResponse(
    data: Data,
    httpResponse: HTTPURLResponse
  ) throws -> Data
}
