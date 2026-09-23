# NetworkKit

A modern Swift networking layer for iOS apps that emphasizes type-safe endpoints, clean configuration, async/await-first request flows, and production-friendly behaviors such as retries, caching, auth-aware request building, and request/response interception.

<p align="center">
  <img alt="NetworkKit" src="https://img.shields.io/badge/Swift-6.0-orange?logo=swift&logoColor=white" />
  <img alt="Platform" src="https://img.shields.io/badge/iOS-15%2B-3B82F6" />
  <img alt="Async" src="https://img.shields.io/badge/Async%2FAwait-supported-10B981" />
  <img alt="Combine" src="https://img.shields.io/badge/Combine-supported-8B5CF6" />
</p>

## Why NetworkKit

- Strongly typed API contracts via `Endpoint`
- Async-first default with `try await` support
- Combine bridge via `publisher(_:)`
- Configurable environments and per-request policies
- Automatic token refresh support for authenticated APIs
- Cache-aware request handling with TTL-based cache policies
- Retry support with customizable backoff strategies
- Request and response interceptors for logging, signing, auditing, and validation
- JSON decoding integration with custom encoder setup

---

## Installation

### Swift Package Manager

Add NetworkKit as a dependency in your Xcode project:

1. Open your app target in Xcode
2. Go to File → Add Package Dependencies...
3. Enter the repository URL for NetworkKit
4. Select the version or branch you want to use
5. Add the package to your app target

Example package declaration:

```swift
dependencies: [
    .package(url: "https://github.com/your-org/NetworkKit.git", from: "1.0.0")
]
```

Then import it in your Swift code:

```swift
import NetworkKit
```

---

## Core concepts

### Endpoint

Every API contract should be represented as an endpoint type:

```swift
import NetworkKit

struct UserEndpoint: Endpoint {
    typealias Response = UserResponse

    let userID: String

    var path: String { "/users/\(userID)" }
    var method: HTTPMethod { .get }
    var requiresAuth: Bool { true }
    var cachePolicy: RequestCachePolicy { .returnCacheDataElseFetch }
}
```

### NetworkClient

`NetworkClient` is the main entry point for making requests:

```swift
let resolver = DefaultEnvironmentResolver { env in
    switch env {
    case .development:
        return AppEnvironmentConfig(baseURL: "https://api.dev.example.com")
    case .staging:
        return AppEnvironmentConfig(baseURL: "https://api.staging.example.com")
    case .production:
        return AppEnvironmentConfig(baseURL: "https://api.example.com")
    case .custom:
        return AppEnvironmentConfig(baseURL: "https://api.example.com")
    }
}

let client = NetworkClient(configuration: .init(
    environment: .production,
    resolver: resolver,
    logger: NetworkLogger(),
    retryPolicy: ExponentialBackoffRetryPolicy()
))
```

---

## Quick start

### 1. Define your response model

```swift
struct UserResponse: Decodable, Sendable {
    let id: String
    let name: String
    let email: String
}
```

### 2. Create an endpoint

```swift
struct FetchUserEndpoint: Endpoint {
    typealias Response = UserResponse

    let userID: String

    var path: String { "/users/\(userID)" }
    var method: HTTPMethod { .get }
    var requiresAuth: Bool { true }
}
```

### 3. Send the request

```swift
let endpoint = FetchUserEndpoint(userID: "123")

let user = try await client.request(endpoint)
print(user.name)
```

---

## Request methods

### Async/await

```swift
let users: [User] = try await client.request(GetUsersEndpoint())
```

### Raw data

```swift
let data = try await client.requestData(GetUsersEndpoint())
```

### Combine

```swift
let cancellable = client
    .publisher(GetUsersEndpoint())
    .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }, receiveValue: { user in
        print(user)
    })
```

---

## Headers, methods, and bodies

### HTTP methods

```swift
public enum HTTPMethod: String, Sendable {
    case get, post, put, patch, delete, head
}
```

### Common headers

```swift
let headers: [HTTPHeader] = [
    .accept(.json),
    .contentType(.json),
    .userAgent("MyApp/1.0")
]
```

### Request bodies

```swift
struct CreateUserRequest: Encodable {
    let name: String
    let email: String
}

struct CreateUserEndpoint: Endpoint {
    typealias Response = UserResponse

    let payload: CreateUserRequest

    var path: String { "/users" }
    var method: HTTPMethod { .post }
    var body: RequestBody? { .json(payload) }
    var requiresAuth: Bool { true }
}
```

Supported body styles:

- `.json(Encodable)`
- `.raw(Data, contentType: .json)`
- `.formURLEncoded([String: String])`
- `.multipart(MultipartFormData)`

---

## Cache and retry policies

### Cache policies

```swift
var cachePolicy: RequestCachePolicy {
    .fetchAndCache(ttl: 300)
}
```

Available policies:

- `.reloadIgnoringCache`
- `.returnCacheDataElseFetch`
- `.returnCacheDataDontLoad`
- `.fetchAndCache(ttl:)`

### Retry policy

```swift
let policy = ExponentialBackoffRetryPolicy(
    maxAttempts: 3,
    baseDelay: 1.0,
    maxDelay: 10.0
)
```

`RetryPolicy` allows you to control which network errors are retryable and how long to wait between attempts.

---

## Environments

```swift
public enum AppEnvironment: Sendable {
    case development
    case staging
    case production
    case custom
}
```

```swift
public struct AppEnvironmentConfig: Sendable {
    public let baseURL: String
    public let timeout: TimeInterval
    public let defaultHeaders: [HTTPHeader]
    public let isLoggingEnabled: Bool
    public let urlCache: URLCache?
}
```

```swift
public protocol AppEnvironmentResolving: Sendable {
    func resolve(_ environment: AppEnvironment) -> AppEnvironmentConfig
}
```

---

## Authentication and auth-aware calls

When an endpoint requires authentication and a token is available, the request builder attaches the bearer token automatically.

```swift
struct SecureEndpoint: Endpoint {
    typealias Response = ProfileResponse

    var path: String { "/profile" }
    var method: HTTPMethod { .get }
    var requiresAuth: Bool { true }
}
```

If the API returns `401`, the SDK can refresh tokens through the configured auth flow.

---

## Error handling

```swift
do {
    let user = try await client.request(FetchUserEndpoint(userID: "123"))
} catch let error as NetworkError {
    print(error.localizedDescription)
} catch {
    print("Unexpected error: \(error)")
}
```

Common error cases include:

- `.invalidURL(_:)`
- `.missingAuthToken`
- `.unauthorized`
- `.forbidden`
- `.notFound`
- `.serverError(statusCode:)`
- `.decodingFailed(_:)`
- `.timeout`
- `.noInternetConnection`
- `.tokenRefreshFailed`
- `.cacheError(_:)`

---

## Logging and interceptors

You can provide a logger and request/response interceptors during client setup:

```swift
let logger = NetworkLogger(subsystem: "MyApp.Network")

let client = NetworkClient(configuration: .init(
    environment: .development,
    resolver: resolver,
    requestInterceptors: [logger],
    responseInterceptors: [],
    logger: logger
))
```

This is useful for:

- request tracing
- signing headers
- authorization propagation
- analytics hooks
- custom validation

---

## Recommended patterns

- Keep endpoints as lightweight enums or structs
- Keep response models decodable and `Sendable`
- Prefer `requiresAuth` over manually attaching auth in each request
- Use `cachePolicy` for read-heavy endpoints
- Use explicit `RetryPolicy` for flaky or mobile network conditions
- Keep environment configuration centralized in one resolver

---

## API surface at a glance

- `NetworkClient`
- `NetworkClientProtocol`
- `NetworkClientConfiguration`
- `Endpoint`
- `AppEnvironment`
- `AppEnvironmentConfig`
- `AppEnvironmentResolving`
- `DefaultEnvironmentResolver`
- `HTTPHeader`
- `HTTPMethod`
- `RequestBody`
- `RequestCachePolicy`
- `RetryPolicy`
- `ExponentialBackoffRetryPolicy`
- `NoRetryPolicy`
- `NetworkError`

---

## Notes

NetworkKit is designed to be straightforward for app teams: define endpoints, configure a client once, and let the SDK handle the mechanics of networking, decoding, auth, retries, and caching.

If you are a contributor or maintaining the library, see [README_INTERNAL.md](README_INTERNAL.md).

