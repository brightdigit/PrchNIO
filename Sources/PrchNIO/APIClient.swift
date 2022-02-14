import AsyncHTTPClient
import Foundation
import NIOCore
import Prch

public extension Client where SessionType: EventLoopSession {
  func request<RequestType: Prch.Request>(
    _ request: RequestType
  ) -> EventLoopFuture<RequestType.ResponseType> {
    var sessionRequest: SessionType.RequestType
    do {
      sessionRequest = try session.createRequest(
        request,
        withBaseURL: api.baseURL,
        andHeaders: api.headers,
        usingEncoder: api.encoder
      )
    } catch {
      return session
        .nextEventLoop()
        .makeFailedFuture(ClientError.requestEncodingError(error))
    }

    return session.beginRequest(sessionRequest).flatMapThrowing { response in
      guard let httpStatus = response.statusCode else {
        throw ClientError.invalidResponse
      }
      let data = response.data ?? Data()
      return try RequestType.ResponseType(
        statusCode: httpStatus,
        data: data,
        decoder: self.api.decoder
      )
    }
  }
}
