//
//  InvoiceModel.swift
//  Dj Raumausstatter
//
//  Created by besim on 07/01/2024.
//

struct Invoice: Identifiable, Codable {
    var id: String?
    var customerNumber: String
    var invoiceNumber: String
    var invoiceDate: String
    var jobDate: String
    var costCentre: String
    var address: String
    var docType: String
    var total: Double
    var vat: Double
    var totalAmount: Double
    var tableContent: [Item]
}


struct Item: Codable {
    var position: String
    var leistung: String
    var menge: String
    var me: String
    var einzelpreis: String
    var gesamtpreis: String
}
