//
//  Group.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> Group? {
        let data = snapshot.data()
        guard let subject = data["subject"] as? String else {
            return nil
        }
        let documentId = snapshot.documentID
        
        return Group(documentId: documentId, subject: subject)
    }
}
