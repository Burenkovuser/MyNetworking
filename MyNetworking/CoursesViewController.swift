//
//  CoursesViewController.swift
//  MyNetworking
//
//  Created by Vasilii on 22/08/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import UIKit
import Alamofire

class CoursesViewController: UITableViewController {
    
    private let jsonUrlOne = "https://swiftbook.ru//wp-content/uploads/api/api_course"
    private let jsonUrlTwo = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let jsonUrlThree = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
    private let jsonUrlFour = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
    private let jsonUrlFive = "https://swiftbook.ru//wp-content/uploads/api/api_courses_capital"
    
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
    
    /* тут появилась ошибка после static func getCourses $0
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
 */
    
    func fetchData() {
        guard let url = URL(string: jsonUrlFive) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            
            guard let data = data else { return }
            
            //создаем экземпляр структуры модел с данными из сети, Course.self - модел как тип данных и декодер сам распарсивает данные по модели, т.к. там те же поля
            do {
                let decoder = JSONDecoder()
                //decoder.keyDecodingStrategy = .convertFromSnakeCase //переделываем змеиное описание json в кемлкейс swift
                self.courses = try decoder.decode([Course].self, from: data) // массив создаим в классе
            } catch let error {
                print(error.localizedDescription)
            }
            
            }.resume()
    }
    func fetchDataWithAlamofire() {
        guard let url = URL(string: jsonUrlTwo) else { return }
        
        // validate() если данные проходя через этот метод с ними можно работатья
        request(url).validate().responseJSON { dataResponse in
            //guard let statusCode = dataResponse.response?.statusCode else { return }
            
            switch dataResponse.result {
            case .success(let value):
                
                self.courses = Course.getCourses(from: value)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                /* тоже переносим в модель
                guard let jsonData = value as? Array<[String: Any]> else { return }
                for dictCourse in jsonData {
                    //по моделе смотрим, по ключу name и приоводим к типу string (перенесли это в модель
                    /*let course = Course(name: dictCourse["name"] as? String,
                                        link: dictCourse["link"] as? String,
                                        imageUrl: dictCourse["imageUrl"] as? String,
                                        numberOfLessons: dictCourse["number_of_lessons"] as? Int,
                                        numberOfTests: dictCourse["number_of_tests"] as? Int)
 */
                    let course = Course(dictCourse: dictCourse)
                    self.courses.append(course)
 */
            case .failure(let error):
                print(error)
            }
            
        
        
            /*
            if (200..<300).contains(statusCode) {
                guard let value = dataResponse.result.value else { return }
                print("value: ", value)
            } else {
                guard let error = dataResponse.result.error else { return }
                print(error)
            }
 */
        }
    }
    
    func postWithAlamofire() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        let userData: [String: Any] = [
            "name": "Networkint request",
            "link": "https://swiftbook.ru/contents/our-first-applications/",
            "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
            "numberOfLessons": "18",
            "numberOfTests": "10"
        ]
        
        request(url, method: .post, parameters: userData).validate().responseJSON { responseData in
            
            //guard let statusCode = responseData.response?.statusCode else { return }
            //print("Status code: ", statusCode)
            
            switch responseData.result {
            case .success(let value):
                
                guard let jsonData = value as? [String: Any] else { return }
                let course = Course(dictCourse: jsonData)
                
                self.courses.append(course)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
