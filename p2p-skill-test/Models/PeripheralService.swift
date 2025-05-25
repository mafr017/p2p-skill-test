//
//  PeripheralService.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 26/05/25.
//

import Foundation
import CoreBluetooth

class PeripheralService: Identifiable, ObservableObject {
    
    var id: UUID
    var uuid: CBUUID
    var service: CBService
    var serviceName: String
    var characteristices: [PeripheralCharacteristic] = []

    init(_uuid: CBUUID,
         _service: CBService,
         _serviceName: String,
         _characteristices: [PeripheralCharacteristic]
    ) {
        
        id = UUID()
        uuid = _uuid
        service = _service
        serviceName = _serviceName
        characteristices = _characteristices
    }
}
