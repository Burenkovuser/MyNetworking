//
//  Course.swift
//  MyNetworking
//
//  Created by Vasilii on 23/08/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import Foundation

struct Course: Decodable {
    let name: String?
    let link: String?
    let imageUrl: String?
    let number_of_lessons: Int?
    let number_of_tests: Int?
}

struct WebsiteDestraction: Decodable {
    let courses: [Course]?
    let websiteDescription: String?
    let websiteName: String?
}
