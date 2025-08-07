//
//  Date+Extensions.swift
//  Supabase-CRUD
//
//  Created by DENAZMI on 07/08/25.
//

import Foundation

extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDate(self, inSameDayAs: now) {
            formatter.dateFormat = "HH:mm"
            return "Hari ini \(formatter.string(from: self))"
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
                  calendar.isDate(self, inSameDayAs: yesterday) {
            formatter.dateFormat = "HH:mm"
            return "Kemarin \(formatter.string(from: self))"
        } else if calendar.isDate(self, equalTo: now, toGranularity: .weekOfYear) {
            formatter.dateFormat = "EEEE HH:mm"
            return formatter.string(from: self)
        } else {
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            return formatter.string(from: self)
        }
    }
    
    var relativeString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
