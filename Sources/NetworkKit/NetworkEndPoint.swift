//
//  NetworkEndPoint.swift
//  NetworkKit
//
//  Created by Maya El Gebeily on 12/08/2026.
//

import Foundation
public struct NetworkEndpoint{
    public let path : String
    public let method : HttpMethod
    public let headers : [String:String]
    public let body : Data?
    init(path: String, method: HttpMethod, headers: [String : String], body: Data?) {
        self.path = path
        self.method = method
        self.headers = headers
        self.body = body
    }
}
