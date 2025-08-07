//
//  SupabaseService.swift
//  Supabase-CRUD
//
//  Created by DENAZMI on 07/08/25.
//

import Foundation
import Supabase

@MainActor
class SupabaseService: ObservableObject {
    static let shared = SupabaseService()
    
    private let client: SupabaseClient
    
    private init() {
        let url = URL(string: SupabaseConfig.supabaseURL)!
        let key = SupabaseConfig.supabaseAnonKey
        
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
    
    // MARK: - CRUD Operations
    func fetchTodos() async throws -> [Todo] {
        let response: [Todo] = try await client
            .from("todos")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return response
    }
    
    func createTodo(_ todoInput: TodoInput) async throws -> Todo {
        let response: Todo = try await client
            .from("todos")
            .insert(todoInput)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    func updateTodo(id: Int, _ todoInput: TodoInput) async throws -> Todo {
        let response: Todo = try await client
            .from("todos")
            .update(todoInput)
            .eq("id", value: id)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    func deleteTodo(id: Int) async throws {
        try await client
            .from("todos")
            .delete()
            .eq("id", value: id)
            .execute()
    }
    
    func toggleTodoCompletion(id: Int, isCompleted: Bool) async throws -> Todo {
        let todoInput = TodoInput(title: "", description: nil, isCompleted: isCompleted)
        
        let response: Todo = try await client
            .from("todos")
            .update(["is_completed": isCompleted])
            .eq("id", value: id)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
}
