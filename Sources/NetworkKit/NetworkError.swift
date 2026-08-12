//
//  NetworkError.swift
//  NetworkKit
//
//  Created by Maya El Gebeily on 12/08/2026.
//
import Foundation
enum NetworkError : Error {
    case invalidURL
    case decodingFailed(Error)
    case requestFailed(Error)
    case serverError(statusCode:Int)
    case unknown
}

