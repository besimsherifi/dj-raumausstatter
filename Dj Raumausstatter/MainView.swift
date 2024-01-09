//
//  MainView.swift
//  Dj Raumausstatter
//
//  Created by besim on 02/01/2024.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab: Tab = .squareResize
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    
    var body: some View {
        ZStack{
            VStack{
                TabView(selection: $selectedTab) {
                    ContentView()
                        .tag(Tab.squareResize)
                    
                    PrintScreen()
                        .tag(Tab.printer)
                    
                    ListScreen()
                        .tag(Tab.list)
                    
                }
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
