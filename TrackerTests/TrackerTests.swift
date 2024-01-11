//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Ramilia on 31/12/23.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testTrackersViewControllerLightSnapshot() throws {
        let vc = TrackersViewController()
        assertSnapshot(matching: vc, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)))
    }
    
    func testTrackersViewControllerDarkSnapshot() throws {
        let vc = TrackersViewController()
        assertSnapshot(matching: vc, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)))
    }
}
