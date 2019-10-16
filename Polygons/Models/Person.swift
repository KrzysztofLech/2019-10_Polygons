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

struct Person {
    let id: Int
    let sex: PersonSex
    let name: String
    let avatar: UIImage
    
    init(id: Int) {
        self.id = id
        
        let randomSexValue = Int.random(in: 0...1)
        self.sex = randomSexValue == 0 ? PersonSex.male : PersonSex.female
        
        self.name = sex == .male ? "Tomek" : "Ania"
        
        let imageName = sex == .male ? "avatar_m1" : "avatar_f1"
        self.avatar = UIImage(named: imageName) ?? UIImage()
    }
}
