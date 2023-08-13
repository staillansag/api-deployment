{
    "policyAction": {
        "id": "03733913-0040-4688-a3ca-1d1f34a87dd6",
        "names": [
            {
                "value": "Straight Through Routing",
                "locale": "en"
            }
        ],
        "templateKey": "straightThroughRouting",
        "parameters": [
            {
                "templateKey": "endpointUri",
                "values": [.routing.endpointUri]
            },
            {
                "templateKey": "method",
                "values": [.routing.method]
            },
            {
                "templateKey": "sslConfig",
                "parameters": [
                    {
                        "templateKey": "keyStoreAlias",
                        "values": [.routing.keyStoreAlias]
                    },
                    {
                        "templateKey": "keyAlias",
                        "values": [.routing.keyAlias]
                    },
                    {
                        "templateKey": "truststoreAlias",
                        "values": [.routing.truststoreAlias]
                    }
                ]
            },
            {
                "templateKey": "connectTimeout",
                "values": [.routing.connectTimeout]
            },
            {
                "templateKey": "readTimeout",
                "values": [.routing.readTimeout]
            }
        ],
        "active": false
    }
}