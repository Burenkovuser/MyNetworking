//
//  MainViewController.swift
//  MyNetworking
//
//  Created by Vasilii on 22/08/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import UIKit

enum UserActions: String, CaseIterable {//подписали на string чтобы сделать красивый шрифт в отображении на экране и CaseIterable позволяет сделать из любого перечисления массив
    case downloadImage = "Download Image"
    case exampleOne = "Example One"
    case exampleTwo = "Example Two"
    case exampleThree = "Example Three"
    case exampleFour = "Example Four"
    case ourCourses = "Our Courses"
    case postRequest = "POST Request"
    case ourCoursesAlamofire = "Our Courses Alamofire"
    case postAlamofire = "POST with Alamofire"
}

class MainViewController: UICollectionViewController {
    
    private let userActions = UserActions.allCases //возвращает члены перечисления в виде массива


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userActions.count // создаем "кнопки" из перечисления выше
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
        
        cell.userActionLabel.text = userActions[indexPath.item].rawValue //rawValue чтобы взять стринг из кейса

        return cell
    }

    // MARK: UICollectionViewDelegate

    //вызывается каждый раз, когда мы тапаем по ячейке
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let userAction = userActions[indexPath.item] //выбираем какая ячейка нажата
        
        switch userAction {
        case .downloadImage:
            performSegue(withIdentifier: "ShowImage", sender: self) //делаем переход в зависимости от нажатия кнопки
        case .exampleOne:
            performSegue(withIdentifier: "ExampleOne", sender: self)
        case .exampleTwo:
            performSegue(withIdentifier: "ExampleTwo", sender: self)
        case .exampleThree:
            performSegue(withIdentifier: "ExampleThree", sender: self)
        case .exampleFour:
            performSegue(withIdentifier: "ExampleFour", sender: self)
        case .ourCourses:
            performSegue(withIdentifier: "OurCourses", sender: self)
        case .postRequest:
            posrRequest()
        case .ourCoursesAlamofire:
            performSegue(withIdentifier: "OurCoersesWithalamofire", sender: self)
        case .postAlamofire:
            performSegue(withIdentifier: "PostAlamofire", sender: self)
        }
    }

   
     // MARK: - Navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier != "ShowImage" {
            let coursesVC = segue.destination as! CoursesViewController
            
            //в зависимости от того, какую кнопку нажимем вызывается метод загружающий данные
            switch segue.identifier {
            case "ExampleOne":
                coursesVC.fetchDataV1()
            case "ExampleTwo":
                coursesVC.fetchDataV2()
            //case "ExampleThree":
               // coursesVC.fetchDataV3()
            //case "ExampleFour":
                //coursesVC.fetchDataV4()
            case "OurCourses":
                coursesVC.fetchData()
            case "OurCoersesWithalamofire":
                coursesVC.fetchDataWithAlamofire()
            case "PostAlamofire":
                coursesVC.postWithAlamofire()
            default:
                break
            }
        }
     }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    // в этом методе настраиваем внешний вид ячейчки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 48, height: 100)
    }
}

extension MainViewController {
    private func posrRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        //создаем словарь, который будем добавлять на сервер
        let userData = [
            "courese" : "Networking",
            "lesson" : "GET  and POST"
        ]
        
        // создаем запрос на сервер
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //правила добавления метода на сервер application/json берем из консоли "Content-Type" =     ("application/json; charset=utf-8"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // создаем из словаря json
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        // передаем json в запрос к серверу
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { (data, response, _) in
            guard let response = response, let data = data else { return }
            
            print(response)
            
            do {
               let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
}
