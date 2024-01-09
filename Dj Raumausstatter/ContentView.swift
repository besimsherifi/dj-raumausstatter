////
////  ContentView.swift
////  Dj Raumausstatter
////
////  Created by besim on 02/01/2024.
////
//
//import SwiftUI
//
//struct ContentView: View {
//    @State private var rooms: [Room] = []
//    @State private var counter: Int = 0
//    @State private var isModalPresented: Bool = false
//    @State private var wallData: WallData?
//
//    var body: some View {
//        VStack {
//            ForEach(rooms, id: \.self) { room in
//                room
////                    .onDeleteWall { wallDataToRemove in
////                        removeWall(wallDataToRemove)
////                    }
//            }
//            Button(action: {
//                addRoom()
//                self.counter += 1
//            }, label: {
//                Text("Zimmer hinzufügen")
//            })
//        }
//        .sheet(isPresented: $isModalPresented) {
//            WallModalView(wallData: $wallData, onAddWall: {
//                addWall()
//            })
//        }
//    }
//
//    private func addRoom() {
//        rooms.append(Room(counter: counter, showModal: { isModalPresented = true }))
//    }
//
//    private func addWall() {
//        if let wallData = wallData {
//            rooms[wallData.roomIndex].addWall(wallData)
//            // Reset wallData to nil after adding it to a room
//            self.wallData = nil
//        }
//    }
//
//    private func removeWall(_ wallDataToRemove: WallData) {
//        rooms[wallDataToRemove.roomIndex].removeWall(wallDataToRemove)
//    }
//}
//
//
//
//struct Room: View, Hashable, Equatable {
//
//    let counter: Int
//    let showModal: () -> Void
//    @State private var walls: [WallData] = []
//
//    static func == (lhs: Room, rhs: Room) -> Bool {
//           return lhs.counter == rhs.counter
//       }
//
//       // Implement the hash(into:) function for Room
//       func hash(into hasher: inout Hasher) {
//           hasher.combine(counter)
//       }
//
//    var body: some View {
//        HStack {
//            Text("Zimmer \(counter)")
//                .font(.title2)
//                .fontWeight(.bold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//
//            Spacer()
//
//            Button(action: {
//                showModal()
//            }, label: {
//                Text("Add a wall")
//            })
//        }
//        .padding()
//        .border(Color.black, width: 1)
//        .contextMenu {
//            ForEach(walls, id: \.self) { wall in
//                Button(action: {
//                    onDeleteWall?(wall)
//                }) {
//                    Text("Remove Wall: \(wall.height) x \(wall.width) - \(wall.numberOfWalls)")
//                }
//            }
//        }
//    }
//
//    func addWall(_ wallData: WallData) {
//        walls.append(wallData)
//    }
//
//    func removeWall(_ wallDataToRemove: WallData) {
//        if let index = walls.firstIndex(of: wallDataToRemove) {
//            walls.remove(at: index)
//        }
//    }
//
//    var onDeleteWall: ((WallData) -> Void)?
//}
//
//struct WallModalView: View {
//    @Binding var wallData: WallData?
//    var onAddWall: () -> Void
//
//    @State private var height: String = ""
//    @State private var width: String = ""
//    @State private var numberOfWalls: String = ""
//
//    var body: some View {
//        VStack {
//            Text("Add a Wall")
//                .font(.title2)
//
//            Text("Description goes here.")
//
//            TextField("Height", text: $height)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.decimalPad)
//
//            TextField("Width", text: $width)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.decimalPad)
//
//            TextField("Number of Walls (optional)", text: $numberOfWalls)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .keyboardType(.numberPad)
//            Button(action: { print("Test")}, label: {
//                Text("Button")
//            })
//            Button("Add Wadasdall") {
//                print("Test")
//                let newWallData = WallData(
//                    roomIndex: 0,  // Provide the index of the room you want to add the wall to
//                    height: height, width: width, numberOfWalls: numberOfWalls
//                )
//                wallData = newWallData
//                onAddWall()
//
//            }
//
//            Spacer()
//
//            Button("Close") {
//                // Close the modal
//            }
//        }
//        .padding()
//    }
//}
//
//struct WallData: Equatable, Hashable {
//    let roomIndex: Int
//    let height: String
//    let width: String
//    let numberOfWalls: String
//}
//
//
//#Preview {
//    ContentView()
//}





import SwiftUI

struct ContentView: View {
    @State private var rooms: [Room] = [Room()]
    @State private var total: String = "0"
    
    func totalArea(rooms: [Room]) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.roundingMode = .halfUp
        
        let totalArea = rooms.reduce(0) { $0 + $1.totalArea }
        return formatter.string(from: NSNumber(value: totalArea)) ?? "0.00"
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(rooms.indices, id: \.self) { index in
                        RoomView(room: self.$rooms[index], index: index)
                    }
                }
                HStack{
                    Button(action: addRoom) {
                        Text("+ Wand")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
    //                Button(action: calculateTotal) {
    //                    Text("Berechnung")
    //                        .font(.title2)
    //                        .foregroundColor(.white)
    //                        .padding()
    //                        .background(Color.blue)
    //                        .cornerRadius(10)
    //                }
                }
                
                
                Text("Gesamt: \(totalArea(rooms: rooms))")
                    .font(.title3)
            }
            .navigationBarTitle("Quadratflächen Rechner", displayMode: .inline)
        }
        
    }
    
    func addRoom() {
        rooms.append(Room())
    }
    
    func calculateTotal() {
        var totalSurfaceArea: Double = 0
        
        for room in rooms {
            guard let height = Double(room.height), let width = Double(room.width), let numOfWalls = Double(room.numOfWalls) else {
                continue
            }
            
            totalSurfaceArea += height * width * numOfWalls
        }
        
        total = String(format: "%.2f", totalSurfaceArea)
    }
}

struct Room: Identifiable {
    var id = UUID()
    var height: String = ""
    var width: String = ""
    var numOfWalls: String = ""
    var areaToExclude: String = ""
    
    var totalArea: Double {
        let area = (Double(height) ?? 0) * (Double(width) ?? 0) * (Double(numOfWalls) ?? 0)
        let excludeArea = (Double(areaToExclude) ?? 0)
        return area - excludeArea
    }
}

struct RoomView: View {
    @Binding var room: Room
    var index: Int
    
    var body: some View {
        VStack(alignment:.leading){
            Text("Wand \(index + 1)")
                .font(.title2)
                .padding()
            VStack (alignment:.leading) {
                TextField("Geben Sie die Wandhöhe ein", text: $room.height)
                    .keyboardType(.decimalPad)
                    .padding()
                
                TextField("Geben Sie die Wandbreite ein", text: $room.width)
                    .keyboardType(.decimalPad)
                    .padding()
                
                TextField("Geben Sie die Anzahl der Wände ein", text: $room.numOfWalls)
                    .keyboardType(.decimalPad)
                    .padding()
                
                TextField("Auszuschließender Bereich", text: $room.areaToExclude)
                    .keyboardType(.decimalPad)
                    .padding()
            }
            .border(Color.black, width: 1)
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
