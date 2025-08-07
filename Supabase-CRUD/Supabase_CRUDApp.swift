//
//  Supabase_CRUDApp.swift
//  Supabase-CRUD
//
//  Created by DENAZMI on 07/08/25.
//

import SwiftUI
import os.log

@main
struct Supabase_CRUDApp: App {
    
    init() {
        // Suppress RTI warnings in simulator
        #if targetEnvironment(simulator)
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
