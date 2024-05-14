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
    let arabicTranslation: String = ""
    //let surahName: String
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
        //case arabicTranslation = "text"
    }

    // Custom decoder to navigate through the nested JSON structure
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let surahContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .surah)
        surahNumber = try surahContainer.decode(Int.self, forKey: .surahNumber)
        ayahNumber = try container.decode(Int.self, forKey: .ayahNumber)
        englishTranslation = try container.decode(String.self, forKey: .englishTranslation)
        //arabicTranslation = try container.decode(String.self, forKey: <#T##CodingKeys#>)
        //surahName = try container.decode(String.self, forKey: )
    }
}
func randomVerse() async throws -> Ayah {
    let number = Int.random(in: 1...6236)
     
    return try await fetchVerse(number:number)
}
func fetchVerse(number: Int) async throws -> Ayah {
    let urlString = "https://api.alquran.cloud/v1/ayah/\(number)/quran-uthmani"
    guard let url = URL(string: urlString) else {
        throw QuranError.invalidRange
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode directly into Ayah struct
        if let json = String(data: data, encoding: .utf8) {
                }
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

struct AyahsDataWrapper: Decodable {
    let data: [Ayah]

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

func fetchVerses(number: Int) async throws -> [Ayah] {
    let urlString = "https://api.alquran.cloud/v1/ayah/\(number)/editions/quran-uthmani,en.asad"
    guard let url = URL(string: urlString) else {
        throw QuranError.invalidRange
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode directly into Ayah struct
        if let json = String(data: data, encoding: .utf8) {
                    //print("Received JSON: \(json)")
                }
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(AyahsDataWrapper.self, from: data)
        print(decodedData.data[1].englishTranslation)
        return decodedData.data
    } catch {
        throw QuranError.networkError(error)
    }
}
