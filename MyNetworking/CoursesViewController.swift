//
//  CoursesViewController.swift
//  MyNetworking
//
//  Created by Vasilii on 22/08/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import UIKit

class CoursesViewController: UITableViewController {
    
    private let jsonUrlOne = "https://swiftbook.ru//wp-content/uploads/api/api_course"
    private let jsonUrlTwo = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let jsonUrlThree = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
    private let jsonUrlFour = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
    
    private var courses: [Course] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CourseCell

        let course = courses[indexPath.row]
       cell.configure(with: course)

        return cell
    }
    
    // MARK: - TableViewdelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func fetchDataV1() { // простой словарь
        guard let url = URL(string: jsonUrlOne) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            //создаем экземпляр структуры модел с данными из сети, Course.self - модел как тип данных и декодер сам распарсивает данные по модели, т.к. там те же поля
            do {
                let course = try JSONDecoder().decode(Course.self, from: data)
                print(course.name ?? "")
                print(course.imageUrl ?? "")
            } catch let error {
                print(error.localizedDescription)
            }

        }.resume()
    }
    
    func fetchDataV2() {// массив словарей
        
        guard let url = URL(string: jsonUrlTwo) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            //создаем экземпляр структуры модел с данными из сети, Course.self - модел как тип данных и декодер сам распарсивает данные по модели, т.к. там те же поля
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data)
                print(courses)
            } catch let error {
                print(error.localizedDescription)
            }
            
            }.resume()
    }
    
    func fetchDataV3() {//массив словарей (два) и два новых значения (другие данные и модель) - создаем новую модель
        guard let url = URL(string: jsonUrlThree) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            //создаем экземпляр структуры модел с данными из сети, Course.self - модел как тип данных и декодер сам распарсивает данные по модели, т.к. там те же поля
            do {
                let websiteDescription = try JSONDecoder().decode(WebsiteDestraction.self, from: data)
                print(websiteDescription.courses ?? [])
                print(websiteDescription.websiteDescription ?? "")
                print(websiteDescription.websiteName ?? "")
            } catch let error {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    func fetchDataV4() {//есть пропущенные поля
        guard let url = URL(string: jsonUrlFour) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            //создаем экземпляр структуры модел с данными из сети, Course.self - модел как тип данных и декодер сам распарсивает данные по модели, т.к. там те же поля
            do {
                let websiteDescription = try JSONDecoder().decode(WebsiteDestraction.self, from: data)
                print(websiteDescription.courses ?? [])
                print(websiteDescription.websiteDescription ?? "nil")
                print(websiteDescription.websiteName ?? "nil")
            } catch let error {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    func fetchData() {
        guard let url = URL(string: jsonUrlTwo) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            //создаем экземпляр структуры модел с данными из сети, Course.self - модел как тип данных и декодер сам распарсивает данные по модели, т.к. там те же поля
            do {
                self.courses = try JSONDecoder().decode([Course].self, from: data) // массив создаим в классе
            } catch let error {
                print(error.localizedDescription)
            }
            
            }.resume()
        
    }
}
