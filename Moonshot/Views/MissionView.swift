//
//  MissionView.swift
//  Moonshot
//
//  Created by Jasper Tan on 12/1/24.
//

import SwiftUI


struct MissionView: View, Hashable {
    
    struct CrewMember: Hashable {
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
                
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .containerRelativeFrame(.horizontal, { width, axis in
                            width * 0.6
                        })
                        .padding([.top, .bottom])
                    
                    Text(mission.formattedLaunchDate)
                        .font(.title3)
                }
                
                dividerView(lineWidth: 2)
                
                missionHighlightsView(mission: mission)

                dividerView(lineWidth: 2)
                
                crewMemberScrollView(crew: crew)
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
    
    struct missionHighlightsView: View {
        
        let mission: Mission
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Mission Highlights")
                    .font(.title.bold())
                    .padding(.bottom, 5)
                
                Text(mission.description)
                    .padding(.bottom)

            }
            .padding(.horizontal)
        }
    }
    
    struct crewMemberScrollView: View {
        
        let crew: [CrewMember]
        
        var body: some View {
            
            Text("Crew")
                .padding()
                .font(.title2.bold())
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(crew, id: \.role) { crewMember in
                        
                        
                        NavigationLink(value: crewMember) {
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
            .padding([.leading, .trailing, .bottom])
            .navigationDestination(for: CrewMember.self) { crewMember in
                AstronautView(astronaut: crewMember.astronaut)
            }
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    return MissionView(mission: missions[1], astronauts: astronauts)
        .preferredColorScheme(.dark)
}
