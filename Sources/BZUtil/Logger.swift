//
//  Logger.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 07/08/25.
//

import Foundation
import OSLog


public func tlog(
  _ key: String,
  _ value: Any,
  type: TLogType = .info,
  subsystem: String = "module",
  file: String = #fileID,
  function: String = #function,
  line: Int = #line
) {
  if #available(iOS 17.0, *) {
    tshout(
      "\(type.emojiIcon) \(key)",
      value,
      type: type,
      subsystem: subsystem,
      file: file,
      function: function,
      line: line
    )
    return
  }
  print("\n")
  shout("\(type.emojiIcon) \(key)", value)
  print("--> ⌘")
}


public func shout(_ key: String, _ value: Any) {
  print("\(key): \(value)")
}


fileprivate func tshout(
  _ key: String,
  _ value: Any,
  type: TLogType = .info,
  subsystem: String = "module",
  file: String = #fileID,
  function: String = #function,
  line: Int = #line
) {
  _shout(
    key,
    value: value,
    type: type,
    subsystem: subsystem,
    category: "\(function) :: line \(line) :: at \(file)"
  )
}


fileprivate func _shout(
  _ key: String,
  value: Any,
  type: TLogType,
  subsystem: String,
  category: String
) {

  switch type {
  case .error:
    Logger(
      subsystem: subsystem,
      category: category
    ).critical("\(key) : \(String(describing: value))")
  case .warning:
    Logger(
      subsystem: subsystem,
      category: category
    ).warning("\(key) : \(String(describing: value))")
  case .info:
    Logger(
      subsystem: subsystem,
      category: category
    ).info("\(key) : \(String(describing: value))")
  }

}


// MARK: - •


public enum TLogType {
  case error
  case warning
  case info
}


public extension TLogType {

  var emojiIcon: String {
    switch self {
    case .error:
      "📛"
    case .warning:
      "⚠️"
    case .info:
      "😎"
    }
  }

}
