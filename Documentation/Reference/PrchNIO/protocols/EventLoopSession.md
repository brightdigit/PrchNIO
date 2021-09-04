**PROTOCOL**

# `EventLoopSession`

```swift
public protocol EventLoopSession: Session
```

## Methods
### `beginRequest(_:)`

```swift
func beginRequest(_ request: RequestType) -> EventLoopFuture<Response>
```

### `nextEventLoop()`

```swift
func nextEventLoop() -> EventLoop
```
