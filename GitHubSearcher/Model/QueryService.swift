import Foundation

class QueryService {

    let defaultSession = URLSession(configuration: .default)

    var queryDataTask: URLSessionDataTask?
    var userDataTask: URLSessionDataTask?
    var repoDataTask: URLSessionDataTask?
    var errorMessage = ""

    typealias QueryResult = (SearchQueryResponse?, String) -> Void
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        queryDataTask?.cancel()
        if var urlComponents = URLComponents(string: ApiEndPts.userSearchUrl) {
            urlComponents.query = "q=\(searchTerm)"
            guard let url = urlComponents.url else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
            request.setValue("token 9e3dbc0a8683e63c7b809b1d40b5932ed45f1ed2", forHTTPHeaderField: "Authorization")
            
            queryDataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
                defer { self?.queryDataTask = nil }
                
                if let error = error {
                    self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
//print(response.allHeaderFields["X-RateLimit-Remaining"])
                    
                    let response: SearchQueryResponse? = self?.decodeResponseData(data)
                    DispatchQueue.main.async {
                        completion(response, self?.errorMessage ?? "")
                    }
                }
            }
            
            queryDataTask?.resume()
        }
    }

    func getUserDetail(userId: String, completion: @escaping (UserDetail?, String) -> Void) {
        guard let url = URL(string: ApiEndPts.userUrl + userId) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("token 9e3dbc0a8683e63c7b809b1d40b5932ed45f1ed2", forHTTPHeaderField: "Authorization")

        userDataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            defer { self?.userDataTask = nil }

            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
//                print(response.allHeaderFields["X-RateLimit-Remaining"])

                let userDetail: UserDetail? = self?.decodeResponseData(data)
                DispatchQueue.main.async {
                    completion(userDetail, self?.errorMessage ?? "")
                }
            }
        }

        userDataTask?.resume()
    }


    func getUserRepos(userId: String, completion: @escaping ([Repo]?, String) -> Void) {
        guard let url = URL(string: ApiEndPts.userUrl + userId + "/repos") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("token 9e3dbc0a8683e63c7b809b1d40b5932ed45f1ed2", forHTTPHeaderField: "Authorization")

        repoDataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            defer { self?.repoDataTask = nil }

            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {

                let repos: [Repo]? = self?.decodeResponseData(data)
                DispatchQueue.main.async {
                    completion(repos, self?.errorMessage ?? "")
                }
            }
        }

        repoDataTask?.resume()
    }

    private func decodeResponseData<T: Codable>(_ data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let typedObject = try decoder.decode(T.self, from: data)
            return typedObject
        } catch {
            errorMessage += "Problem parsing response data\n"
            return nil
        }
    }
}
