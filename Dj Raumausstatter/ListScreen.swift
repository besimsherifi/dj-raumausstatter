//
//  ListScreen.swift
//  Dj Raumausstatter
//
//  Created by besim on 02/01/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListScreen: View {
    
    @State private var invoices: [Invoice] = []
    private let db = Firestore.firestore()
    
    
    private func fetchInvoices() {
        db.collection("invoices").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            invoices = documents.compactMap { queryDocumentSnapshot in
                do {
                    return try queryDocumentSnapshot.data(as: Invoice.self)
                } catch {
                    print("Error decoding invoice: \(error.localizedDescription)")
                    return nil
                }
            }
        }
    }
    
    
    var body: some View {
        NavigationView {
            List(invoices, id: \.address) { invoice in
                   NavigationLink(destination: InvoiceDetailsView(invoice: invoice)) {
                       HStack {
                           VStack(alignment: .leading) {
                               Text("\(invoice.docType )")
                               Text(invoice.address)
                                   .font(.system(size: 10))
                                   .foregroundColor(.gray)
                           }
                           Spacer()
                           Text(invoice.jobDate)
                               .font(.system(size: 12))
                       }
                   }
               }
            .onAppear {
                fetchInvoices()
                print(invoices)
            }
            .navigationTitle("Rechnungen")
        }
    }
}

struct InvoiceDetailsView: View {
    
    let invoice: Invoice
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    var body: some View {
        VStack {
            Text("\(invoice.docType)")
                .font(.title)
                .padding()
            Text("\(invoice.address)")
                .font(.title3)
            
            
            VStack{
                Text("KundenNr: \(invoice.customerNumber)")
                Text("RechnungNr: \(invoice.invoiceNumber)")
            }
            .padding()
            
            VStack{
                Text("Rechnungsdatum: \(invoice.invoiceDate)")
                Text("Leistungsdatum: \(invoice.jobDate)")
                Text("Kostenstelle: \(invoice.costCentre)")
            }
            .padding()
            
            

            // You can also display the tableContent items
            ForEach(invoice.tableContent, id: \.position) { item in
                Text("\(item.position). \(item.leistung), \(item.menge) * \(item.einzelpreis) = \(item.gesamtpreis)")
                // Add more details as needed
            }
            
            VStack{
                Text("Nettosumme: \(formatter.string(from: NSNumber(value: invoice.total)) ?? "0.00") €")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Umsatzsteuer (19 %): \(formatter.string(from: NSNumber(value: invoice.vat)) ?? "0.00") €")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Gesamtsumme: \(formatter.string(from: NSNumber(value: invoice.totalAmount)) ?? "0.00") €")
                    .font(.title3)
                    .fontWeight(.semibold)
            }.padding()

            Spacer()
        }
        .navigationTitle("Rechnungs-Details")
        .padding()
    }
}





#Preview {
    ListScreen()
}
