**EXTENSION**

# `HTTPClient`
```swift
extension HTTPClient: EventLoopSession
```

## Methods
### `nextEventLoop()`

```swift
public func nextEventLoop() -> EventLoop
```

### `beginRequest(_:)`

```swift
public func beginRequest(
  _ request: HTTPClient.Request
) -> EventLoopFuture<Prch.Response>
```

### `createRequest(_:withBaseURL:andHeaders:)`

```swift
public func createRequest<ResponseType>(
  _ request: APIRequest<ResponseType>,
  withBaseURL baseURL: URL,
  andHeaders headers: [String: String]
) throws -> HTTPClient.Request where ResponseType: APIResponseValue
```
