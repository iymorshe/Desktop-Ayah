//
//  QuranNetwork.swift
//  Binary Clock
//
//  Created by Iman Morshed on 4/25/24.
//

import Foundation
class Ayah: Decodable, Hashable {
    let surahNumber: Int
    let ayahNumber: Int
    let englishTranslation: String
    var isFavorite: Bool = false
    func hash(into hasher: inout Hasher) {
        hasher.combine(surahNumber)
        hasher.combine(ayahNumber)
    }
    
    func identification() -> String{
        return "\(surahNumber).\(ayahNumber)"
    }
    static func == (lhs: Ayah, rhs: Ayah) -> Bool {
        return lhs.surahNumber == rhs.surahNumber && lhs.ayahNumber == rhs.ayahNumber
    }
    // Coding keys to map the JSON keys to our struct's properties
    enum CodingKeys: String, CodingKey {
        case surahNumber = "number"
        case ayahNumber = "numberInSurah"
        case englishTranslation = "text"
        case surah
    }

    // Custom decoder to navigate through the nested JSON structure
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let surahContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .surah)
        surahNumber = try surahContainer.decode(Int.self, forKey: .surahNumber)
        ayahNumber = try container.decode(Int.self, forKey: .ayahNumber)
        englishTranslation = try container.decode(String.self, forKey: .englishTranslation)
    }
}
func fetchVerse(surahNumber: Int, verseNumber: Int) async throws -> Ayah {
    let urlString = "https://api.alquran.cloud/v1/ayah/\(surahNumber):\(verseNumber)/en.asad"
    guard let url = URL(string: urlString) else {
        throw QuranError.invalidRange
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode directly into Ayah struct
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(AyahDataWrapper.self, from: data)
        return decodedData.data
    } catch {
        throw QuranError.networkError(error)
    }
}

struct AyahDataWrapper: Decodable {
    let data: Ayah

    enum CodingKeys: String, CodingKey {
        case data
    }
}


enum QuranError: Error {
    case invalidRange
    case networkError(Error)
    case invalidResponse
    case parsingError(Error)
}
