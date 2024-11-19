//
// Copyright 2024 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI
import MapKit

struct Location: Identifiable {
    let coordinate: CLLocationCoordinate2D
    let id: String

    init?(string: String) {
        let components = string.components(separatedBy: ",")
        guard components.count == 2, let latitude = Double(components[0]), let longitude = Double(components[1]) else {
            return nil
        }
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        id = string
    }
}

struct MapView: View {
    let location: Location

    var body: some View {
        Map(coordinateRegion: .constant(region), interactionModes: [], annotationItems: [location]) { _ in
            MapMarker(coordinate: location.coordinate)
        }
        .frame(height: 216)
        .listRowInsets(EdgeInsets())
    }

    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 1_000_000,
            longitudinalMeters: 1_000_000
        )
    }
}

#Preview {
    List {
        MapView(location: Location(string: "24.6877,46.7219")!)
    }
}
