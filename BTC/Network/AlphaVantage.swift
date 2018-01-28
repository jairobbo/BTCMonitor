//
//  AlphaVantage.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 25-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import Foundation

class AlphaVantage {
    
    var isReversed = true
    
    func getBTCData(completion: @escaping (GraphModel?)->Void) {
        let session = URLSession(configuration: .default)
        let urlComp = createURLComp()
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                guard let inputData = self.parseBTCData(data: data) else { completion(nil); return }
                completion(GraphModel(data: inputData))
            }
        }
        task.resume()
    }
    
    func createURLComp() -> URLComponents {
        var urlComp = URLComponents()
        urlComp.scheme = "https"
        urlComp.host = "www.alphavantage.co"
        urlComp.path = "/query"
        let queryItemFunction = URLQueryItem(name: "function", value: "DIGITAL_CURRENCY_DAILY")
        let queryItemSymbol = URLQueryItem(name: "symbol", value: "BTC")
        let queryItemMarket = URLQueryItem(name: "market", value: "USD")
        let queryItemAPIKey = URLQueryItem(name: "apikey", value: "SJPBBELA5U98CJJE")
        urlComp.queryItems = [queryItemFunction, queryItemSymbol, queryItemMarket, queryItemAPIKey]
        return urlComp
    }
    
    func parseBTCData(data: Data?) -> [(date: String, value: Double)]? {
        guard let data = data else { return nil }
        do {
            var values: [(String, Double)] = []
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let btcValues = json?["Time Series (Digital Currency Daily)"] as? [String: Any]
            var dates = createDates()
            if isReversed {
                dates = dates.reversed()
            }
            for date in dates {
                let entry = btcValues?[date] as? [String: String]
                let btcValueString = entry?["4b. close (USD)"] ?? ""
                let btcValue = (btcValueString as NSString).doubleValue
                values.append((date, btcValue))
            }
            return values
        } catch {
            print(error)
            return nil
        }
        
    }
    
    func createDates() -> [String] {
        var dates: [String] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        for i in 1..<366 {
            let date = calendar.date(byAdding: .day, value: -i, to: Date())
            let dateString = dateFormatter.string(from: date ?? Date())
            dates.append(dateString)
        }
        return dates
    }
}








