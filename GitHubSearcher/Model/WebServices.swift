import UIKit

class WebServices {

    static let cache = LocalCache<String, Data>.init()

    static func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> Void) {
        if let cachedImg = WebServices.cache[urlString] {
            closure(UIImage(data: cachedImg))
        } else {
            guard let url = URL(string: urlString) else { return closure(nil) }

            let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    //                print("error: \(String(describing: error))")
                    return closure(nil)
                }
                guard response != nil else {
                    print("no response")
                    return closure(nil)
                }
                guard let data = data, data.count > 64 else {
                    print("no data")
                    return closure(nil)
                }
                WebServices.cache[urlString] = data
                closure(UIImage(data: data))
            }; task.resume()
        }
    }
}
