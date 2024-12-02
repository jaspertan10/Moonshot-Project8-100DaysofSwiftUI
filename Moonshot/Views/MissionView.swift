//
//  MissionView.swift
//  Moonshot
//
//  Created by Jasper Tan on 12/1/24.
//

import SwiftUI

struct MissionView: View {
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let crew: [CrewMember]
    let mission: Mission
    
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            }
            else {
                fatalError("Astronaut not found: \(member.name)")
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
//                    .containerRelativeFrame(.horizontal) { width, axis in
//                        width * 0.6
//                    }
                    .containerRelativeFrame(.horizontal, { width, axis in
                        width * 0.6
                    })
                    .padding([.top, .bottom])
                
                dividerView(lineWidth: 2)
                
                VStack(alignment: .leading) {
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)
                    
                    Text(mission.description)
                        .padding(.bottom)
                }
                .padding(.horizontal)
                

                dividerView(lineWidth: 2)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(crew, id: \.role) { crewMember in
                            NavigationLink {
                                Text("Astronaut details")
                            } label: {
                                HStack {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 104, height: 72)
                                        .clipShape(Capsule())
                                        .overlay {
                                            Capsule().strokeBorder(.white, lineWidth: 2)
                                        }
                                    VStack {
                                        Text(crewMember.astronaut.name)
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                        
                                        Text(crewMember.role)
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.65))
                                    }
                                    .padding(.trailing, 15)
                                }
                                .overlay(Capsule().strokeBorder(Color.white, lineWidth: 2))
                            }

                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    
    func dividerView(lineWidth: CGFloat) -> some View {
        Rectangle()
            .frame(height: lineWidth)
            .foregroundStyle(.lightBackground)
            .padding([.leading, .trailing])
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
