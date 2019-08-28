//
//  ImageViewController.swift
//  MyNetworking
//
//  Created by Vasilii on 22/08/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    private let imageUrl = "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage()
        activityIndicator.startAnimating()// запускаем индикатор загрузки
        activityIndicator.hidesWhenStopped = true // скрываем после остановки

    }
    
    private func fetchImage() {
        guard let url = URL(string: imageUrl) else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {// если ошибка выходим из метода
                print(error.localizedDescription)
                return
            }
            if let response = response {
                print(response)
            }
            if let data = data, let image = UIImage(data: data) {
                //выходим в главный поток, т.к. загрузка из сети идет в фоновом
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.imageView.image = image
                }
            }
        }.resume() //чтобы появились данные ОБЯЗАТЕЛЬНО!
    }

}
