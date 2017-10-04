//
//  ViewController.swift
//  Bitcoin-Currency
//
//  Created by Arul on 10/2/17.
//  Copyright © 2017 69 Rising. All rights reserved.
//

import UIKit
import Alamofire // Using Alamofire for HTTP request
import SwiftyJSON // Using SwiftyJSON for parsing the data from API in JSON format
import ProgressHUD // Using ProgressHUD for showing alert that indicate successfull

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: - Declare Currency ID and Currency Symbol
    /***************************************************************/
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol  = ["$","R$","$","¥","€","£","$","Rp", "₪","₹","¥","$","kr","$","zł","lei","₽","kr","$","$","R"]
    
    //MARK: - Declare Bitcoin Base URL (apiv2.bitcoinaverage.com) and FINAL URL
    /***************************************************************/
    
    var bitcoinBaseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var bitcoinFinalURL = ""
    var currencySymbolSelected = ""
    
    //MARK: - UI Outlets
    /***************************************************************/
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dataCurrencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataCurrencyPicker.delegate = self
        dataCurrencyPicker.dataSource = self
    }
    
    //MARK: - Construct the shape of UIPickerView (components, rows, title for row and if user selected particular row)
    /***************************************************************/
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bitcoinFinalURL = bitcoinBaseURL + currencyArray[row]
        currencySymbolSelected = currencySymbol[row]
        getBitcoinCurrency(url: bitcoinFinalURL)
    }
    
    //MARK: - Request data from API URL using Alamofire
    /***************************************************************/
    
    func getBitcoinCurrency(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success !")
                let currencyDataJSON : JSON = JSON(response.result.value!)
                self.updateUI(json: currencyDataJSON)
            } else {
                print(String(describing: response.result.error!))
                print("Connection Issues !")
            }
        }
    }
    
    //MARK: - Request data from API URL using Alamofire
    /***************************************************************/
    
    func updateUI(json: JSON) {
        if let getResult = json["ask"].double {
            ProgressHUD.showSuccess("Success")
            priceLabel.text = "\(currencySymbolSelected) \(getResult)"
        } else {
            ProgressHUD.showError("Currency Unavailable!")
            priceLabel.text = "Currency Unavailable!"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

