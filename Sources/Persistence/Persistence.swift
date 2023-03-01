/// This project is my attempt to wrap persistence information into a useable format
/// Basically, after the millionth time creating ApplicationSupport directories, I want something that is faster
///

import Foundation

public struct Persistence {
    struct Location {
        enum LocationError: Error {
            case noLocationNoCreate
        }
        
        var baseURL: URL
        
        static var userApplicationSupport: Self {
            get throws {
                let url = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                return Self(baseURL: url)
            }
        }
        
        static func userApplicationSupport(appending path: String, createIfNeeded: Bool = false) throws -> Self {
            let fullURL: URL
            if #available(macOS 13.0, *) {
                fullURL = try Self.userApplicationSupport.baseURL.appending(path: path)
            } else {
                fullURL = try Self.userApplicationSupport.baseURL.appendingPathComponent(path)
            }
            if !FileManager.default.fileExists(atPath: fullURL.absoluteString) {
                if createIfNeeded == false {
                    throw LocationError.noLocationNoCreate
                }
                
                try FileManager.default.createDirectory(at: fullURL, withIntermediateDirectories: true)
            }
            
            return Self(baseURL: fullURL)
        }
    }
}
