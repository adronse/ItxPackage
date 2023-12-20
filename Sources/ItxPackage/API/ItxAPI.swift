//
//  File.swift
//  
//
//  Created by Adrien Ronse on 20/12/2023.
//

import Foundation
import Apollo
import ItxAPI

public class ItxAPI {
    public static let shared = ItxAPI()
    private let apollo: ApolloClient

    private init() {
        let url = URL(string: "https://api.itx.coffee/graphql")!
        self.apollo = ApolloClient(url: url)
    }

    public func executeQuery<T: GraphQLQuery>(query: T, completion: @escaping (Result<T.Data, Error>) -> Void) {
        apollo.fetch(query: query) { result in
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    completion(.success(data))
                } else if let errors = graphQLResult.errors {
                    // Handle GraphQL errors
                    let error = NSError(domain: "GraphQLErrors", code: 0, userInfo: [NSLocalizedDescriptionKey: errors.map { $0.localizedDescription }.joined(separator: "\n")])
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


extension ItxAPI {
    func getIssueTitle(_ id: String, completion: @escaping (String) -> Void) {
        let query = GetIssueQuery(issueId: id)
        executeQuery(query: query) { result in
            switch result {
            case .success(let data):
                completion(data.issue.title)
            case .failure(_):
                completion("")
            }
        }
    }
}
