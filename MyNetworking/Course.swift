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
    let numberOfLessons: String?
    let numberOfTests: String?
    
    //чтобы заглавные буквы json привезти к строчным в структуре, также можно поменять смысловую нагрузку чтобы соответвовало логигке структуры.
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case link = "Link"
        case imageUrl = "ImageUrl"
        case numberOfLessons = "Number_of_lessons"
        case numberOfTests = "Number_of_tests"
    }
    
    init(dictCourse: [String: Any]) {
        name = dictCourse["name"] as? String
        link = dictCourse["link"] as? String
        imageUrl = dictCourse["imageUrl"] as? String
        numberOfLessons = dictCourse["numberOfLessons"] as? String
        numberOfTests = dictCourse["numberOfTests"] as? String
        //использовали без alamofire
        //numberOfLessons = dictCourse["number_of_lessons"] as? Int
        //numberOfTests = dictCourse["number_of_tests"] as? Int
    }
    
    static func getCourses(from jsonData: Any)  -> [Course] {
        
        guard let jsonData = jsonData as? Array<[String: Any]> else { return [] }
        
        return jsonData.compactMap{ Course(dictCourse: $0) }
        
        /* выше тоже самое, только в одну строку
        var courses: [Course] = []
        for dictCourse in jsonData {
            let course = Course(dictCourse: dictCourse)
            courses.append(course)
        }
        return courses
 */
    }
 
}

struct WebsiteDestraction: Decodable {
    let courses: [Course]?
    let websiteDescription: String?
    let websiteName: String?

}
