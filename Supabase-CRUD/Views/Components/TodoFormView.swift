//
//  TodoFormView.swift
//  Supabase-CRUD
//
//  Created by DENAZMI on 07/08/25.
//

import SwiftUI

struct TodoFormView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TodoViewModel
    
    let todo: Todo?
    let isEditing: Bool
    
    @State private var title: String
    @State private var description: String
    @FocusState private var isTitleFocused: Bool
    
    init(viewModel: TodoViewModel, todo: Todo? = nil) {
        self.viewModel = viewModel
        self.todo = todo
        self.isEditing = todo != nil
        
        _title = State(initialValue: todo?.title ?? "")
        _description = State(initialValue: todo?.description ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Detail Todo") {
                    TextField("Judul", text: $title)
                        .focused($isTitleFocused)
                    
                    TextField("Deskripsi (opsional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(isEditing ? "Edit Todo" : "Tambah Todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Batal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Update" : "Simpan") {
                        Task {
                            if isEditing, let todoId = todo?.id {
                                await viewModel.updateTodo(
                                    id: todoId,
                                    title: title,
                                    description: description.isEmpty ? nil : description
                                )
                            } else {
                                await viewModel.addTodo(
                                    title: title,
                                    description: description.isEmpty ? nil : description
                                )
                            }
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .onAppear {
            isTitleFocused = true
        }
    }
}

#Preview {
    TodoFormView(viewModel: TodoViewModel())
}