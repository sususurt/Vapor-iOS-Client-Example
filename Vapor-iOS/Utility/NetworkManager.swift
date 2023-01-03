//
//  NetworkManager.swift
//  Vapor-App
//
//  Created by Ruitong Su on 12/31/22.
//

import Foundation

enum HttpMethods: String {
    case POST, GET, PUT, DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
}

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

final class NetworkManager {
    // MARK: - Singleton
    private init() { }

    static let shared = NetworkManager()

    // MARK: - Http Client

    // fetch array of data
    func fetch<T: Codable>(url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }

        guard let object = try? JSONDecoder().decode([T].self, from: data) else {
            throw HttpError.errorDecodingData
        }

        return object
    }

    // send array of data
    func send<T: Codable>(to url: URL, objects: [T], httpMethod: String) async throws {
        var req = URLRequest(url: url)
        req.httpMethod = httpMethod
        req.addValue(MIMEType.JSON.rawValue,
                     forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        req.httpBody = try? JSONEncoder().encode(objects)

        let (_, response) = try await URLSession.shared.data(for: req)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }

    // send single data
    func send<T: Codable>(to url: URL, object: T, httpMethod: String) async throws {
        var req = URLRequest(url: url)
        req.httpMethod = httpMethod
        req.addValue(MIMEType.JSON.rawValue,
                     forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        req.httpBody = try? JSONEncoder().encode(object)

        let (_, response) = try await URLSession.shared.data(for: req)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }

    // delete
    func delete(at id: UUID, url: URL) async throws {
        var req = URLRequest(url: url)
        req.httpMethod = HttpMethods.DELETE.rawValue

        let (_, response) = try await URLSession.shared.data(for: req)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }
}
