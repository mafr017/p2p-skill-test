//
//  ContentView.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 23/05/25.
//

import Foundation
import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject var bluetoothViewModel = BluetoothLowEnergyViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Discoverable Devices")
                .font(.system(size: 20, weight: .bold))
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            List(bluetoothViewModel.peripherals) { peripheral in
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(peripheral.name)
                            .font(.system(size: 14, weight: .bold))
                        Text(peripheral.id.uuidString)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .onTapGesture {
                    print("tap \(peripheral.id.uuidString)")
                }
            }
            
            Spacer()
            
            HStack {
                Text(bluetoothViewModel.isBluetoothOn ? "Searching Devices..." : "Searching Stopped")
                    .padding(.leading, 30)
                
                Spacer()
                
                Button {
                    if bluetoothViewModel.isBluetoothOn {
                        bluetoothViewModel.stopScanning()
                    } else {
                        bluetoothViewModel.startScanning()
                    }
                } label: {
                    if bluetoothViewModel.isBluetoothOn {
                        Text("Stop")
                    } else {
                        Text("Start")
                    }
                }
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .padding(.all, 10)
                .background(bluetoothViewModel.isBluetoothOn ? .red : .green)
                .cornerRadius(10)
                .padding(.trailing, 30)
            }
            
            Spacer()
            
        }
        .onAppear {
            if bluetoothViewModel.isBluetoothOn {
                bluetoothViewModel.startScanning()
            }
        }
        .onDisappear {
            bluetoothViewModel.stopScanning()
        }
        
    }
}
