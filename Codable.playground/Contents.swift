//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

// Let asynchronous code run
PlaygroundPage.current.needsIndefiniteExecution = true


/// Test mapping with new Swift4 codable interface


struct Country : Codable {
    var name:String
    var region:String
}

if let url = URL(string:"https://restcountries.eu/rest/v2/all") {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print(error)
            PlaygroundPage.current.finishExecution()
        }
        guard let data = data,
            let countries = try? JSONDecoder().decode([Country].self, from: data) as [Country]  else {
                PlaygroundPage.current.finishExecution()
        }
        countries.forEach {
            print("Country: " + $0.name)
        }
        PlaygroundPage.current.finishExecution()
    }
    task.resume()
}
