//
//  SetupInstructionsView.swift
//  Supabase-CRUD
//
//  Created by DENAZMI on 07/08/25.
//

import SwiftUI

struct SetupInstructionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerSection
                    
                    setupStepsSection
                    
                    databaseSchemaSection
                    
                    configurationSection
                }
                .padding()
            }
            .navigationTitle("Setup Supabase")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Tutup") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: "server.rack")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            Text("Setup Supabase Database")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Ikuti langkah-langkah berikut untuk mengonfigurasi database Supabase Anda.")
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var setupStepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Langkah Setup")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 12) {
                setupStep(number: "1", title: "Buat Project Supabase", description: "Kunjungi supabase.com dan buat project baru")
                setupStep(number: "2", title: "Buat Tabel Database", description: "Jalankan SQL schema di bawah ini")
                setupStep(number: "3", title: "Dapatkan API Keys", description: "Copy Project URL dan anon key dari Settings > API")
                setupStep(number: "4", title: "Update Konfigurasi", description: "Masukkan URL dan key ke SupabaseConfig.swift")
            }
        }
    }
    
    private var databaseSchemaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Database Schema")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Jalankan SQL berikut di Supabase SQL Editor:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                Text(sqlSchema)
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
    }
    
    private var configurationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Konfigurasi App")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Update file SupabaseConfig.swift dengan data project Anda:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(configCode)
                .font(.system(.caption, design: .monospaced))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
    
    private func setupStep(number: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.blue))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    private var sqlSchema: String {
        """
        CREATE TABLE todos (
            id SERIAL PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            is_completed BOOLEAN DEFAULT FALSE,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );
        
        CREATE OR REPLACE FUNCTION update_updated_at_column()
        RETURNS TRIGGER AS $$
        BEGIN
            NEW.updated_at = NOW();
            RETURN NEW;
        END;
        $$ language 'plpgsql';
        
        CREATE TRIGGER update_todos_updated_at
            BEFORE UPDATE ON todos
            FOR EACH ROW
            EXECUTE FUNCTION update_updated_at_column();
        
        ALTER TABLE todos ENABLE ROW LEVEL SECURITY;
        
        CREATE POLICY "Allow all operations" ON todos
            FOR ALL USING (true);
        """
    }
    
    private var configCode: String {
        """
        static let supabaseURL = "https://your-project-id.supabase.co"
        static let supabaseAnonKey = "your-anon-key-here"
        """
    }
}

#Preview {
    SetupInstructionsView()
}
