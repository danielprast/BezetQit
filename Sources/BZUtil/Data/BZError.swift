//
//  BZError.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 17/08/25.
//

import Foundation


public enum BZError: LocalizedError, Equatable {

  case custom(String)
  case emptyResult
  case connectionProblem
  case parsingError
  case invalidResponse
  case internalServerError
  case unauthorizedError

  public var errorMessage: String {
    switch self {
    case let .custom(msg):
      return msg
    case .internalServerError:
      return "Internal Server Error"
    case .unauthorizedError:
      return "Expired Session"
    case .invalidResponse:
      return "Invalid response"
    case .parsingError:
      return "Something went wrong. Please try again later."
    case .connectionProblem:
      return "Please check your network connection"
    case .emptyResult:
      return "Data not found"
    }
  }

  public static func ==(lhs: BZError, rhs: BZError) -> Bool {
    switch (lhs, rhs) {
    case (custom(let lhsMessage), custom(let rhsMessage)):
      lhsMessage == rhsMessage
    case (internalServerError, internalServerError):
      true
    case (invalidResponse, invalidResponse):
      true
    case (unauthorizedError, unauthorizedError):
      true
    case (parsingError, parsingError):
      true
    case (connectionProblem, connectionProblem):
      true
    case (emptyResult, emptyResult):
      true
    default:
      false
    }
  }
}
