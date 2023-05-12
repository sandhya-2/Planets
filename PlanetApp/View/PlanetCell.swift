//
//  PlanetCell.swift
//  PlanetApp
//
//  Created by Sandiya on 10/05/2023.
//

import SwiftUI

struct PlanetCell: View {
    
    let planet: Planet
    
    var body: some View {
        
        VStack(alignment: .leading){
                        
            Text(planet.name)
                .font(.title)
            Text("Gravity: " + planet.gravity)
                .font(.subheadline)
            Text("Population: " + planet.population)
                .font(.subheadline)
            Text("Climate: " + planet.climate)
                .font(.subheadline)
                                        
        }
       
    }
}

struct PlanetCell_Previews: PreviewProvider {
    static var previews: some View {
        PlanetCell(planet: Planet(name: "", rotationPeriod: "", orbitalPeriod: "", diameter: "", climate: "", gravity: "", terrain: "", surfaceWater: "", population: "", created: "", edited: "", url: ""))
    }
}
