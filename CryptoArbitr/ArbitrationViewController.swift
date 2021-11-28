//
//  ArbitrationViewController.swift
//  CryptoArbitr
//
//  Created by xubuntus on 28.11.2021.
//

import UIKit

class ArbitrationViewController: UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var stack: UIStackView!
    
    @IBOutlet var exchangeMin: UILabel!
    @IBOutlet var priceMin: UILabel!
    @IBOutlet var exchangeMax: UILabel!
    @IBOutlet var priceMax: UILabel!
    @IBOutlet var benefit: UILabel!
    
    var coin: Coin!
    
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchTickers()
    }
    
    private func fetchTickers() -> Void {
        networkManager.delegate = self
        networkManager.fetchTickers(forCoin: coin)
    }
}

extension ArbitrationViewController: NetworkManagerDelegate {
    func updateUI(with data: Any) {
        guard let tickers = data as? Tickers else { return }
        DispatchQueue.main.async {
            self.stack.isHidden = false
            self.activityIndicator.stopAnimating()
            self.exchangeMin.text = tickers.tickerWithMinPrice.name
            self.exchangeMax.text = tickers.tickerWithMaxPrice.name
            self.priceMin.text = "-\(String(format: "%.02f", tickers.tickerWithMinPrice.price_usd ?? 0))"
            self.priceMax.text = "+\(String(format: "%.02f", tickers.tickerWithMaxPrice.price_usd ?? 0))"
            self.benefit.text = "\(String(format: "%.02f", tickers.benefit)) %"
        }
    }
}
