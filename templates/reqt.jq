{
  "policyAction": {
    "names": [
      {
        "value": "Request Transformation",
        "locale": "en"
      }
    ],
    "templateKey": "requestTransformation",
    "parameters": [
      {
        "templateKey": "transformationConditions",
        "parameters": [
          {
            "templateKey": "logicalConnector",
            "values": ["OR"]
          }
        ]
      },
      {
        "templateKey": "requestTransformationConfiguration",
        "parameters": 
        .requestTransformations[0].requestTransformationConfigurations | map(
          if .type == "addOrModify" then
            {
              "templateKey": "commonTransformation",
              "parameters": [
                {
                  "templateKey": "addOrModify",
                  "parameters": [
                    {
                      "templateKey": "transformationVariable",
                      "values": [.target]
                    },
                    {
                      "templateKey": "transformationValue",
                      "values": [.value]
                    }
                  ]
                }
              ]
            }
          elif .type == "remove" then
            {
              "templateKey": "commonTransformation",
              "parameters": [
                {
                  "templateKey": "remove",
                  "values": [.target]
                }
              ]
            }
          else
            .
          end
        )
      }
    ],
    "active": false
  }
}
