//
//  Person.swift
//  Polygons
//
//  Created by Krzysztof Lech on 16/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

enum PersonSex {
    case male, female
}

enum PersonData {
    static let femaleNames = ["Daisy", "Deborah", "Isabel", "Stella", "Debra", "Beverly", "Vera", "Angela", "Lucy", "Lauren", "Janet", "Loretta", "Tracey", "Beatrice", "Sabrina", "Melody", "Chrysta", "Christina", "Vicki", "Molly", "Alison", "Miranda", "Stephanie", "Leona", "Mila", "Gabriela", "Ashley", "Nicole", "Valentina", "Rose", "Juliana", "Alice", "Kathie", "Gloria", "Luna", "Phoebe", "Angelique", "Graciela", "Gemma", "Katelynn", "Danna", "Luisa", "Julie", "Olive", "Carolina", "Harmony", "Hanna", "Anabelle", "Francesca", "Whitney", "Skyla", "Nathalie", "Sophie", "Hannah", "Silvia", "Sophia", "Della", "Myra", "Blanca", "Bethany", "Robyn", "Traci", "Desiree", "Laverne", "Patricia", "Alberta", "Lynda", "Cara", "Brandi", "Janessa", "Claudia", "Rosa", "Sandra", "Eunice", "Kayla", "Kathryn", "Rosie", "Monique", "Maggie", "Hope", "Alexia", "Lucille", "Odessa", "Amanda", "Kimberly", "Blanche", "Tyra", "Helena", "Kayleigh", "Lucia", "Janine", "Maribel", "Camille", "Alisa", "Vivian", "Lesley", "Rachelle", "Kianna"]
    
    static let maleNames = ["Wade", "Dave", "Seth", "Riley", "Gilbert", "Jorge", "Dan", "Brian", "Roberto", "Ramon", "Miles", "Liam", "Nathaniel", "Ethan", "Lewis", "Milton", "Claude", "Joshua", "Glen", "Harvey", "Blake", "Antonio", "Connor", "Julian", "Aidan", "Harold", "Conner", "Peter", "Hunter", "Eli", "Alberto", "Carlos", "Shane", "Aaron", "Marlin", "Paul", "Ricardo", "Hector", "Alexis", "Adrian", "Kingston", "Douglas", "Gerald", "Joey", "Johnny", "Charlie", "Scott", "Martin", "Tristin", "Troy", "Tommy", "Rick", "Victor", "Jessie", "Neil", "Ted", "Nick", "Wiley", "Morris", "Clark", "Stuart", "Orlando", "Keith", "Marion", "Marshall", "Noel", "Everett", "Romeo", "Sebastian", "Stefan", "Robin", "Clarence", "Sandy", "Ernest", "Samuel", "Benjamin", "Luka", "Fred", "Albert", "Greyson", "Terry", "Cedric", "Joe", "Paul", "George", "Bruce", "Christopher", "Mark", "Ron", "Craig", "Philip", "Jimmy", "Arthur", "Jaime", "Perry", "Harold", "Jerry", "Shawn", "Walter"]
    
    static let femaleAvatarsNumber = 13
    static let maleAvatarsNumber = 17
    static let femaleAvatarImageName = "avatar_f%i"
    static let maleAvatarImageName = "avatar_m%i"
}

struct Person {
    let id: Int
    let sex: PersonSex
    let name: String
    let avatar: UIImage
    
    init(id: Int) {
        self.id = id
        
        let randomSexValue = Int.random(in: 0...1)
        self.sex = randomSexValue == 0 ? PersonSex.male : PersonSex.female
        
        let imageName: String
        switch sex {
        case .female:
            self.name = PersonData.femaleNames.randomElement() ?? ""
            let imageIndex = Int.random(in: 1...PersonData.femaleAvatarsNumber)
            imageName = String(format: PersonData.femaleAvatarImageName, imageIndex)
            
        case .male:
            self.name = PersonData.maleNames.randomElement() ?? ""
            let imageIndex = Int.random(in: 1...PersonData.maleAvatarsNumber)
            imageName = String(format: PersonData.maleAvatarImageName, imageIndex)
        }
        
        self.avatar = UIImage(named: imageName) ?? UIImage()
    }
}
