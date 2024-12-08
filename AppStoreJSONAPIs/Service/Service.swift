//
//  Service.swift
//  AppStoreJSONAPIs
//
//  Created by Varshaa vasundra sivakumar on 04/11/24.
//

import Foundation

//MARK: Service class
class Service{
    
    static let shared = Service() // singleton object
    // func to fetch json data for itunes search
    func fetchApps(searchTerm: String,completion: @escaping (SearchResult?,Error?) -> ()){
        print("Fetching itunes apps from service layer")
        
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        
        fetchGenericJSONData(urlString: urlString, completion: completion)
        
    }
    // func to fetch rss json url data
    func fetchTopPaid(completion: @escaping (AppGroup?, Error?) -> ()){
        let urlString = "https://rss.applemarketingtools.com/api/v2/us/apps/top-paid/50/apps.json"
        fetchAppGroup(urlString: urlString, completion: completion)
        
    }
    
    func fetchTopFree(completion: @escaping (AppGroup?, Error?) -> ()){
        fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/50/apps.json", completion: completion)
    }
    // helper, to fetch and decode JSON data
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    func fetchSocialApps(completion: @escaping([SocialApp]?,Error?) -> Void){
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    //declare my json function here
    //Generic is to declare the Type later
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()){
        
//        print("T is of type: ",T.self)
        
        guard let url = URL(string: urlString ) else { return }
        //fetch data from internet
        URLSession.shared.dataTask(with: url) { data, resp, err in
            //failure means , will exit the closure
            if let err = err {
                completion(nil, err)
                return
            }
            do {
                let objects = try JSONDecoder().decode(T.self,from: data!) // T.self to represent the actual class object
                //success
                completion(objects, nil)
            } catch {
                completion(nil, error)
//                print("Failed to decode", error)
            }
        }.resume() // fires off the request
    }
}
