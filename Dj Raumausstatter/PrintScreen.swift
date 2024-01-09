//
//  PrintScreen.swift
//  Dj Raumausstatter
//
//  Created by besim on 02/01/2024.
//

import SwiftUI
import PDFKit
import Firebase
import FirebaseFirestoreSwift


struct PrintScreen: View {
    
    @State private var isActive = false
    @State private var isPresentingPrintInputs = false
    @State private var customerNumber = ""
    @State private var invoiceNumber = ""
    @State private var invoiceDate = ""
    @State private var jobDate = ""
    @State private var costCentre = ""
    @State private var address = ""
    @State private var docType = "ABSCHLAGSRECHNUNG"
    @State private var tableContent: [[String]] = []
    
    private var totalSum: Double {
        tableContent.reduce(0.0) { sum, row in
            guard let quantity = Double(row[2]),
                  let price = Double(row[4]) else {
                return sum
            }
            return sum + (quantity * price)
        }
    }
    
    
    private var vatAmount: Double {
        return totalSum * 0.19
    }
    
    
    private var totalAmount: Double {
        return totalSum + vatAmount
    }
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment:.leading){
                    
                    Picker("Select an option", selection: $docType) {
                        Text("ABSCHLAGSRECHNUNG").tag("ABSCHLAGSRECHNUNG")
                        Text("RECHNUNG").tag("RECHNUNG")
                        Text("ANGEBOT").tag("ANGEBOT")
                    }
                    .pickerStyle(.automatic)
                    .padding(.horizontal,4)
                    
                    
                    
                    
                    TextField("Kunden-Nr", text: $customerNumber)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Rechnung-Nr", text: $invoiceNumber)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Rechnungsdatum", text: $invoiceDate)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Leistungsdatum", text: $jobDate)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Kostenstelle", text: $costCentre)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("BV", text: $address)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    ForEach(tableContent.indices, id: \.self) { index in
                        VStack(alignment: .leading){
                            Text("\(index + 1)")
                            
                            TextField("Leistung", text: $tableContent[index][1])
                                .keyboardType(.default)
                                .textContentType(.none)
                            
                            TextField("Menge", text: $tableContent[index][2])
                                .keyboardType(.numberPad)
                                .textContentType(.none)
                            
                            TextField("ME", text: $tableContent[index][3])
                                .keyboardType(.default)
                                .textContentType(.none)
                            
                            TextField("Einzelpreis", text: $tableContent[index][4])
                                .keyboardType(.decimalPad)
                                .textContentType(.none)
                            
                            TextField("Gesamtpreis", text: Binding(
                                get: {
                                    let quantity = Double(tableContent[index][2]) ?? 0.0
                                    let price = Double(tableContent[index][4]) ?? 0.0
                                    let result = quantity * price
                                    tableContent[index][5] = String(result)
                                    return String(result)
                                },
                                set: { newValue in
                                    // You can optionally update the quantity or price based on newValue
                                    // This is called when the user types in the "Gesamtpreis" TextField
                                }
                            ))
                            .keyboardType(.decimalPad)
                            .textContentType(.none)
                            //                            if let quantity = Double($tableContent[index][2].wrappedValue),
                            //                                                         let price = Double($tableContent[index][4].wrappedValue) {
                            //                                                          let result = quantity * price
                            //                                                          $tableContent[index][5].wrappedValue = String(result)
                            //                                                      }
                        }
                        .padding()
                    }
                    Button(action: {tableContent.append([String(tableContent.count + 1), "", "", "", "", ""]);print(tableContent)}, label: {
                        Image(systemName: "plus")
                    })
                    .padding()
                }
                
                NavigationLink(destination: PrintInputs(customerNumber: $customerNumber, invoiceNumber: $invoiceNumber, invoiceDate: $invoiceDate, jobDate: $jobDate, costCentre: $costCentre, address: $address, docType: $docType, total: totalSum, vat: vatAmount, totalAmount: totalAmount, tableContent: tableContent ), isActive: $isActive) {
                    Button(action: {
                        isActive.toggle()
                    }, label: {
                        Text("Zum Rechnung")
                    })
                }
//                Button(action: {
//                    isPresentingPrintInputs.toggle()
//                }, label: {
//                    Text("Zum Rechnung")
//                })
                
            }
            .navigationBarTitle("Rechnungen", displayMode: .large)
            .sheet(isPresented: $isPresentingPrintInputs, content: {
                PrintInputs(customerNumber: $customerNumber, invoiceNumber: $invoiceNumber, invoiceDate: $invoiceDate, jobDate: $jobDate, costCentre: $costCentre, address: $address, docType: $docType, total: totalSum, vat: vatAmount, totalAmount: totalAmount, tableContent: tableContent )
            })
        }
    }
}





#Preview {
    PrintScreen()
}
