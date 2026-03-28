//
//  APIClient.swift
//  CourseGrab
//
//  Created by jiwon jeong on 3/27/26.
//

import Foundation

protocol APIClient {
    func get<T: Decodable>(url: URL, attempt: Int) async throws -> T
    func post<T: Decodable, U: Encodable>(url: URL, body: U, attempt: Int) async throws -> T
    func post<U: Encodable>(url: URL, body: U, attempt: Int) async throws
    func post<T: Decodable>(url: URL, attempt: Int) async throws -> T
    func delete(url: URL, attempt: Int) async throws
}
