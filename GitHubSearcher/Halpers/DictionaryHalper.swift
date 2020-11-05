//
//  DictionaryHalper.swift
//  GitHubSearcher
//
//  Created by admin on 05.11.2020.
//

import Foundation

class DictionaryHalper{
    static func convertToDictionary(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
