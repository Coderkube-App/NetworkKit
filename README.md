# NetworkKit

`NetworkKit` is a reusable Swift Package that provides a clean, scalable, and production-ready network abstraction for Apple platforms.

It supports:

- `Alamofire`-backed networking with `async/await`
- Standardized request, upload, and download methods
- Multipart form data support
- Request interception and retry logic
- Progress tracking for long-running operations
- Thread-safe access patterns and dependency injection

## Requirements

- iOS 15+
- macOS 12+
- Swift 6.2+

## Installation

### Swift Package Manager

In Xcode:

1. Go to **File > Add Packages...**
2. Enter your repository URL for `NetworkKit`
3. Select the version/range and add the package

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Coderkube-App/NetworkKit.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "NetworkKit", package: "NetworkKit")
        ]
    )
]
```

## Package Structure

```text
NetworkKit/
 ├── Sources/NetworkKit/
 │   ├── Core/
 │   ├── Models/
 │   ├── Service/
 │   ├── Resources/
 │   └── NetworkKit.swift
 ├── Tests/NetworkKitTests/
 └── Package.swift
```

## Core API

### NetworkProtocol

```swift
public protocol NetworkProtocol {
    func request<T: Decodable & Sendable>(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, interceptor: RequestInterceptor?) async throws -> T
    func upload<T: Decodable & Sendable>(_ url: URLConvertible, method: HTTPMethod, multipartFormData: @escaping (MultipartFormData) -> Void, headers: HTTPHeaders?, interceptor: RequestInterceptor?, onProgress: (@Sendable (Double) -> Void)?) async throws -> T
    func download(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, interceptor: RequestInterceptor?, to destination: DownloadRequest.Destination?, onProgress: (@Sendable (Double) -> Void)?) async throws -> URL
}
```

### NetworkKit Entry Point

```swift
let service = NetworkKit.shared.service
let response: MyModel = try await service.request("https://api.example.com/data")
```

## Usage

### Simple GET/POST Requests

```swift
let service = NetworkKit.shared.service

// GET Request
let users: [User] = try await service.request("https://api.example.com/users")

// POST Request with parameters
let params = ["name": "Vijay", "job": "Developer"]
let newUser: User = try await service.request(
    "https://api.example.com/users",
    method: .post,
    parameters: params,
    encoding: JSONEncoding.default
)
```

### Multipart Uploads

```swift
let service = NetworkKit.shared.service

let result: UploadResponse = try await service.upload(
    "https://api.example.com/upload",
    multipartFormData: { formData in
        formData.append(imageData, withName: "file", fileName: "avatar.jpg", mimeType: "image/jpeg")
        formData.append("user_123".data(using: .utf8)!, withName: "userId")
    },
    onProgress: { progress in
        print("Upload progress: \(progress * 100)%")
    }
)
```

### File Downloads

```swift
let service = NetworkKit.shared.service

let localURL = try await service.download(
    "https://api.example.com/large-file.zip",
    onProgress: { progress in
        print("Download progress: \(progress * 100)%")
    }
)
```

### Custom Interceptors (Retry/Auth)

```swift
let retryInterceptor = RetryInterceptor(retryLimit: 3)
let networkKit = NetworkKit(interceptor: retryInterceptor)

let data: MyModel = try await networkKit.service.request("https://api.example.com/data")
```

## Error Handling

`NetworkError` provides shared error types:

- `invalidURL`
- `serverError(statusCode:data:)`
- `decodingFailed`
- `noInternetConnection`
- `timeout`
- `alamofireError(AFError)`

## Testing

Run tests:

```bash
swift test
```

## Automated Versioning

This repository uses a GitHub Actions workflow to automatically create version tags and GitHub Releases after changes are merged into `main`.

Version bump rules:

- `fix:` or other non-breaking commits -> patch bump (`x.y.Z`)
- `feat:` -> minor bump (`x.Y.0`)
- `BREAKING CHANGE` in the commit body or footer -> major bump (`X.0.0`)

The workflow runs from `.github/workflows/automated-versioning.yml` and generates release notes automatically for each new version.

## Design Notes

- Protocol-driven architecture for flexibility
- Dependency injection support for testability
- Thread-safe implementation using structured concurrency
- Built-in support for Alamofire features (Interceptors, Parameter Encoding)

## License

This project is licensed under the MIT License.
