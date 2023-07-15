//
//  CodableCache.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

struct CodableCache<Model: Codable>: ModelCache {
    private let dir: URL
    private let filename: String
    
    static var cacheDir: URL {
        let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return cacheDir.appending(path: "cache.oscarvernis.MovieDemo")
    }
    
    init(filename: String, dir: URL? = cacheDir) {
        self.filename = filename
        self.dir = dir!
    }
    
    func load() throws -> Model {
        let filename = dir.appending(path: filename)
        let data = try Data(contentsOf: filename)
        let model = try JSONDecoder().decode(Model.self, from: data)
        
        return model
    }
    
    func save(_ model: Model) {
        let filename = dir.appending(path: filename)
        do {
            try FileManager.default.createDirectory(at: CodableCache.cacheDir, withIntermediateDirectories: true)
            
            let data = try JSONEncoder().encode(model)
            try data.write(to: filename)
        } catch {
            print(error)
        }
    }
    
    func delete() {
        let filename = dir.appending(path: filename)
        try? FileManager.default.removeItem(at: filename)
    }
    
}
