//
//  NetworkManager.swift
//  CryptoArbitr
//
//  Created by xubuntus on 28.11.2021.
//

import Foundation

protocol NetworkManagerDelegate {
    func updateUI(with data: Any)
}

class NetworkManager {
    var delegate: NetworkManagerDelegate?
    
    private let topCoinsNum = 20
    
    private enum Link: String {
        case coinList = "https://api.coinlore.net/api/tickers/?start=0&limit="
        case coinTickers = "https://api.coinlore.net/api/coin/markets/?id="
    }
 
    func fetchCoinList() {
        var coins = Coins(data: [])
        
        guard let url = URL(string: "\(Link.coinList.rawValue)\(topCoinsNum)") else { return }
        URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data else { return }
            do {
                coins = try JSONDecoder().decode(Coins.self, from: data)
                self.delegate?.updateUI(with: coins)
            } catch {
            }
            
        }.resume()
    }
    
    func fetchTickers(forCoin: Coin) {
        var tickerArray: [Ticker] = []
        let coinId = forCoin.id
        let coinSymbol = forCoin.symbol
        guard let url = URL(string: "\(Link.coinTickers.rawValue)\(coinId)") else { return }
        URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data else { return }
            do {
                tickerArray = try JSONDecoder().decode([Ticker].self, from: data)
                let tickers = Tickers(tickers: tickerArray.filter({$0.name != nil
                    && $0.price_usd != nil
                    && $0.base == coinSymbol
                    && $0.quote == "USDT"}))
                self.delegate?.updateUI(with: tickers)
            } catch {
            }
            
        }.resume()
    }
}
