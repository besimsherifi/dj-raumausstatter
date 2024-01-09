//
//  PrintInputs.swift
//  Dj Raumausstatter
//
//  Created by besim on 08/01/2024.
//

import SwiftUI
import PDFKit
import Firebase
import FirebaseFirestoreSwift


struct PrintInputs: View {
    
    @Binding var customerNumber: String
    @Binding var invoiceNumber: String
    @Binding var invoiceDate: String
    @Binding var jobDate: String
    @Binding var costCentre: String
    @Binding var address: String
    @Binding var docType: String
    var total: Double
    var vat: Double
    var totalAmount: Double
    var tableContent: [[String]]
    
    let db = Firestore.firestore()
    
    
    
    @MainActor
    func saveToFirebase() async {
        let invoice = Invoice(
            id: nil,
            customerNumber: customerNumber,
            invoiceNumber: invoiceNumber,
            invoiceDate: invoiceDate,
            jobDate: jobDate,
            costCentre: costCentre,
            address: address,
            docType: docType,
            total: total,
            vat: vat,
            totalAmount: totalAmount,
            tableContent: tableContent.map { row in
                Item(position: row[0], leistung: row[1], menge: row[2], me: row[3], einzelpreis: row[4], gesamtpreis: row[5])
            }
        )
        
        do {
            _ = try await db.collection("invoices").addDocument(from: invoice)
            print("Document successfully added to Firestore!")
        } catch {
            print("Error adding document to Firestore: \(error)")
        }
    }
    
    
    
    @MainActor
    private func generatePDF() -> Data{
        let pdfRenderer =  UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))
        
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            
            
            //HEADER
            //left
            alignText(value: "K.& K.Hollenbach GmbH & Co.KG", x: 10, y: 90, width: 295, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .semibold))
            
            alignText(value: "Asbrookdamm 44", x: 10, y: 100, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .semibold))
            
            alignText(value: "22115 Hamburg", x: 10, y: 110, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .semibold))
            
            
            //right
            alignText(value: "Inh. Jahi Dzeladini", x: -10, y: 80, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .semibold))
            
            alignText(value: "Wientapperweg 20", x: -10, y: 90, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .semibold))
            
            alignText(value: "22589 Hamburg", x: -10, y: 100, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .semibold))
            
            
            
            alignText(value: "Tel.: 0162 61 41 734", x: -10, y: 120, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .semibold))
            
            alignText(value: "Fax: 040 63 73 21 72", x: -10, y: 130, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .semibold))
            
            alignText(value: "E-Mail: giannidz@hotmail.de", x: -10, y: 140, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .semibold))
            
            
            
            //MIDDLE PART
            //left
            
            alignText(value: docType, x: 10, y: 190, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 14, weight: .medium))
            
            alignText(value: "Kunden-Nr.:", x: 10, y: 210, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 12, weight: .regular))
            alignText(value: customerNumber, x: 80, y: 210, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 12, weight: .regular))
            alignText(value: "Rechnung-Nr.:", x: 10, y: 225, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 12, weight: .regular))
            alignText(value: invoiceNumber, x: 95, y: 225, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 12, weight: .regular))
            alignText(value: "Bitte bei Zahlungen und Schriftverkehr angeben!", x: 10, y: 240, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .thin))
            
            
            //right
            alignText(value: "Rechnungsdatum:", x: -75, y: 210, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 12, weight: .regular))
            alignText(value: invoiceDate, x: -10, y: 210, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "Leistungsdatum:", x: -82, y: 222, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 12, weight: .regular))
            alignText(value: jobDate, x: -10, y: 222, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "Kostenstelle:", x: -100, y: 237, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 12, weight: .regular))
            alignText(value: costCentre, x: -10, y: 237, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 8, weight: .regular))
            
            
            alignText(value: "BV:", x: 10, y: 270, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .bold))
            alignText(value: address, x: 30, y: 270, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .bold))
            
            //TABLE
            alignText(value: "Pos", x: 25, y: 320, width: 40, height: 20, alignment: .center, textFont: UIFont.systemFont(ofSize: 12, weight: .bold))
            alignText(value: "Leistung", x: 50, y: 320, width: 160, height: 20, alignment: .center, textFont: UIFont.systemFont(ofSize: 12, weight: .bold))
            alignText(value: "Menge", x: 180, y: 320, width: 60, height: 20, alignment: .center, textFont: UIFont.systemFont(ofSize: 12, weight: .bold))
            alignText(value: "ME", x: 260, y: 320, width: 50, height: 20, alignment: .center, textFont: UIFont.systemFont(ofSize: 12, weight: .bold))
            alignText(value: "Einzelpreis", x: 320, y: 320, width: 90, height: 20, alignment: .center, textFont: UIFont.systemFont(ofSize: 12, weight: .bold))
            alignText(value: "Gesamtpreis", x: 410, y: 320, width: 90, height: 20, alignment: .center, textFont: UIFont.systemFont(ofSize: 12, weight: .bold))
            
            
            
            alignText(value: "Nettosumme:", x: 10, y: 530, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .bold))
            alignText(value: String(total) + "€", x: -10, y: 530, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .bold))
            
            
            
            alignText(value: "Umsatzsteuer:", x: 10, y: 540, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "19 %", x: -10, y: 540, width: 595, height: 150, alignment: .center, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: String(vat) + "€", x: -10, y: 540, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            
            
            alignText(value: "Gesamtsumme:", x: 10, y: 550, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .bold))
            alignText(value: String(totalAmount) + "€", x: -10, y: 550, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .bold))
            
            
            
            
            
            //FOOTER
            alignText(value: "Der Gesamtbetrag ist ab Erhalt dieser Rechnung zahlbar innerhalb 14 Tage. 3% skonto 21 T.netto", x: 10, y: 700, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            
            
            
            alignText(value: "D.J. Raumausstatter", x: 10, y: 740, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "Inh. Jahi Dzeladini", x: 10, y: 750, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "Wientapperweg 20", x: 10, y: 760, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "22589 Hamburg", x: 10, y: 770, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            
            
            
            alignText(value: "COMMERZBANK", x: -10, y: 740, width: 595, height: 150, alignment: .center, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "IBAN: DE53 2004 0000 0035 5919 00", x: -10, y: 750, width: 595, height: 150, alignment: .center, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "BIC: COBADEFFXXX", x: -10, y: 760, width: 595, height: 150, alignment: .center, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "KTO: Inh.: Jahi Dzeladini", x: -10, y: 770, width: 595, height: 150, alignment: .center, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            
            
            
            alignText(value: "Steuer-Nr.: 42/051/03622", x: -10, y: 740, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            alignText(value: "Finanzamt Hamburg - Am Tierpark", x: -10, y: 750, width: 595, height: 150, alignment: .right, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
            
            
            alignText(value: "Gemäß § 13b Abs. 2 Nr. 4 UStG gilt die „Steuerschuldnerschaft des Leistungsempfängers“", x: 10, y: 790, width: 595, height: 150, alignment: .left, textFont: UIFont.systemFont(ofSize: 8, weight: .bold))
            
            //            let tableContent = [
            //                       ["1", "Service A", "2", "hrs", "50.00", "100.00"],
            //                       ["2", "Service B", "1", "unit", "75.00", "75.00"],
            //                       ["3", "Service C", "3", "hrs", "30.00", "90.00"]
            //                   ]
            for (rowIndex, row) in tableContent.enumerated() {
                for (columnIndex, cell) in row.enumerated() {
                    let xCoordinate = 10 + (columnIndex * 80)
                    let yCoordinate = 350 + (rowIndex * 20)
                    let cellWidth = 80
                    let cellHeight = 20
                    
                    alignText(value: cell, x: xCoordinate, y: yCoordinate, width: cellWidth, height: cellHeight, alignment: .center, textFont: UIFont.systemFont(ofSize: 10, weight: .regular))
                }
            }
            
            let globalIcon = UIImage(named: "logo")
            let globalIconRect = CGRect(x: 1, y: 5, width: 190, height: 60)
            globalIcon!.draw(in: globalIconRect)
        }
        return data
    }
    
    func alignText(value: String, x:Int, y:Int, width:Int, height: Int, alignment: NSTextAlignment, textFont: UIFont){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        
        let atributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let textRect = CGRect(x: x, y: y, width: width, height: height)
        value.draw(in: textRect, withAttributes: atributes)
    }
    
    @MainActor
//    func savePDF(){
//        let fileName = "Document.pdf"
//        let pdfData = generatePDF()
//
//        if let documentDirect = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
//            let documentURL = documentDirect.appendingPathComponent(fileName)
//            do{
//                try pdfData.write(to: documentURL)
//                print(documentURL)
//            }catch{
//                print(error)
//            }
//        }
//    }
    func savePDF() {
           let fileName = "Document.pdf"
           let pdfData = generatePDF()
           let pdfURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileName)
           try? pdfData.write(to: pdfURL!)

           let activityViewController = UIActivityViewController(activityItems: [pdfURL!], applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
       }
    
    var body: some View{
        VStack{
            PDFKitView(pdfData: PDFDocument(data: generatePDF())!)
            Button(action: {
                Task {
                    await saveToFirebase()
                }
                savePDF()
            }, label: {
                Text("Speichern")
            })
        }
    }
}

//#Preview {
//    PrintInputs()
//}
