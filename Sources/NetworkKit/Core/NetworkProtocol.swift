//
// Copyright (c) 2026 Coderkube Technologies - NetworkKit. All rights reserved.
//

import Foundation
import Alamofire

/// A protocol defining the core networking capabilities of `NetworkKit`.
/// Conforming types must provide asynchronous methods for requests, uploads, and downloads.
public protocol NetworkProtocol: Sendable {
  
  /// Performs a network request and decodes the response into a specified type.
  /// - Parameters:
  ///   - url: The endpoint URL.
  ///   - method: The HTTP method (e.g., .get, .post).
  ///   - parameters: The parameters to send with the request.
  ///   - encoding: The parameter encoding.
  ///   - headers: Optional HTTP headers.
  ///   - interceptor: Optional request interceptor.
  /// - Returns: A decoded object of type `T`.
  func request<T: Decodable & Sendable>(
    _ url: URLConvertible,
    method: HTTPMethod,
    parameters: Parameters?,
    encoding: ParameterEncoding,
    headers: HTTPHeaders?,
    interceptor: RequestInterceptor?
  ) async throws -> T
  
  /// Performs a multipart/form-data upload request.
  /// - Parameters:
  ///   - url: The endpoint URL.
  ///   - method: The HTTP method (usually .post or .put).
  ///   - multipartFormData: A closure to construct the multipart form data.
  ///   - headers: Optional HTTP headers.
  ///   - interceptor: Optional request interceptor.
  ///   - onProgress: Optional progress callback receiving values between 0.0 and 1.0.
  /// - Returns: A decoded object of type `T`.
  func upload<T: Decodable & Sendable>(
    _ url: URLConvertible,
    method: HTTPMethod,
    multipartFormData: @escaping (MultipartFormData) -> Void,
    headers: HTTPHeaders?,
    interceptor: RequestInterceptor?,
    onProgress: (@Sendable (Double) -> Void)?
  ) async throws -> T
  
  /// Downloads a file from the specified URL.
  /// - Parameters:
  ///   - url: The source URL.
  ///   - method: The HTTP method.
  ///   - parameters: Optional parameters.
  ///   - encoding: Parameter encoding.
  ///   - headers: Optional HTTP headers.
  ///   - interceptor: Optional request interceptor.
  ///   - destination: A closure determining where the file should be saved.
  ///   - onProgress: Optional progress callback.
  /// - Returns: The local URL where the file was saved.
  func download(
    _ url: URLConvertible,
    method: HTTPMethod,
    parameters: Parameters?,
    encoding: ParameterEncoding,
    headers: HTTPHeaders?,
    interceptor: RequestInterceptor?,
    to destination: DownloadRequest.Destination?,
    onProgress: (@Sendable (Double) -> Void)?
  ) async throws -> URL
}

public extension NetworkProtocol {
  /// Convenience overload for `request` with default parameter values.
  func request<T: Decodable & Sendable>(
    _ url: URLConvertible,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil,
    encoding: ParameterEncoding = URLEncoding.default,
    headers: HTTPHeaders? = nil,
    interceptor: RequestInterceptor? = nil
  ) async throws -> T {
    try await request(
      url,
      method: method,
      parameters: parameters,
      encoding: encoding,
      headers: headers,
      interceptor: interceptor
    )
  }
}
