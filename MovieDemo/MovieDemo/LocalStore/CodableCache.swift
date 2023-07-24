//
//  CodableCache.swift
//  MovieDemo
//
//  Created by Oscar Vernis on 14/07/23.
//  Copyright © 2023 Oscar Vernis. All rights reserved.
//

import Foundation

struct CodableCache<Model: Codable>: ModelCache {
    enum CacheType {
        case json
        case propertyList
        
        var fileExtension: String {
            switch self {
            case .json:
                return "json"
            case .propertyList:
                return "bplist"
            }
        }
    }
    
    private let dir: URL
    private let filePath: URL
    private let cacheType: CacheType
    
    static var cacheDir: URL {
        let cacheDir = URL.cachesDirectory
        return cacheDir.appending(path: "cache.oscarvernis.MovieDemo")
    }
    
    init(filename: String, dir: URL = cacheDir, type: CacheType = .propertyList) {
        self.filePath = dir.appending(path: filename).appendingPathExtension(type.fileExtension)
        self.dir = dir
        self.cacheType = type
    }
        
    func load() throws -> Model {
        let data = try Data(contentsOf: filePath)
        
        let model: Model
        switch cacheType {
        case .json:
            model = try JSONDecoder().decode(Model.self, from: data)
        case .propertyList:
            model = try PropertyListDecoder().decode(Model.self, from: data)
        }
        
        return model
    }
    
    func save(_ model: Model) {
        do {
            try FileManager.default.createDirectory(at: CodableCache.cacheDir, withIntermediateDirectories: true)

            let data: Data
            switch cacheType {
            case .json:
                data = try JSONEncoder().encode(model)
            case .propertyList:
                data = try PropertyListEncoder().encode(model)
            }
            
            try data.write(to: filePath)
        } catch {
            print(error)
        }
    }
    
    func delete() {
        try? FileManager.default.removeItem(at: filePath)
    }
    
}
