//
//  APICaller.swift
//  NewsApp
//
//  Created by 赤堀雅司 on 14/5/21.
//

import Foundation

struct APIResponse: Codable {
  let articles: [Article]
}

struct Article: Codable {
  let source: Source
  let title: String
  let description: String?
  let url: String?
  let urlToImage: String?
  let publishedAt: String
}

struct Source: Codable {
  let name: String
}

final class APICaller {
  static let shared = APICaller()
  
  struct Constants {
    static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=eda6154a62744b7bbad849130a7f7b6f&q=ethereum")
    static let searchUrlString =  "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=eda6154a62744b7bbad849130a7f7b6f&q=crypto&q="
  }
  
  private init() {}
  
  public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
    guard let url = Constants.topHeadlinesURL else {
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        completion(.failure(error))
      }
      else if let data = data {
        do {
          let result = try JSONDecoder().decode(APIResponse.self, from: data)
          print("Articles: \(result.articles.count)")
          completion(.success(result.articles))
        }
        catch {
          completion(.failure(error))
        }
      }
    }
    task.resume()
  }
  
  
  public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
    guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
      return
    }
    let urlString = Constants.searchUrlString + query
    guard let url = URL(string: urlString) else {
      return
    }
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error = error {
        completion(.failure(error))
      }
      else if let data = data {
        do {
          let result = try JSONDecoder().decode(APIResponse.self, from: data)
          print("Articles: \(result.articles.count)")
          completion(.success(result.articles))
        }
        catch {
          completion(.failure(error))
        }
      }
    }
    task.resume()
  }
}
