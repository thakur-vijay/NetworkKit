# NetworkKit

A modern Swift networking library for iOS apps, built around type-safe endpoints, async/await-first requests, configurable environments, and practical HTTP features including caching, retries, authentication integration, and request/response interception. NetworkKit also supports WebSocket connections.

<p align="center">
  <img alt="NetworkKit" src="https://img.shields.io/badge/Swift-6.0-orange?logo=swift&logoColor=white" />
  <img alt="Platform" src="https://img.shields.io/badge/iOS-15%2B-3B82F6" />
  <img alt="Async" src="https://img.shields.io/badge/Async%2FAwait-supported-10B981" />
  <img alt="Combine" src="https://img.shields.io/badge/Combine-supported-8B5CF6" />
  <img alt="WebSocket" src="https://img.shields.io/badge/WebSocket-supported-0EA5E9" />
</p>

## Why NetworkKit

- Define API contracts with strongly typed `Endpoint` types.
- Make requests with Swift concurrency or use the Combine publisher bridge.
- Configure development, staging, production, and custom environments.
- Use built-in cache policies and configurable retry behavior.
- Integrate app-owned token storage and token-refresh flows.
- Adapt outgoing requests and observe responses with interceptors.
- Encode JSON, raw data, URL-encoded forms, and multipart forms.
- Open WebSocket connections and send or receive messages.

## Installation

### Swift Package Manager

Add NetworkKit in Xcode using **File → Add Package Dependencies…** and enter:

```text
https://github.com/thakur-vijay/NetworkKit.git
```

Select a released version and add the `NetworkKit` product to your app target.

You can also declare the dependency in a Swift package manifest. Replace `1.0.0` with the release version you want to use:

```swift
dependencies: [
    .package(
        url: "https://github.com/thakur-vijay/NetworkKit.git",
        from: "1.0.0"
    )
]
```

Then import the library:

```swift
import NetworkKit
```

## Quick start

### 1. Define a response model

```swift
struct User: Decodable, Sendable {
    let id: String
    let name: String
    let email: String
}
```

### 2. Define an endpoint

```swift
struct FetchUserEndpoint: Endpoint {
    typealias Response = User

    let userID: String

    var path: String { "/users/\(userID)" }
    var method: HTTPMethod { .get }
    var requiresAuth: Bool { false }
}
```

Endpoints default to requiring authentication. Set `requiresAuth` to `false` for public endpoints; protected endpoints need an appropriate auth configuration.

### 3. Configure and use a client

```swift
let resolver = DefaultEnvironmentResolver { environment in
    switch environment {
    case .development:
        AppEnvironmentConfig(baseURL: "https://api.dev.example.com")
    case .staging:
        AppEnvironmentConfig(baseURL: "https://api.staging.example.com")
    case .production:
        AppEnvironmentConfig(baseURL: "https://api.example.com")
    case .custom:
        AppEnvironmentConfig(baseURL: "https://api.example.com")
    }
}

let configuration = NetworkClientConfiguration(
    environment: .production,
    resolver: resolver
)
let client = URLSessionNetworkClient(configuration: configuration)

let user = try await client.request(FetchUserEndpoint(userID: "123"))
print(user.name)
```

## Request options

### Async/await and raw data

```swift
let user = try await client.request(FetchUserEndpoint(userID: "123"))
let data = try await client.requestData(FetchUserEndpoint(userID: "123"))
```

The client also provides `requestData(_ url: URL)` when a typed endpoint is not needed.

### Combine

```swift
let cancellable = client
    .publisher(FetchUserEndpoint(userID: "123"))
    .sink(
        receiveCompletion: { completion in
            if case .failure(let error) = completion {
                print(error.localizedDescription)
            }
        },
        receiveValue: { user in
            print(user.name)
        }
    )
```

### HTTP methods, headers, and query items

Available methods are `.get`, `.post`, `.put`, `.patch`, `.delete`, and `.head`.

```swift
struct SearchEndpoint: Endpoint {
    typealias Response = [User]

    let searchTerm: String

    var path: String { "/users" }
    var method: HTTPMethod { .get }
    var requiresAuth: Bool { false }
    var headers: [HTTPHeader] {
        [.accept(.json), .userAgent("MyApp/1.0")]
    }
    var queryItems: [URLQueryItem]? {
        [URLQueryItem(name: "q", value: searchTerm)]
    }
}
```

Use `HTTPHeader(name:value:)` for application-specific headers. Keep credentials in secure app-managed storage and avoid placing secrets in source-controlled endpoint definitions.

### Request bodies

```swift
struct CreateUserBody: Encodable {
    let name: String
    let email: String
}

struct CreateUserEndpoint: Endpoint {
    typealias Response = User

    let payload: CreateUserBody

    var path: String { "/users" }
    var method: HTTPMethod { .post }
    var requiresAuth: Bool { false }
    var body: RequestBody? { .json(payload) }
}
```

Supported body types:

- `.json(Encodable)`
- `.raw(Data, contentType:)`
- `.formURLEncoded([String: String])`
- `.multipart(MultipartFormData)`

For multipart data, create `MultipartFormData.Part` values with a field name, MIME type, bytes, and an optional filename.

## Environments and configuration

Use `DefaultEnvironmentResolver` to map `AppEnvironment` cases to `AppEnvironmentConfig` values. Each configuration includes a base URL, request timeout, default headers, an optional `URLCache`, and a logging-related setting.

`NetworkClientConfiguration` also accepts:

- An optional authentication manager.
- A retry policy.
- A cache manager.
- Request and response interceptors.
- An optional logger.
- A response `JSONDecoder`.

The default request encoder uses snake-case keys and ISO-8601 dates. The response decoder is configurable; set its key/date strategies to match your API.

## Caching and retries

Available endpoint cache policies:

```swift
.reloadIgnoringCache
.returnCacheDataElseFetch
.returnCacheDataDontLoad
.fetchAndCache(ttl: 300)
```

The built-in cache stores eligible GET responses. Choose a policy based on freshness requirements, and avoid caching account-specific data in a cache shared across user sessions.

Retry behavior is configurable through `RetryPolicy`. `ExponentialBackoffRetryPolicy` provides exponential delays with jitter; `NoRetryPolicy` disables automatic retries.

```swift
let configuration = NetworkClientConfiguration(
    environment: .production,
    resolver: resolver,
    retryPolicy: ExponentialBackoffRetryPolicy(
        maxAttempts: 3,
        baseDelay: 1,
        maxDelay: 10
    )
)
```

Retries are intended for transient network and server failures. Ensure requests that your app retries are safe to repeat, especially for endpoints that create or modify server-side resources.

## Authentication integration

Endpoints declare whether authentication is required. NetworkKit provides integration points for app-owned token storage and a refresh-token endpoint, so authentication policy and credential persistence remain under application control.

Before relying on automatic bearer-token injection or refresh behavior in a production app, validate the complete flow against your API and the exact NetworkKit release you integrate. Apps can also provide their own authorization header or request interceptor when they need custom credential behavior.

## Interceptors and logging

Request interceptors can adapt outgoing requests; response interceptors can inspect completed HTTP responses. They are useful for signing, app-specific headers, auditing, analytics, and validation.

`NetworkLogger` can log request and response information when enabled. Review what data your application sends before enabling body logging: headers may contain credentials and bodies may contain personal or confidential data.

## WebSocket

Use `URLSessionWebSocketClient` for WebSocket connections. It takes a `URLRequest`, supports sending and receiving `URLSessionWebSocketTask.Message` values, and exposes open and close callbacks.

```swift
import Foundation
import NetworkKit

func connectToUpdates(using configuration: NetworkClientConfiguration) async throws {
    guard let url = URL(string: "wss://api.example.com/updates") else {
        throw NetworkError.invalidURL("wss://api.example.com/updates")
    }

    let socket = URLSessionWebSocketClient(configuration: configuration)
    socket.onOpen = {
        print("Connected")
    }
    socket.onClose = { code, _ in
        print("Closed: \(code)")
    }

    try await socket.connect(URLRequest(url: url))
    try await socket.send(.string("subscribe"))

    let message = try await socket.receive()
    if case .string(let text) = message {
        print(text)
    }

    socket.disconnect()
}
```

WebSocket reconnection and message-loop policy are app-managed. Provide any handshake headers through the request you pass to `connect`.

## Error handling

```swift
do {
    let user = try await client.request(FetchUserEndpoint(userID: "123"))
    print(user.name)
} catch let error as NetworkError {
    print(error.localizedDescription)
} catch {
    print("Unexpected error: \(error)")
}
```

`NetworkError` includes cases for invalid URLs, request encoding, missing auth tokens, HTTP status failures, decoding failures, empty responses, transport errors, cancellation, token refresh, and cache misses.

## API overview

- `NetworkClient` and `URLSessionNetworkClient`
- `WebSocketClient` and `URLSessionWebSocketClient`
- `Endpoint`, `HTTPMethod`, and `HTTPHeader`
- `RequestBody` and `MultipartFormData`
- `AppEnvironment`, `AppEnvironmentConfig`, and `AppEnvironmentResolving`
- `NetworkClientConfiguration`
- `RequestCachePolicy` and `CacheManaging`
- `RetryPolicy`, `ExponentialBackoffRetryPolicy`, and `NoRetryPolicy`
- `RequestInterceptor` and `ResponseInterceptor`
- `NetworkLogging` and `NetworkLogger`
- `NetworkError`

## Recommended practices

- Keep endpoints small and define one clear API operation per endpoint type.
- Use response models that conform to both `Decodable` and `Sendable`.
- Explicitly mark unauthenticated endpoints with `requiresAuth == false`.
- Centralize environment configuration and keep production credentials out of source.
- Select cache policies based on the sensitivity and freshness needs of the data.
- Use retries only where repeating the request is safe.
- Validate auth, logging, and WebSocket behavior against your service before release.
