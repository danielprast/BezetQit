//
//  GLogger.swift
//  BezetQit
//
//  Created by Daniel Prastiwa on 07/08/25.
//

import Foundation
import OSLog


private func NLog(
  _ key: KeyLogger,
  layer: String,
  message: Any,
  file: String = #file,
  function: String = #function,
  line: Int = #line
) {

  let logger = Logger(
    subsystem: "Logger",
    category: "\(layer) :: at function \(function) :: line \(line) :: file \(file)"
  )

  switch key {
  case .debug:
    logger.debug("debug: \(String(describing: message))")
  case .info:
    logger.info("info: \(String(describing: message))")
  case .error:
    logger.error("error: \(String(describing: message))")
  case .trace:
    logger.trace("trace: \(String(describing: message))")
  case .warning:
    logger.warning("warning: \(String(describing: message))")
  case .fault:
    logger.fault("fault: \(String(describing: message))")
  case .critical:
    logger.critical("critical: \(String(describing: message))")
  }

}

public func GLogger(
  _ key: KeyLogger,
  layer: String,
  message: Any,
  file: String = #file,
  function: String = #function,
  line: Int = #line
) {

  NLog(
    key,
    layer: layer,
    message: message,
    file: file,
    function: function,
    line: line
  )

}

public enum KeyLogger{
  case debug
  case info
  case error
  case trace
  case warning
  case fault
  case critical
}
