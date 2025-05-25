//
//  DetailBluetoothView.swift
//  p2p-skill-test
//
//  Created by Muhammad Aditya Fathur Rahman on 25/05/25.
//

import SwiftUI

struct DetailBluetoothView: View {
    public var dataperipheral: UUID
    
    var body: some View {
        Text("Hello, World! \(dataperipheral.uuidString)")
    }
}

#Preview {
    DetailBluetoothView(dataperipheral: UUID())
}
