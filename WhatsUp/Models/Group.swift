//
//  Group.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import Foundation

struct Group: Identifiable, Hashable, Codable {
    var documentId: String? = nil
    let subject: String
    
    var id: String {
        documentId ?? UUID().uuidString
    }
}

extension Group {
    func toDictionary() -> [String: Any] {
        return [
            "subject": subject
        ]
    }
}
