//
//  TabBarView.swift
//  Dj Raumausstatter
//
//  Created by besim on 02/01/2024.
//

import SwiftUI

enum Tab: String, CaseIterable{
    case squareResize = "square.stack.3d.down.right"
    case printer = "doc.text"
    case list = "list.clipboard"
}

struct TabBarView: View {
    
    @Binding var selectedTab: Tab
    private var fillImage:String{
        selectedTab.rawValue + ".fill"
    }
    
    var body: some View {
        VStack{
            HStack{
                ForEach(Tab.allCases,id: \.rawValue){ tab in
                    Spacer()
                    Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                        .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)){
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .frame(width: nil, height: 40)
            .cornerRadius(10)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: .constant(.squareResize))
    }
}
