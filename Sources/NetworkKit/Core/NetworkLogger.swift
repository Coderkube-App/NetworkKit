//
// Copyright (c) 2026 Coderkube Technologies - NetworkKit. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// A centralized logger that stores network activity for real-time visualization in the UI.
/// Conforms to `ObservableObject` to allow SwiftUI views to react to new log entries.
@MainActor
public final class NetworkLogger: ObservableObject, Sendable {
  /// The singleton instance of the logger.
  public static let shared = NetworkLogger()
  
  /// A list of log entries, ordered from newest to oldest.
  @Published public var logs: [LogEntry] = []
  
  private init() {}
  
  /// Adds a new message to the logs.
  /// - Parameters:
  ///   - message: The log message text.
  ///   - type: The category of the log (e.g., .info, .error). Defaults to `.info`.
  public func log(_ message: String, type: LogType = .info) {
    self.logs.insert(LogEntry(message: message, type: type, timestamp: Date()), at: 0)
  }
  
  /// Clears all stored logs.
  public func clear() {
    logs.removeAll()
  }
}

/// Represents a single entry in the network logs.
public struct LogEntry: Identifiable, Sendable {
  public let id = UUID()
  /// The log message content.
  public let message: String
  /// The category of the log.
  public let type: LogType
  /// The exact date and time the log was created.
  public let timestamp: Date
  
  public init(message: String, type: LogType, timestamp: Date) {
    self.message = message
    self.type = type
    self.timestamp = timestamp
  }
}

/// Defines the category of a log entry, used for filtering and visual distinction.
public enum LogType: Sendable {
  /// General information.
  case info
  /// Outgoing network requests.
  case request
  /// Incoming network responses.
  case response
  /// Errors that occurred during network operations.
  case error
  
  /// A system icon name corresponding to the log type.
  public var icon: String {
    switch self {
    case .info: return "info.circle"
    case .request: return "arrow.up.circle"
    case .response: return "arrow.down.circle"
    case .error: return "exclamationmark.triangle"
    }
  }
  
  /// Optional color styling (reserved for future use).
  public var color: Color? {
    nil
  }
}
