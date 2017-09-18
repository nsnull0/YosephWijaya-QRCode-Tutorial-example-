//
//  InformationRegisteredProductViewController.swift
//  CarPrice_Barcode
//
//  Created by Yoseph Wijaya on 2017/09/18.
//  Copyright © 2017 Yoseph Wijaya. All rights reserved.
//

import UIKit

class InformationRegisteredProductViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    lazy var productList:Array = Array<QRData>()
    lazy var qrCodeModelView:QRCodeModelVIew = QRCodeModelVIew()
    static var tableIdentifier = "QRListTable"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        productList = qrCodeModelView.getQRData()
        tableView.reloadData()
    }
    
}

extension InformationRegisteredProductViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CellProductInformationView = tableView.dequeueReusableCell(withIdentifier: InformationRegisteredProductViewController.tableIdentifier)! as! CellProductInformationView
        
        cell.nameLabel.text = ": \(productList[indexPath.row].name)"
        cell.qrCodeLabel.text = ": \(productList[indexPath.row].qrcode)"
        cell.priceLabel.text = ": \(productList[indexPath.row].price)"
        cell.quantityLabel.text = ": \(productList[indexPath.row].quantity)"
        cell.QualityLabel.text = ": \(productList[indexPath.row].quality)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
