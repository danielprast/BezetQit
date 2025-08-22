//
//  AlamoNetworkService.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 17/08/25.
//


import Foundation
import Alamofire


public actor AlamoNetworkService: NetworkServiceUnit {

  public static let shared = AlamoNetworkService()

  private init() {}

  public func performRequest<T>(
    decodable: T.Type,
    url: URL,
    method: NTKRequestMethod,
    headers: [String : String]? = nil,
    parameters: [String : Any & Sendable]? = nil,
    encoding: NTKEncoding
  ) async throws -> T where T: Decodable {
    do {
      let responseData = try await performRequestData(
        url: url,
        method: method,
        headers: headers ?? [:],
        parameters: parameters ?? [:],
        encoding: encoding
      )

      guard let responseModel = try? JSONDecoder().decode(
        T.self,
        from: responseData
      ) else {
        throw BZError.parsingError
      }

      return responseModel
    } catch {
      throw (error as! BZError)
    }
  }

  public func performRequestData(
    url: URL,
    method: NTKRequestMethod,
    headers: [String : String],
    parameters: [String : Any & Sendable],
    encoding: NTKEncoding
  ) async throws -> Data {
    let httpHeaders = HTTPHeaders.init(headers)

    let response = await AF.request(
      url,
      method: method.httpMethod,
      parameters: parameters.isEmpty ? nil : parameters,
      encoding: encoding.parameterEncoding,
      headers: headers.isEmpty ? nil : httpHeaders
    ).serializingData().response

    inspectResponse(response)

    guard
      let dataResponse = response.data,
      let httpResponse = response.response
    else {
      throw BZError.invalidResponse
    }

    return try validateNetworkResponse(
      data: dataResponse,
      httpResponse: httpResponse
    )
  }

  public func validateNetworkResponse(
    data: Data,
    httpResponse: HTTPURLResponse
  ) throws -> Data {
    switch httpResponse.statusCode {
    case 200...299:
      return data
    case 400:
      throw BZError.custom("400 Error")
    case 401:
      throw BZError.unauthorizedError
    case 403:
      throw BZError.custom("Forbidden")
    case 404:
      throw BZError.custom("Not Found")
    case 500...599:
      throw BZError.internalServerError
    default:
      throw BZError.invalidResponse
    }
  }

}


// MARK: - •

public enum NTKEncoding : Sendable {
  case url, json

  public var parameterEncoding: ParameterEncoding {
    switch self {
    case .url: return URLEncoding.default
    case .json: return JSONEncoding.default
    }
  }
}

// MARK: - •

public enum NTKRequestMethod: Sendable {
  case get, post, put, delete

  public var httpMethod: HTTPMethod {
    switch self {
    case .get: return HTTPMethod.get
    case .post: return HTTPMethod.post
    case .put: return HTTPMethod.put
    case .delete: return HTTPMethod.delete
    }
  }
}

// MARK: - •

public func inspectResponse(_ response: AFDataResponse<Data>) {
  defer {
    tlog("End network Request Response", "----------------------------------------\n")
    debugPrint(response)
  }
  var str = "\n"
  str += "• URL: \(String(describing: response.request?.url?.absoluteString.removingPercentEncoding)) \n"
  str += "• StatusCode: \(String(describing: response.response?.statusCode)) \n"
  str += "• Headers: \(String(describing: response.request?.allHTTPHeaderFields)) \n"

  if let body = response.request?.httpBody {
    if let bodyString = "\(String(decoding: body, as: UTF8.self))".removingPercentEncoding {
      str += "• Parameters: \(bodyString) \n"
    } else {
      str += "• Parameters: \(String(decoding: body, as: UTF8.self)) \n"
    }
  }

  let jsonStr = String(data: response.data ?? Data(), encoding: .utf8) ?? "-"
  str += "• Response: \(jsonStr.replacingOccurrences(of: "\\", with: "")) \n"

  tlog("Network response", str)
}
