// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class DummyQuery: GraphQLQuery {
  public static let operationName: String = "dummyQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query dummyQuery { __typename }"#
    ))

  public init() {}

  public struct Data: ItxAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { ItxAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
    ] }
  }
}
