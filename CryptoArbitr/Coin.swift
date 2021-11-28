//
//  Coin.swift
//  CryptoArbitr
//
//  Created by xubuntus on 28.11.2021.
//

struct Coin: Decodable {
    let id: String
    let symbol: String
    let name: String
    let rank: Int
}

struct Coins: Decodable {
    let data: [Coin]
}

struct Ticker: Decodable {
    var name: String?
    var price_usd: Double?
    var base: String?
    var quote: String?
}

struct Tickers: Decodable {
    let tickers: [Ticker]
    
    var tickerWithMinPrice: Ticker {
        tickers.min(by: {$0.price_usd ?? 0 < $1.price_usd ?? 0}) ?? Ticker()
    }
    
    var tickerWithMaxPrice: Ticker {
        tickers.max(by: {$0.price_usd ?? 0 < $1.price_usd ?? 0}) ?? Ticker()
    }
    
    var benefit: Double {
        ((tickerWithMaxPrice.price_usd ?? 0) - (tickerWithMinPrice.price_usd ?? 0)) * 100 / (tickerWithMinPrice.price_usd ?? 1)
    }
}

struct Arbitration {
    let tickerWithMinPrice, tickerWithMaxPrice: Ticker
    
    let benefit: Double
}
