//
//  TodoStatsView.swift
//  Supabase-CRUD
//
//  Created by DENAZMI on 07/08/25.
//

import SwiftUI

struct TodoStatsView: View {
    let todos: [Todo]
    
    private var totalTodos: Int {
        todos.count
    }
    
    private var completedTodos: Int {
        todos.filter { $0.isCompleted }.count
    }
    
    private var pendingTodos: Int {
        totalTodos - completedTodos
    }
    
    private var completionPercentage: Double {
        guard totalTodos > 0 else { return 0 }
        return Double(completedTodos) / Double(totalTodos) * 100
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                statCard(
                    title: "Total",
                    value: "\(totalTodos)",
                    color: .blue,
                    icon: "list.bullet"
                )
                
                statCard(
                    title: "Selesai",
                    value: "\(completedTodos)",
                    color: .green,
                    icon: "checkmark.circle.fill"
                )
                
                statCard(
                    title: "Pending",
                    value: "\(pendingTodos)",
                    color: .orange,
                    icon: "clock.fill"
                )
            }
            
            if totalTodos > 0 {
                progressSection
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func statCard(title: String, value: String, color: Color, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
    
    private var progressSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(Int(completionPercentage))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
            }
            
            ProgressView(value: completionPercentage, total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
        }
        .padding(.top, 8)
    }
}

#Preview {
    TodoStatsView(todos: [
        Todo(title: "Todo 1", isCompleted: true),
        Todo(title: "Todo 2", isCompleted: false),
        Todo(title: "Todo 3", isCompleted: true),
        Todo(title: "Todo 4", isCompleted: false)
    ])
    .padding()
}