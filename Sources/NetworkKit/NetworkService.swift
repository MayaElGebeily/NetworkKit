//
//  NetworkService.swift
//  NetworkKit
//
//  Created by Maya El Gebeily on 12/08/2026.
//

import Foundation
//final to avoid extension
public final class NetworkService:NetworkServiceProtocol {
    private let session : URLSession
    
    public init(session: URLSession = .shared){
        self.session = session
    }

    public func request<T:Decodable>(_ endpoint: NetworkEndpoint , baseURL: URL , responseType: T.Type) async throws -> T {
        
        // built the request format like http:api.example.com/users/123
        
        let request = try buildRequest(endpoint , baseURL: baseURL)
        
        let (data,response) = try await performRequest(request)
        try validate(response)
        
        do {
            return try JSONDecoder().decode(T.self , from: data)
        }catch{
            throw NetworkError.decodingFailed(error)
        }
    }
    
    public func requestWithoutResponse(_ endpoint: NetworkEndpoint , baseURL: URL) async throws{
        
        let request = try buildRequest(endpoint , baseURL: baseURL)
        let(_,response) = try await performRequest(request)
        try validate(response)
    }
    
    // FUNCTIONS
    private func buildRequest(_ endPoint: NetworkEndpoint , baseURL: URL ) throws  -> URLRequest{
        guard let url = URL(
            string: endPoint.path,
            relativeTo: baseURL
        ) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.httpBody = endPoint.body
        endPoint.headers.forEach { key , value in
            request.setValue(value , forHTTPHeaderField: key)
            
        }
        if endPoint.body != nil {
            request.setValue(
                "application/json",
                forHTTPHeaderField:"Content-Type"
            )
        }
        return request
    }
    
    private func performRequest(_ request: URLRequest) async throws -> (Data,URLResponse){
        do {
            return try await session.data(for: request)
        }catch{
            throw NetworkError.requestFailed(error)
        }
    }
    
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        guard(200...299).contains(httpResponse.statusCode)else{
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
}
