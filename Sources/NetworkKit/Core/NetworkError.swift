//
// Copyright (c) 2026 Coderkube Technologies - NetworkKit. All rights reserved.
//

import Foundation
import Alamofire

/// Represents various network-related errors that can occur within `NetworkKit`.
public enum NetworkError: Error, LocalizedError, Equatable {
  /// The provided URL string was invalid.
  case invalidURL
  
  /// The server returned an error status code.
  /// - Parameters:
  ///   - statusCode: The HTTP status code received.
  ///   - data: The raw data returned by the server, if any.
  case serverError(statusCode: Int, data: Data?)
  
  /// The response data could not be decoded into the requested type.
  case decodingFailed
  
  /// No internet connection was detected.
  case noInternetConnection
  
  /// The request timed out.
  case timeout
  
  /// A custom error with a specific message.
  case custom(String)
  
  /// An underlying error from Alamofire.
  case alamofireError(AFError)
  
  /// A localized description for the error, retrieved from the package's string catalog.
  public var errorDescription: String? {
    switch self {
    case .invalidURL:
      return NetworkKitStrings.Error.invalidURL
    case .serverError(let statusCode, _):
      return NetworkKitStrings.Error.serverError(code: statusCode)
    case .decodingFailed:
      return NetworkKitStrings.Error.decodingFailed
    case .noInternetConnection:
      return NetworkKitStrings.Error.noInternet
    case .timeout:
      return NetworkKitStrings.Error.timeout
    case .custom(let message):
      return message
    case .alamofireError(let error):
      return error.localizedDescription
    }
  }
  
  /// Equatable implementation for comparing `NetworkError` instances.
  public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
    switch (lhs, rhs) {
    case (.invalidURL, .invalidURL),
      (.decodingFailed, .decodingFailed),
      (.noInternetConnection, .noInternetConnection),
      (.timeout, .timeout):
      return true
    case let (.serverError(code1, _), .serverError(code2, _)):
      return code1 == code2
    case let (.custom(msg1), .custom(msg2)):
      return msg1 == msg2
    case let (.alamofireError(err1), .alamofireError(err2)):
      return err1.localizedDescription == err2.localizedDescription
    default:
      return false
    }
  }
}
