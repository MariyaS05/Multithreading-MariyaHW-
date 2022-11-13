//
//  ViewController.swift
//  MultithreadingMariyaHW
//
//  Created by Мария  on 13.11.22.
//


import UIKit
struct Photo: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}
struct PostElement: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
struct Comment: Codable {
    let postID, id: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}
struct Album: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}

typealias Albums = [Album]
typealias Comments = [Comment]
typealias Post = [PostElement]
typealias Photos = [Photo]

class ViewController: UIViewController {
let group =  DispatchGroup()
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue1 =  DispatchQueue(label: "1", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)
        let queue2 =  DispatchQueue(label: "2", qos: DispatchQoS.userInteractive, attributes: DispatchQueue.Attributes.concurrent)
        let queue3 =  DispatchQueue(label: "3", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent)
        let queue4 =  DispatchQueue(label: "4", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent)
        group.enter()
        queue1.async {
            guard let mainUrl = Bundle.main.url(forResource: "photos", withExtension: "json") else {
                return
            }
            guard let data  =  try? Data(contentsOf: mainUrl ) else {return}
            let jsonDecoder = JSONDecoder()
            let finalData = try? jsonDecoder.decode(Photo.self, from: data)
            DispatchQueue.main.async {
                print("\(queue1.label) is loaded")
            }
            self.group.leave()
        }
        group.enter()
        queue2.async {
            guard let mainUrl = Bundle.main.url(forResource: "posts", withExtension: "json") else {
                return
            }
            guard let data  =  try? Data(contentsOf: mainUrl ) else {return}
            let jsonDecoder = JSONDecoder()
            let finalData = try? jsonDecoder.decode(PostElement.self, from: data)
            DispatchQueue.main.async {
                print("\(queue2.label) is loaded")
            }
            self.group.leave()
        }
        group.enter()
        queue3.async {
            guard let mainUrl = Bundle.main.url(forResource: "comments", withExtension: "json") else {
                return
            }
            guard let data  =  try? Data(contentsOf: mainUrl ) else {return}
            let jsonDecoder = JSONDecoder()
            let finalData = try? jsonDecoder.decode(Comment.self, from: data)
            DispatchQueue.main.async {
                print("\(queue3.label) is loaded")
            }
            self.group.leave()
        }
        group.enter()
        queue4.async {
            guard let mainUrl = Bundle.main.url(forResource: "albums", withExtension: "json") else {
                return
            }
            guard let data  =  try? Data(contentsOf: mainUrl ) else {return}
            let jsonDecoder = JSONDecoder()
            let finalData = try? jsonDecoder.decode(Album.self, from: data)
            DispatchQueue.main.async {
                print("\(queue4.label) is loaded")
            }
            self.group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            print("Все ресурсы загружены")
            
        }
        
        
    }


}

