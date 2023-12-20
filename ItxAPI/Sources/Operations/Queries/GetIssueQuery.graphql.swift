// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetIssueQuery: GraphQLQuery {
  public static let operationName: String = "GetIssue"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetIssue($issueId: ID!) { issue(id: $issueId) { __typename id description title } }"#
    ))

  public var issueId: ID

  public init(issueId: ID) {
    self.issueId = issueId
  }

  public var __variables: Variables? { ["issueId": issueId] }

  public struct Data: ItxAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { ItxAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("issue", Issue.self, arguments: ["id": .variable("issueId")]),
    ] }

    public var issue: Issue { __data["issue"] }

    /// Issue
    ///
    /// Parent Type: `Issue`
    public struct Issue: ItxAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { ItxAPI.Objects.Issue }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", ItxAPI.ID.self),
        .field("description", String.self),
        .field("title", String.self),
      ] }

      public var id: ItxAPI.ID { __data["id"] }
      public var description: String { __data["description"] }
      public var title: String { __data["title"] }
    }
  }
}
