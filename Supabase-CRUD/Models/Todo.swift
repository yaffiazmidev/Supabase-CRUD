//
//  Todo.swift
//  Supabase-CRUD
//
//  Created by DENAZMI on 07/08/25.
//

import Foundation

struct Todo: Codable, Identifiable {
    let id: Int?
    var title: String
    var description: String?
    var isCompleted: Bool
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case isCompleted = "is_completed"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(title: String, description: String? = nil, isCompleted: Bool = false) {
        self.id = nil
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
        self.createdAt = nil
        self.updatedAt = nil
    }
}

// MARK: - Todo untuk Create/Update
struct TodoInput: Codable {
    let title: String
    let description: String?
    let isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case isCompleted = "is_completed"
    }
}