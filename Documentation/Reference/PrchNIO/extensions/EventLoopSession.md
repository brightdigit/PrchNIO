**EXTENSION**

# `EventLoopSession`
```swift
public extension EventLoopSession
```

## Methods
### `beginRequest(_:_:)`

```swift
func beginRequest(
  _ request: RequestType,
  _ completion: @escaping ((APIResult<Response>) -> Void)
) -> Task
```
