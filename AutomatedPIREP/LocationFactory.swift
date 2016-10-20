//
//  LocationFactory.swift
//  test1
//
//  Created by Gopavaram,Giri Rakesh on 10/13/16.
//  Copyright © 2016 Gopavaram,Giri Rakesh. All rights reserved.
//

import Foundation
class LocationFactory{
    static var locationsArray: [locations] = []
    
    class func storeLocations()-> [locations]{
        locationsArray=[locations(latitude: 33.636667, longitude: -84.428056),
                        locations(latitude: 33.636667, longitude: -84.428056),
                        locations(latitude: 33.636667, longitude: -84.428056),
                        locations(latitude: 33.9425, longitude:  -118.408056),
                        locations(latitude:41.978611, longitude:-87.904722),
                        locations(latitude:32.896944, longitude:-97.038056 ),
                        locations(latitude:40.639722, longitude:-73.778889),
                        locations(latitude:39.861667, longitude:-104.673056),
                        locations(latitude:37.618889, longitude:-122.375),
                        locations(latitude:35.213889, longitude:-80.943056),
                        locations(latitude:36.08, longitude:-115.152222 ),
                        locations(latitude:33.434167, longitude:-112.011667),
                        locations(latitude:25.793333, longitude:-80.290556),
                        locations(latitude:29.984444, longitude:-95.341389),
                        locations(latitude:47.448889, longitude:-122.309444)
        ]
        return locationsArray

}


}
