//
//  Peripheral.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 24/05/25.
//

import Foundation
import CoreBluetooth

class Peripheral: Identifiable, ObservableObject {
    
    @Published var id: UUID
    @Published var peripheral: CBPeripheral
    @Published var services: [PeripheralService]
    @Published var name: String
    @Published var rssi: Int
    
    init(_peripheral: CBPeripheral,
         _services: [PeripheralService],
         _name: String,
         _rssi: Int
         )
    {
        id = UUID()
        services = _services
        peripheral = _peripheral
        name = _name
        rssi = _rssi

    }
}
