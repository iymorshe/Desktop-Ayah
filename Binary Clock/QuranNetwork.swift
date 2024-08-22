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
func randomVerses() async throws -> [Ayah] {
    let number = Int.random(in: 1...6236)
     
    return try await fetchVerses(number:number)
}
func fetchVerse(number: Int) async throws -> Ayah {
    let urlString = "https://api.alquran.cloud/v1/ayah/\(number)/quran-uthmani"
    guard let url = URL(string: urlString) else {
        throw QuranError.invalidRange
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode directly into Ayah struct
            //if let json = String(data: data, encoding: .utf8) {
              //  }
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
    let urlString = "https://api.alquran.cloud/v1/ayah/\(number)/editions/quran-uthmani,en.hilali"
    guard let url = URL(string: urlString) else {
        throw QuranError.invalidRange
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        // Decode directly into Ayah struct
        //if let json = String(data: data, encoding: .utf8) {
                    //print("Received JSON: \(json)")
          //      }
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(AyahsDataWrapper.self, from: data)
        //print(decodedData.data[1].englishTranslation)
        return decodedData.data
    } catch {
        throw QuranError.networkError(error)
    }
}

let availableEditions = [
    "quran-uthmani", "en.hilali", "ar.muyassar", "az.mammadaliyev", "az.musayev", "bn.bengali",
    "cs.hrbek", "cs.nykl", "de.aburida", "de.bubenheim", "de.khoury", "de.zaidan", "dv.divehi",
    "en.ahmedali", "en.ahmedraza", "en.arberry", "en.asad", "en.daryabadi", "en.pickthall",
    "en.qaribullah", "en.sahih", "en.sarwar", "en.yusufali", "es.cortes", "fa.ansarian",
    "fa.ayati", "fa.fooladvand", "fa.ghomshei", "fa.makarem", "fr.hamidullah", "ha.gumi",
    "hi.hindi", "id.indonesian", "it.piccardo", "ja.japanese", "ko.korean", "ku.asan",
    "ml.abdulhameed", "nl.keyzer", "no.berg", "pl.bielawskiego", "pt.elhayek", "ro.grigore",
    "ru.kuliev", "ru.osmanov", "ru.porokhova", "sd.amroti", "so.abduh", "sq.ahmeti", "sq.mehdiu",
    "sq.nahi", "sv.bernstrom", "sw.barwani", "ta.tamil", "tg.ayati", "th.thai", "tr.ates",
    "tr.bulac", "tr.diyanet", "tr.golpinarli", "tr.ozturk", "tr.vakfi", "tr.yazir", "tr.yildirim",
    "tr.yuksel", "tt.nugman", "ug.saleh", "ur.ahmedali", "ur.jalandhry", "ur.jawadi",
    "ur.kanzuliman", "ur.qadri", "uz.sodik", "en.maududi", "en.shakir", "en.transliteration",
    "es.asad", "fa.bahrampour", "fa.khorramshahi", "fa.mojtabavi", "hi.farooq", "id.muntakhab",
    "ms.basmeih", "ru.abuadel", "ru.krachkovsky", "ru.muntahab", "ru.sablukov", "ur.junagarhi",
    "ur.maududi", "zh.jian", "zh.majian", "fa.khorramdel", "fa.moezzi", "bs.korkut", "ar.jalalayn",
    "quran-tajweed", "quran-wordbyword", "si.naseemismail", "quran-buck", "zh.mazhonggang",
    "quran-wordbyword-2", "quran-unicode", "quran-uthmani-quran-academy", "ba.mehanovic",
    "en.itani", "ar.qurtubi", "ar.miqbas", "ar.waseet", "ar.baghawi", "my.ghazi", "en.mubarakpuri",
    "am.sadiq", "ber.mensur", "bn.hoque", "en.qarai", "en.wahiduddin", "es.bornez", "es.garcia",
    "ur.najafi", "fa.gharaati", "fa.sadeqi", "fa.safavi", "id.jalalayn", "ml.karakunnu",
    "nl.leemhuis", "nl.siregar", "ps.abdulwali", "ru.kuliev-alsaadi"
]

// New function to fetch verses for multiple editions
func fetchVersesForEditions(number: Int, editions: [String]) async throws -> [String: Ayah] {
    let editionsString = editions.joined(separator: ",")
    let urlString = "https://api.alquran.cloud/v1/ayah/\(number)/editions/\(editionsString)"
    guard let url = URL(string: urlString) else {
        throw QuranError.invalidRange
    }

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(AyahsDataWrapper.self, from: data)
        
        var result: [String: Ayah] = [:]
        for ayah in decodedData.data {
            if let edition = editions.first(where: { $0.contains(ayah.englishTranslation) }) {
                result[edition] = ayah
            }
        }
        return result
    } catch {
        throw QuranError.networkError(error)
    }
}
