//
//  TodoViewModel.swift
//  Supabase-CRUD
//
//  Created by DENAZMI on 07/08/25.
//

import Foundation
import SwiftUI

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingAddTodo = false
    @Published var showingEditTodo = false
    @Published var selectedTodo: Todo?
    
    private let supabaseService = SupabaseService.shared
    
    init() {
        Task {
            await loadTodos()
        }
    }
    
    // MARK: - Public Methods
    
    func loadTodos() async {
        isLoading = true
        errorMessage = nil
        
        do {
            todos = try await supabaseService.fetchTodos()
        } catch {
            errorMessage = "Gagal memuat todos: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func addTodo(title: String, description: String?) async {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Judul todo tidak boleh kosong"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let todoInput = TodoInput(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description?.trimmingCharacters(in: .whitespacesAndNewlines),
                isCompleted: false
            )
            
            let newTodo = try await supabaseService.createTodo(todoInput)
            todos.insert(newTodo, at: 0)
            showingAddTodo = false
        } catch {
            errorMessage = "Gagal menambah todo: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func updateTodo(id: Int, title: String, description: String?) async {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Judul todo tidak boleh kosong"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let todoInput = TodoInput(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description?.trimmingCharacters(in: .whitespacesAndNewlines),
                isCompleted: selectedTodo?.isCompleted ?? false
            )
            
            let updatedTodo = try await supabaseService.updateTodo(id: id, todoInput)
            
            if let index = todos.firstIndex(where: { $0.id == id }) {
                todos[index] = updatedTodo
            }
            
            showingEditTodo = false
            selectedTodo = nil
        } catch {
            errorMessage = "Gagal mengupdate todo: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func deleteTodo(id: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await supabaseService.deleteTodo(id: id)
            todos.removeAll { $0.id == id }
        } catch {
            errorMessage = "Gagal menghapus todo: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func toggleTodoCompletion(_ todo: Todo) async {
        guard let id = todo.id else { return }
        
        do {
            let updatedTodo = try await supabaseService.toggleTodoCompletion(
                id: id,
                isCompleted: !todo.isCompleted
            )
            
            if let index = todos.firstIndex(where: { $0.id == id }) {
                todos[index] = updatedTodo
            }
        } catch {
            errorMessage = "Gagal mengupdate status todo: \(error.localizedDescription)"
        }
    }
    
    func selectTodoForEdit(_ todo: Todo) {
        selectedTodo = todo
        showingEditTodo = true
    }
    
    func clearError() {
        errorMessage = nil
    }
}