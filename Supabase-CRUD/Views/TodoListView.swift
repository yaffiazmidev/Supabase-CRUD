//
//  TodoListView.swift
//  Supabase-CRUD
//
//  Created by DENAZMI on 07/08/25.
//

import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel = TodoViewModel()
    @State private var showingDeleteAlert = false
    @State private var todoToDelete: Todo?
    @State private var showingSetupInstructions = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.todos.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    todoListContent
                }
                
                if viewModel.isLoading {
                    ProgressView("Memuat...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.1))
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            showingSetupInstructions = true
                        }) {
                            Image(systemName: "gear")
                        }
                        
                        Button(action: {
                            viewModel.showingAddTodo = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        Task {
                            await viewModel.loadTodos()
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .refreshable {
                await viewModel.loadTodos()
            }
        }
        .sheet(isPresented: $viewModel.showingAddTodo) {
            TodoFormView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showingEditTodo) {
            if let selectedTodo = viewModel.selectedTodo {
                TodoFormView(viewModel: viewModel, todo: selectedTodo)
            }
        }
        .sheet(isPresented: $showingSetupInstructions) {
            SetupInstructionsView()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .alert("Hapus Todo", isPresented: $showingDeleteAlert) {
            Button("Batal", role: .cancel) {
                todoToDelete = nil
            }
            Button("Hapus", role: .destructive) {
                if let todo = todoToDelete, let id = todo.id {
                    Task {
                        await viewModel.deleteTodo(id: id)
                    }
                }
                todoToDelete = nil
            }
        } message: {
            Text("Apakah Anda yakin ingin menghapus todo ini?")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Belum ada todo")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text("Tap tombol + untuk menambah todo pertama Anda")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Tambah Todo") {
                viewModel.showingAddTodo = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var todoListContent: some View {
        List {
            if !viewModel.todos.isEmpty {
                Section {
                    TodoStatsView(todos: viewModel.todos)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
            }
            
            Section {
                ForEach(viewModel.todos) { todo in
                    TodoRowView(
                        todo: todo,
                        onToggleCompletion: {
                            Task {
                                await viewModel.toggleTodoCompletion(todo)
                            }
                        },
                        onEdit: {
                            viewModel.selectTodoForEdit(todo)
                        },
                        onDelete: {
                            todoToDelete = todo
                            showingDeleteAlert = true
                        }
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .padding(.vertical, 2)
                    )
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    TodoListView()
}