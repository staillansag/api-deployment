{
    types: ["API"],
    scope: [
        {
            attributeName: "apiName",
            keyword: .metadata.name
        }
    ],
    responseFields: [
        "apiName",
        "apiVersion",
        "id"
    ],
    condition: "and"
}