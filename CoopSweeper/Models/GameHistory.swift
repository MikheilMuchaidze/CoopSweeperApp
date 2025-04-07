//
//  CoopSweeperApp.swift
//  CoopSweeper
//
//  Created by Mikheil Muchaidze on 06.04.25.
//

//import Foundation
//
//struct GameRecord: Identifiable, Codable {
//    let id: UUID
//    let playerName: String
//    let boardSize: (rows: Int, columns: Int)
//    let mineCount: Int
//    let date: Date
//    let result: GameResult
//    let timeSpent: TimeInterval
//    let minesFound: Int
//    
//    init(playerName: String, boardSize: (rows: Int, columns: Int), mineCount: Int, result: GameResult, timeSpent: TimeInterval, minesFound: Int) {
//        self.id = UUID()
//        self.playerName = playerName
//        self.boardSize = boardSize
//        self.mineCount = mineCount
//        self.date = Date()
//        self.result = result
//        self.timeSpent = timeSpent
//        self.minesFound = minesFound
//    }
//    
//    // Custom encoding
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(playerName, forKey: .playerName)
//        try container.encode(boardSize.rows, forKey: .boardRows)
//        try container.encode(boardSize.columns, forKey: .boardColumns)
//        try container.encode(mineCount, forKey: .mineCount)
//        try container.encode(date, forKey: .date)
//        try container.encode(result.rawValue, forKey: .result)
//        try container.encode(timeSpent, forKey: .timeSpent)
//        try container.encode(minesFound, forKey: .minesFound)
//    }
//    
//    // Custom decoding
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(UUID.self, forKey: .id)
//        playerName = try container.decode(String.self, forKey: .playerName)
//        let rows = try container.decode(Int.self, forKey: .boardRows)
//        let columns = try container.decode(Int.self, forKey: .boardColumns)
//        boardSize = (rows: rows, columns: columns)
//        mineCount = try container.decode(Int.self, forKey: .mineCount)
//        date = try container.decode(Date.self, forKey: .date)
//        let resultString = try container.decode(String.self, forKey: .result)
//        result = GameResult(rawValue: resultString) ?? .lost
//        timeSpent = try container.decode(TimeInterval.self, forKey: .timeSpent)
//        minesFound = try container.decode(Int.self, forKey: .minesFound)
//    }
//    
//    private enum CodingKeys: String, CodingKey {
//        case id, playerName, boardRows, boardColumns, mineCount, date, result, timeSpent, minesFound
//    }
//}
//
//enum GameResult: String, Codable {
//    case won = "Won"
//    case lost = "Lost"
//}
//
//class GameHistory: ObservableObject {
//    @Published var records: [GameRecord] = []
//    private let maxRecords = 10
//    
//    init() {
//        loadHistory()
//    }
//    
//    func addRecord(_ record: GameRecord) {
//        records.insert(record, at: 0)
//        if records.count > maxRecords {
//            records.removeLast()
//        }
//        saveHistory()
//    }
//    
//    private func loadHistory() {
//        if let data = UserDefaults.standard.data(forKey: "gameHistory"),
//           let decoded = try? JSONDecoder().decode([GameRecord].self, from: data) {
//            records = decoded
//        }
//    }
//    
//    private func saveHistory() {
//        if let encoded = try? JSONEncoder().encode(records) {
//            UserDefaults.standard.set(encoded, forKey: "gameHistory")
//        }
//    }
//    
//    func clearHistory() {
//        records.removeAll()
//        saveHistory()
//    }
//} 
