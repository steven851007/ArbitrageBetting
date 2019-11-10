//
//  OddsAPINetworkHandler.swift
//  ArbitrageBetting
//
//  Created by Istvan Private on 30.10.19.
//  Copyright © 2019 Balogh István. All rights reserved.
//

import Foundation



class OddsAPINetworkHandler {
    
    let urlString = "https://app.oddsapi.io/api/v1/odds"
    let parameters = ["sport": "soccer"]
    var coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    
    func fetchLatestEvents(completion: @escaping ([OddsAPIResponseObject]?, Error?) -> Void) {
        var components = URLComponents(string: self.urlString)!
        components.queryItems = self.parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        var request = URLRequest(url: components.url!)
        request.setValue("720e3a60-ec48-11e9-aa5a-7de85876d229", forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise ...
                    completion(nil, error)
                    return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            let responseObjects: [OddsAPIResponseObject] = try! decoder.decode([OddsAPIResponseObject].self, from: data)
            DispatchQueue.main.async {
                self.coreDataStack.syncronizer.updateWith(responseObjects: responseObjects)
            }
            completion(responseObjects, nil)
        }
        task.resume()
    }
}
