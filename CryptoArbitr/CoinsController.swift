//
//  ViewController.swift
//  CryptoArbitr
//
//  Created by xubuntus on 28.11.2021.
//

import UIKit

class CoinsController: UITableViewController {
    
    private var networkManager = NetworkManager()
    
    private var coins = Coins(data: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCoinList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let arbitrationVC = segue.destination as? ArbitrationViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        arbitrationVC.coin = coins.data[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coins.data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = coins.data[indexPath.row].name
        content.secondaryText = "Rank \(coins.data[indexPath.row].rank)"
        cell.contentConfiguration = content
        return cell
    }

    private func fetchCoinList() -> Void {
        networkManager.delegate = self
        networkManager.fetchCoinList()
    }
}

extension CoinsController: NetworkManagerDelegate {
    func updateUI(with data: Any) {
        guard let coins = data as? Coins else { return }
        self.coins = coins
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

