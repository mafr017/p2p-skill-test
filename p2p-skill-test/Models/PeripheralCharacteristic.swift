//
//  PeripheralCharacteristic.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 26/05/25.
//

import Foundation
import CoreBluetooth

class PeripheralCharacteristic: Identifiable, ObservableObject {
    @Published var id: UUID
    @Published var characteristic: CBCharacteristic
    @Published var uuid: CBUUID
    @Published var characteristicName: String
    
    init(_characteristic: CBCharacteristic,
         _uuid: CBUUID,
         _characteristicName: String
    ) {
        
        id = UUID()
        characteristic = _characteristic
        uuid = _uuid
        characteristicName = _characteristicName
        
    }
    
}
