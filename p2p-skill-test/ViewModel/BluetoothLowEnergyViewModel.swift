//
//  BluetoothLowEnergyViewModel.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 24/05/25.
//

import Foundation
import CoreBluetooth

class BluetoothLowEnergyViewModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    @Published var isBluetoothOn = false
    @Published var peripherals = [Peripheral]()
    @Published var connectedPeripheral: UUID?
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    // called when the state of the central manager is updated
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isBluetoothOn = central.state == .poweredOn
        if isBluetoothOn {
            startScanning()
        } else {
            stopScanning()
        }
    }
    
    // called to discover peripheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let newPeripheral = Peripheral(id: peripheral.identifier, name: peripheral.name ?? "Unknown Device", rssi: RSSI.intValue) // get peripheral data
        
        // check if peripheral not exist theninsert new peripheral into list
        DispatchQueue.main.async {
            if let index = self.peripherals.firstIndex(where: {$0.id == newPeripheral.id}) {
                self.peripherals.removeAll(where: {$0.id == newPeripheral.id})
                self.peripherals.insert(newPeripheral, at: index)
            } else {
                self.peripherals.append(newPeripheral)
            }
        }
    }
    
    func startScanning() {
        isBluetoothOn = true
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        isBluetoothOn = false
        centralManager.stopScan()
    }
}
