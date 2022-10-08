//
//  Unicode Extensions.swift
//  unicodeGlyphNames
//
//  Created by Łukasz Dziedzic on 28/04/2022.
//

import Foundation
import OrderedCollections

public extension Character {
    var shortName: String? {
        return UnicodeNames[self]
    }
    
    var longName: String {
        return UnicodeNames.unicodeLongName(self)
    }
}

public final class UnicodeNames {
    
    public enum Case {
        case upper(Int32)
        case lower(Int32)
        case none
    }
    
    public enum Srcipt {
        case latin
        case number
        case unknown
    }
    
    public struct Param {
        let `case`: Case
        let unicodeName: String
    }
    
    public enum Errors: Error {
        case fileNotFound
        case fileError
    }
    
    public static var shortNames: [String] {
        return Array(names.keys)
    }
    
    
    private static var records: [Character: String] = [:]
    private static var names: OrderedDictionary <String, Character> = [:]

    public static func prepareData() {
        let t = Date()
        Task {
            let bundle = Bundle(for: Self.self)
            print (bundle)
            if let namesFlatPath = bundle.path(forResource: "glyphNamesToUnicodeAndCategories", ofType: "txt") {
                
                do {
                    let names = try String(contentsOfFile: namesFlatPath).split(separator: "\n")
                    
                    Self.names = names.reduce(into: OrderedDictionary <String, Character>()) { dict, line in
                        if line.first != "#" {
                            let elements = line.split(separator: " ", omittingEmptySubsequences: false)
                            if let unicode = Int(elements[1], radix: 16),
                               let scalar = UnicodeScalar(unicode) {
                                let chr = Character(scalar)
                                dict[String(elements[0])] = chr
                            }
                        }
                    }
                } catch {
                    fatalError("No names file")
                }
            } else {
                fatalError("broken names file")
            }
            if let unicodeFlatFilePath = bundle.path(forResource: "flatUnicode", ofType: "txt") {
                do {
                    
                    let unicodeFlat = try String(contentsOfFile: unicodeFlatFilePath).split(separator: "\n")
                    
                    records = unicodeFlat.reduce (into: [Character:String]()) { dict, line in
                        //print (line)
                        let elements = line.split(separator: "\t", omittingEmptySubsequences: false)
                        if let unicode =  Int(elements[0], radix: 16),
                           let scalar = UnicodeScalar(unicode) {
                            let chr = Character(scalar)
                            dict[chr] = String(elements[5])
                        }
                    }
                    //return unicodeList
                } catch {
                    fatalError("No unicode file")
                }
            } else {
                fatalError ("broken unicode file")
            }
            print (t.timeIntervalSinceNow)
        }
    }
    
    
    
    public static subscript(name: String) -> Character? {
        return names[name]
    }
    
    public static subscript(char: Character) -> String {
        return names.first(where: {$0.value == char})?.key ?? ""
    }
    
    public static func unicodeLongName(_ char:Character) -> String {
        return records[char] ?? ""
    }
    

    public static var shared = UnicodeNames()
}

public extension String {
    var characterFromShortUicodeName: String {
        guard let char = UnicodeNames[self] else {return ""}
        return String(char)
    }
}

