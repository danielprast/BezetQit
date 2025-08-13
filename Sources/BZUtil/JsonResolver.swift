//
//  JsonResolver.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 13/08/25.
//

import Foundation
import SystemConfiguration


public struct JsonResolver {

  public init() {}

  public static func decodeJson<T>(
    from data: Data,
    outputType type: T.Type
  ) -> T? where T: Decodable, T: Encodable  {
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      return nil
    }
  }

  public static func createData(from dict: [String: Any]) -> Data? {
    return try? JSONSerialization.data(withJSONObject: dict, options: [])
  }

  public static func createData(fromString string: String) -> Data? {
    return string.data(using: .utf8)
  }

  public static func parseDataToJson(_ data: Data) -> [String : Any] {
    guard let result = try? JSONSerialization.jsonObject(with: data) else {
      return [:]
    }

    if let jsonArray = result as? [Any] {
      return ["data": jsonArray]
    }

    guard let dict = result as? [String: Any] else {
      return [:]
    }

    return dict
  }

  public static func encodeToJson(dictionary: [String: Any]) -> String {
    guard
      let jsonData = try? JSONSerialization.data(
        withJSONObject: dictionary,
        options: .prettyPrinted
      ),
      let jsonString = String(data: jsonData, encoding: .utf8)
    else {
      return ""
    }
    return jsonString
  }

  public static func readJsonFileFromResource(
    bundle: Bundle,
    fileName: String
  ) -> Data? {
    guard
      let jsonResource = bundle.url(forResource: fileName, withExtension: "json"),
      let jsonData = try? Data(contentsOf: jsonResource)
    else {
      return nil
    }
    return jsonData
  }

}
