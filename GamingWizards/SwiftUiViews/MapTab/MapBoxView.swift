//
//  MapBoxView.swift
//  GamingWizards
//
//  Created by Tyler Donohue on 12/5/22.
//

import SwiftUI
import MapboxMaps

struct MapBoxView: View {
    var body: some View {
        MapBoxMapView()
    }
}

struct MapBoxView_Previews: PreviewProvider {
    static var previews: some View {
        MapBoxView()
            .ignoresSafeArea()
    }
}
