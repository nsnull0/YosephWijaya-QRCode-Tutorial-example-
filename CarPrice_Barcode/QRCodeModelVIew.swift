//
//  QRCodeModelVIew.swift
//  CarPrice_Barcode
//
//  Created by Yoseph Wijaya on 2017/09/16.
//  Copyright © 2017 Yoseph Wijaya. All rights reserved.
//

import UIKit
import CoreData

public struct QRData {
    var name:String = "Unknown"
    var qrcode:String = "Unknown"
    var price:String = "Unknown"
    var quantity:String = "Unknown"
    var quality:String = "Unknown"
    
    static func notDetectedType() -> QRData{
        var qrData:QRData = QRData()
        qrData.qrcode = "Not Found"
        return qrData
    }
    
}



class QRCodeModelVIew {
     
    
    private var databaseContext : NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }()
    
    
    func saveDataProduct(_ data:QRData) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Product_item", in: self.databaseContext)
        
        let productObj:Product_item = Product_item(entity: entity!, insertInto: self.databaseContext)
        
        productObj.name = data.name
        productObj.price = data.price
        productObj.qrcode = data.qrcode
        productObj.quality = Int64(data.quality)!
        productObj.quantity = Int64(data.quantity)!
        
        return self.saveData()
    }
    
    private func saveData() -> Bool {
        do{
            if databaseContext.hasChanges {
                try databaseContext.save()
                return true
            }else{
                return false
            }
            
        }catch{
            let errorC = error as NSError
            print("Unresolved error \(errorC) - \(errorC.userInfo)")
            return false
        }
    }
    
    func getQRData() -> [QRData] {
        let productFetch:NSFetchRequest<Product_item> = NSFetchRequest<Product_item>(entityName: "Product_item")
        var productResult:Array = Array<QRData>()
        do {
            let fetchedProduct = try databaseContext.fetch(productFetch)
            
            guard fetchedProduct.count > 0 else {
                return []
            }
            
            for data:Product_item in fetchedProduct {
                let resultQRData:QRData = QRData(name: data.name!, qrcode: data.qrcode!
                    , price: "\(data.price!)", quantity: "\(data.quantity)"
                    , quality: "\(data.quality)")
                productResult.append(resultQRData)
            }
            
            
            
            return productResult
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func getQRData(qrCode:String) -> QRData {
        guard qrCode.characters.count > 0 else {
            return QRData()
        }
        
        let productFetch:NSFetchRequest<Product_item> = NSFetchRequest<Product_item>(entityName: "Product_item")
        productFetch.predicate = NSPredicate(format: " qrcode == %@", qrCode)
        
        do {
            let fetchedProduct = try databaseContext.fetch(productFetch)
            
            guard fetchedProduct.count > 0 else {
                return QRData()
            }
            
            let resultQRData:QRData = QRData(name: fetchedProduct.last!.name!, qrcode: fetchedProduct.last!.qrcode!
                , price: "\(fetchedProduct.last!.price!)", quantity: "\(fetchedProduct.last!.quantity)"
                , quality: "\(fetchedProduct.last!.quality)")
            
            return resultQRData
        } catch {
            print("\(error)")
            return QRData()
        }
        
    }
    
}
