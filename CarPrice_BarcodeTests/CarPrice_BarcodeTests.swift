//
//  CarPrice_BarcodeTests.swift
//  CarPrice_BarcodeTests
//
//  Created by Yoseph Wijaya on 2017/09/16.
//  Copyright © 2017 Yoseph Wijaya. All rights reserved.
//

import XCTest
@testable import CarPrice_Barcode

class CarPrice_BarcodeTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchDataProduct() {
        
        let QRCodeModel:QRCodeModelVIew = QRCodeModelVIew()
        
        let dataProduct:QRData = QRData(name: "lalala", qrcode: "1234567890"
            , price: "80000", quantity: "1", quality:"3")
        
        
        XCTAssertEqual([dataProduct.name, dataProduct.qrcode, dataProduct.price, dataProduct.quantity, dataProduct.quality], ["lalala", "1234567890", "80000", "1", "3"])
        
        let saved:Bool = QRCodeModel.saveDataProduct(dataProduct)
        
        XCTAssertTrue(saved)
        
        var dataProductEmpty:QRData = QRData()
        
        XCTAssertNotEqual([dataProductEmpty.name], ["lalala"])
        
        dataProductEmpty = QRCodeModel.getQRData(qrCode: "1234567890")
        
        XCTAssertEqual([dataProductEmpty.name, dataProductEmpty.qrcode, dataProductEmpty.price, dataProductEmpty.quantity, dataProduct.quality], ["lalala", "1234567890", "80000", "1", "3"])
    }
    
}
