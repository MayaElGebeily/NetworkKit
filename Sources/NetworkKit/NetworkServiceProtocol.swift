//
//  NetworkServiceProtocol.swift
//  NetworkKit
//
//  Created by Maya El Gebeily on 12/08/2026.
//

import Foundation
//T to be loosely coupled so i can try diff types of services (mock , real , etc)
public protocol NetworkServiceProtocol {
    func request<T:Decodable>(_ endpoint: NetworkEndpoint , baseURL: URL, responseType:T.Type) async throws -> T
    func requestWithoutResponse(_ endpoint: NetworkEndpoint , baseURL: URL) async throws
}
