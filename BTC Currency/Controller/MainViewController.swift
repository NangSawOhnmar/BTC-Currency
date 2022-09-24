//
//  ViewController.swift
//  BTC Currency
//
//  Created by nang saw on 23/09/2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet weak var selectCurrencyButton: UIButton!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var updatedTimeLabel: UILabel!
    @IBOutlet weak var bitcoinTextField: UITextField!
    @IBOutlet weak var currencyRateTextField: UITextField!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var currencyLabel: UILabel!
    private var request: Requests!
    private var timer: Timer!
    var selected_currency: Currency!
    var BPI: BitcoinPrice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "BTC Currency"
        request = Requests()
        setupView()
        getBPI(complete: {
            self.saveBPI(bitcoin_price: self.BPI)
        })
        updateBPI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selected_currency = Currency.USD
        currencyLabel.text = Currency.USD.rawValue
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        timer = nil
    }
    
    func setupView(){
        selectCurrencyButton.layer.cornerRadius = 5
        selectCurrencyButton.layer.shadowColor = UIColor.black.cgColor
        selectCurrencyButton.layer.shadowOffset = .zero
        selectCurrencyButton.layer.shadowRadius = 5.0
        selectCurrencyButton.layer.shadowOpacity = 0.1
        selectCurrencyButton.layer.masksToBounds = false
        historyTableView.dataSource = self
        historyTableView.delegate = self
        bitcoinTextField.delegate = self
        currencyRateTextField.delegate = self
    }
    
    func configureCurrencyButton(){
        let alertController = UIAlertController(title: "Select Your Currency", message: "", preferredStyle: .actionSheet)
        let USD = UIAlertAction(title: "USD", style: .default) { _ in
            self.selectedCurrency(currency: Currency.USD)
        }
        let GBP = UIAlertAction(title: "GBP", style: .default) { _ in
            self.selectedCurrency(currency: Currency.GBP)
        }
        let EUR = UIAlertAction(title: "EUR", style: .default) { _ in
            self.selectedCurrency(currency: Currency.EUR)
        }
        alertController.addAction(USD)
        alertController.addAction(GBP)
        alertController.addAction(EUR)
        self.present(alertController, animated: true)
    }
    
    private func getBPI(complete: @escaping () -> Void){
        request.getBPI(success: { json in
            self.BPI = BitcoinPrice.loadJSON(json: json)
            DispatchQueue.main.async {
                self.showUpdatedPrice(bitcoin_price: self.BPI)
                self.historyTableView.reloadData()
            }
            complete()
        }, fail: { error in
            print(ErrorResponse.loadJSON(json: error))
        })
    }
    
    func saveBPI(bitcoin_price: BitcoinPrice){
        let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
        let btc = NSEntityDescription.insertNewObject(forEntityName: "BTC", into: context) as! BTC
        btc.creationDate = Date()
        btc.updatedTime = bitcoin_price.time.updated
        btc.updatedISO = bitcoin_price.time.updatedISO
        btc.updateduk = bitcoin_price.time.updateduk
        btc.chartName = bitcoin_price.chartName
        btc.usd_rate = bitcoin_price.bpi.USD.rate
        btc.gbp_rate = bitcoin_price.bpi.GBP.rate
        btc.eur_rate = bitcoin_price.bpi.EUR.rate
        do {
            try context.save()
            print("successfully saved")
        } catch {
            print("Could not save")
        }
    }
    
    func fetch() -> [BTC] {
        var btcData = [BTC]()
        let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<BTC>(entityName: "BTC")
        let sort = NSSortDescriptor(key: #keyPath(BTC.updatedTime), ascending: false)
            fetchRequest.sortDescriptors = [sort]
            do {
               btcData = try context.fetch(fetchRequest)
            } catch {
                print("Cannot fetch Expenses")
            }
        return btcData
    }
    
    func clearData(){
        var objects = [BTC]()
        let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<BTC>(entityName: "BTC")
        do{
            objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            DispatchQueue.main.async {
                self.historyTableView.reloadData()
            }
            print("successfully delete")
        } catch {
            print("Could not delete")
        }
    }
    
    func updateBPI(){
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true, block: { (_) in
            self.getBPI(complete: {
                self.saveBPI(bitcoin_price: self.BPI)
            })
        })
    }
    
    private func selectedCurrency(currency: Currency){
        self.selectCurrencyButton.setTitle(currency.rawValue, for: .normal)
        self.currencyLabel.text = currency.rawValue
        self.selected_currency = currency
        currencyRateTextField.text = calculateBtcToCurrencyRate(coin: bitcoinTextField.text ?? "")
        bitcoinTextField.text = calculateCurrencyRateToBtc(rate: currencyRateTextField.text ?? "")
        self.getBPI(complete: {  })
    }
    
    func showUpdatedPrice(bitcoin_price: BitcoinPrice){
        self.updatedTimeLabel.text = Helper.stringToTimeAndDate(date: bitcoin_price.time.updatedISO)
        switch selected_currency{
        case .USD:
            self.rateLabel.text = "\(bitcoin_price.bpi.USD.rate ?? "") USD"
        case .GBP:
            self.rateLabel.text = "\(bitcoin_price.bpi.GBP.rate ?? "") GBP"
        case .EUR:
            self.rateLabel.text = "\(bitcoin_price.bpi.EUR.rate ?? "") EUR"
        default:
            break
        }
    }
    
    func calculateBtcToCurrencyRate(coin: String) -> String{
        let coin_float = Float(coin) ?? 0.0
        switch selected_currency{
        case .USD:
            return String(coin_float*self.BPI.bpi.USD.rate_float)
        case .GBP:
            return String(coin_float*self.BPI.bpi.GBP.rate_float)
        case .EUR:
            return String(coin_float*self.BPI.bpi.EUR.rate_float)
        default:
            return ""
        }
    }
    
    func calculateCurrencyRateToBtc(rate: String) -> String{
        let rate_float = Float(rate) ?? 0.0
        switch selected_currency{
        case .USD:
            return String(rate_float/self.BPI.bpi.USD.rate_float)
        case .GBP:
            return String(rate_float/self.BPI.bpi.GBP.rate_float)
        case .EUR:
            return String(rate_float/self.BPI.bpi.EUR.rate_float)
        default:
            return ""
        }
    }
    
    @IBAction func tappedSelectCurrencyButton(_ sender: Any) {
        configureCurrencyButton()
    }
    
    @IBAction func tappedClearDataButton (_ sender: Any) {
        clearData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return fetch().count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: BTCHistoryTitleTableViewCell.IDENTIFIER, for: indexPath) as? BTCHistoryTitleTableViewCell{
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: BTCHistoryTableViewCell.IDENTIFIER, for: indexPath) as? BTCHistoryTableViewCell{
                let btc = fetch()[indexPath.item]
                switch selected_currency{
                case .USD:
                    cell.priceRateLabel.text = "\(btc.usd_rate ?? "") USD"
                case .GBP:
                    cell.priceRateLabel.text = "\(btc.gbp_rate ?? "") GBP"
                case .EUR:
                    cell.priceRateLabel.text = "\(btc.eur_rate ?? "") EUR"
                default:
                    break
                }
                cell.timeLabel.text = Helper.stringToTimeAndDate(date: btc.updatedISO ?? "")
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 20
        case 1:
            return 30
        default:
            return 0
        }
    }
}

extension MainViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == bitcoinTextField{
            currencyRateTextField.text = calculateBtcToCurrencyRate(coin: textField.text ?? "")
            print("bitcoinTextField")
        }else if textField == currencyRateTextField{
            bitcoinTextField.text = calculateCurrencyRateToBtc(rate: textField.text ?? "")
            print("currencyRateTextField")
        }
    }
}
