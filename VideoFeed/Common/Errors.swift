//
//  Errors.swift
//  VideoFeed
//
//  Created by Manh Nguyen on 10/1/25.
//

enum APIError : Error {
    case InvalidDataFormat
    case InvalidURL
    case DownloadVideoError
    case InvalidResponse(statusCode: Int)
}
