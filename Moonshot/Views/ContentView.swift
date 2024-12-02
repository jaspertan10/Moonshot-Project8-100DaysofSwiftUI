//
//  ContentView.swift
//  Moonshot
//
//  Created by Jasper Tan on 11/30/24.
//

import SwiftUI

struct ContentView: View {
    
    private let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    private let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showingGrid = false
    
    var body: some View {

        NavigationStack {
            Group {
                
                if (showingGrid == true) {
                    GridLayoutView(astronauts: astronauts, missions: missions)
                }
                else {
                    ListLayoutView(astronauts: astronauts, missions: missions)
                }
                
                
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .toolbar {
                Button(showingGrid ? "List" : "Grid") {
                    withAnimation {
                        showingGrid.toggle()
                    }
                }
            }
        }
    }
    
    struct ListLayoutView: View {
        
        let astronauts: [String: Astronaut]
        let missions: [Mission]
        
        var body: some View {
            List {
                ForEach(missions) { mission in
                    NavigationLink {
                        MissionView(mission: mission, astronauts: astronauts)
                    } label: {
                        HStack(spacing: 25) {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                            
                            
                            VStack(alignment: .leading) {
                                Text(mission.displayName)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                
                                Text(mission.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.65))
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct GridLayoutView: View {
        
        let astronauts: [String: Astronaut]
        let missions: [Mission]
        
        let columns = [
            GridItem(.adaptive(minimum: 150))
        ]
        
        var body: some View {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission, astronauts: astronauts)
                        } label: {
                            //label
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.65))
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(.rect(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.lightBackground))
                            
                        }
                        
                        
                    }
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
}

#Preview {
    ContentView()
}
