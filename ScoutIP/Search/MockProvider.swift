//
// Copyright 2026 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import CoreData
import Foundation

enum MockProvider {

  static var isMocking: Bool {
    ProcessInfo.processInfo.arguments.contains("-UITestMocking")
  }

  static let mockIP = "8.8.8.8"
  static let mockCity = "Mountain View"
  static let mockRegion = "California"
  static let mockCountry = "US"
  static let mockLocation = "37.3861,-122.0839"
  static let mockOrg = "AS15169 Google LLC"
  static let mockPostal = "94035"
  static let mockTimezone = "America/Los_Angeles"
}

extension IPObject {
  @MainActor static func mock(ip: String, context: NSManagedObjectContext) -> IPObject {
    let object = IPObject(context: context)
    object.ip = ip
    object.city = MockProvider.mockCity
    object.region = MockProvider.mockRegion
    object.country = MockProvider.mockCountry
    object.loc = MockProvider.mockLocation
    object.org = MockProvider.mockOrg
    object.postal = MockProvider.mockPostal
    object.timezone = MockProvider.mockTimezone
    return object
  }
}
