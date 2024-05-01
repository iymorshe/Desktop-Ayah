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
func randomVerse() async throws -> Ayah {
    let surahNumber = Int.random(in: 3...10)
    let verseNumber = Int.random(in: 1...50)
    
    return try await fetchVerse(surahNumber: surahNumber, verseNumber: verseNumber)
}
func fetchVerse(surahNumber: Int, verseNumber: Int) async throws -> Ayah {
    let urlString = "https://api.alquran.cloud/v1/ayah/\(surahNumber):\(verseNumber)/arabic.asad"
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

let ayahsPerQuran: [Int] = [
    0, 7, 286, 200, 176, 120, 165, 206, 75, 129,
    109, 123, 111, 43, 52, 99, 128, 111, 110, 98,
    135, 112, 78, 118, 64, 77, 227, 93, 88, 69,
    60, 34, 30, 73, 54, 45, 83, 182, 88, 75,
    85, 54, 53, 89, 59, 37, 35, 38, 29, 18,
    45, 60, 49, 62, 55, 78, 96, 29, 22, 24,
    13, 14, 11, 11, 18, 12, 12, 30, 52, 52,
    44, 28, 28, 20, 56, 40, 31, 50, 40, 46,
    42, 29, 19, 36, 25, 22, 17, 19, 26, 30,
    20, 15, 21, 11, 8, 8, 19, 5, 8, 8,
    11, 11, 8, 3, 9, 5, 4, 7, 3, 6,
    3, 5, 4, 5, 6, 3, 6, 3, 5, 4,
    5, 6
]

var cumulativeSum = 0
let prefixSumArray = ayahsPerQuran.reduce(into: []) { (result, ayah) in
    cumulativeSum += ayah
    result.append(cumulativeSum)
}

//func findSurahAndAyah(randomAyahNumber: Int) -> (surahNumber: Int, ayahNumber: Int) {
//    var low = 0
//    var high = prefixSumArray.count - 1
//    
//    while low <= high {
//        let mid = low + (high - low) / 2
//        if prefixSumArray[mid] as! Int < randomAyahNumber {
//            low = mid + 1
//        } else if mid > 0 && prefixSumArray[mid - 1] as! Int >= randomAyahNumber {
//            high = mid - 1
//        } else {
//            // Surah number is `mid` since array starts with a placeholder 0 and matches with Surah indices.
//            let surahNumber = mid
//            // Ayah number is the difference of `randomAyahNumber` and the last Surah's cumulative sum.
//            let ayahNumber = randomAyahNumber - (mid > 0 ? prefixSumArray[mid - 1] : 0) as! Int
//            return (surahNumber, ayahNumber)
//        }
//    }
//    return (0, 0) // Fallback in case of error
//}
