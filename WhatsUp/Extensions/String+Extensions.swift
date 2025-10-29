//
//  String+Extensions.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 29/10/2025.
//

import Foundation

extension String {
    
    var isEmptyOrWhiteSpace: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
