{
    policyAction: {
        names: [
            {
                value: "Service Result Cache",
                locale: "en"
            }
        ],
        templateKey: "serviceResultCache",
        parameters: [
            {
                templateKey: "ttl",
                values: [.caching.ttl]
            },
            {
                templateKey: "max-payload-size",
                values: [.caching.maximumPayloadSize]
            },
            {
                templateKey: "cacheCriteria",
                parameters: [
                    (.caching.cacheCriteria[] | 
                        if .type == "header" then
                            {
                                templateKey: "httpHeader",
                                parameters: [
                                    {
                                        templateKey: "httpHeaderName",
                                        values: [.name]
                                    },
                                    {
                                        templateKey: "whiteList",
                                        values: .values
                                    }
                                ]
                            }
                        elif .type == "queryParameter" then
                            {
                                templateKey: "queryParam",
                                parameters: [
                                    {
                                        templateKey: "queryParamName",
                                        values: [.name]
                                    },
                                    {
                                        templateKey: "whiteList",
                                        values: .values
                                    }
                                ]
                            }
                        else
                            empty
                        end
                    )
                ]
            }
        ],
        active: false
    }
}