//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Ramilia on 03/01/24.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    //static let shared = AnalyticsService()
    
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "3502fe0b-b029-44d7-a5e2-f3d292113d3d") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(_ event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
