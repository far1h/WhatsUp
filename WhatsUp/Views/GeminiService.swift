//
//  GeminiService.swift
//  WhatsUp
//
//  Created by Farih Muhammad on 30/10/2025.
//

import Foundation

//https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent

class GeminiService {
    private let apiKey = "YOUR_API_KEY_HERE"
    private let model = "gemini-2.5-flash"
    
    /*
    var contents: [[String: Any]] = []
    for message in chatMessages {
        let role = message.displayName == "AI Assistant" ? "model" : "user"
        let part: [String: Any] = [
            "text": message.text
        ]
        let contentPart: [String: Any] = [
            "role": role,
            "parts": [part]
        ]
        contents.append(contentPart)
        contents.append(prompt)
    }
    let requestBody: [String: Any] = [
        "contents": contents
    ]
    */
    
    // takes content of messages returns response from Gemini model
    
    func getGeminiResponse(for requestBody: [String: Any]) async throws -> GeminiResponse? {
        guard let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent?key=\(apiKey)") else {
            throw NSError(domain: "Invalid URL", code: -1, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Invalid response", code: -1, userInfo: nil)
        }
            
//        if response is of type GeminiResponse return
        let decoder = JSONDecoder()
        let geminiResponse = try decoder.decode(GeminiResponse.self, from: data)
        return geminiResponse
    }
    
}
