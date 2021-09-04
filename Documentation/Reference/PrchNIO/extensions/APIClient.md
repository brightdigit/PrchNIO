**EXTENSION**

# `APIClient`
```swift
public extension APIClient where SessionType: EventLoopSession
```

## Methods
### `request(_:)`

```swift
func request<ResponseType>(
  _ request: APIRequest<ResponseType>
) -> EventLoopFuture<ResponseType>
```
