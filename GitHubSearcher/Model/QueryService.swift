import Foundation

class QueryService {

    let defaultSession = URLSession(configuration: .default)

    var queryDataTask: URLSessionDataTask?
    var userDataTask: URLSessionDataTask?
    var repoDataTask: URLSessionDataTask?
    var errorMessage = ""

    typealias QueryResult = (SearchQueryResponse?, String) -> Void
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        guard searchTerm.isEmpty == false else { return }
        cancelRunningTask(task: queryDataTask)
        if var urlComponents = URLComponents(string: ApiEndPts.userSearchUrl) {
            urlComponents.query = "q=\(searchTerm)"
            guard let url = urlComponents.url else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            self.queryDataTask = getResponseFromRequest(request: request, completion: completion)
        }
    }

    func getUserDetail(userId: String, completion: @escaping (UserDetail?, String) -> Void) {
        cancelRunningTask(task: userDataTask)
        guard let url = URL(string: ApiEndPts.userUrl + userId) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.userDataTask = getResponseFromRequest(request: request, completion: completion)
    }


    func getUserRepos(userId: String, completion: @escaping ([Repo]?, String) -> Void) {
        cancelRunningTask(task: repoDataTask)
        guard let url = URL(string: ApiEndPts.userUrl + userId + "/repos") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.repoDataTask = getResponseFromRequest(request: request, completion: completion)
    }

    private func cancelRunningTask(task: URLSessionDataTask?) {
        if task?.state == .running {
            task?.cancel()
        }
    }

    private func getResponseFromRequest<T: Codable>(request: URLRequest, completion: @escaping (T?, String) -> Void) -> URLSessionDataTask {

        var request = request
        request.setValue(Environment.apiStandard, forHTTPHeaderField: "Accept")
        request.setValue(Environment.apiToken, forHTTPHeaderField: "Authorization")

        let task = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {

                let parsedData: T? = self?.decodeResponseData(data)
                completion(parsedData, self?.errorMessage ?? "")
            }
        }
        task.resume()
        return task
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
