. ./scripts/00_Utils.sh

RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/apis" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--form "type=${SPEC_TYPE}" \
--form "apiName=${API_NAME}" \
--form "apiVersion=${API_VERSION}" \
--form "file=@${API_SPEC_FILE}" | jq 'del(.apiResponse.api.apiDefinition)')

ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API creation failed: $ERROR_DETAILS"
    echo $RESPONSE | jq
    exit 1
else
    # We store the API ID in the pipeline
    API_ID=$(echo $RESPONSE | jq -r '.apiResponse.api.id')
    echo "##vso[task.setvariable variable=API_ID;]${API_ID}"

    # We also store the ID of the default policy attached to this API
    POLICY_ID=$(echo $RESPONSE | jq -r '.apiResponse.api.policies[0]')
    echo "##vso[task.setvariable variable=POLICY_ID;]${POLICY_ID}"
fi

# json=$(jq -f ./templates/searchteam.jq manifest.json)

# RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/search" \
# -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
# --header 'accept: application/json' \
# --header 'Content-Type: application/json' \
# --data-raw "${json}")

# ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')
# TEAM_ID=$(echo "$RESPONSE" | jq -r '.accessprofiles[0].id')

# if [ "$ERROR_DETAILS" != "null" ] ; then
#     echo "--- Team search failed: $ERROR_DETAILS"
#     echo $RESPONSE | jq
#     exit 1
# fi

# if [ "$TEAM_ID" == "null" ] ; then
#     echo "--- Team not found"
#     echo $RESPONSE | jq
#     exit 1
# fi

# json=$(jq -n --arg api_id "$API_ID" --arg team_id "$TEAM_ID" '{
#     "assetType": "API",
#     "assetIds": [
#         $api_id
#     ],
#     "newTeams": [
#         "Administrators",
#         $team_id
#     ]
# }')

# RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/assets/team" \
# -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
# --header 'accept: application/json' \
# --header 'Content-Type: application/json' \
# --data-raw "${json}" )

# ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')

# if [ "$ERROR_DETAILS" != "null" ] ; then
#     echo "--- API creation failed: $ERROR_DETAILS"
#     echo $RESPONSE | jq

#     deleteAPI ${API_ID}

#     exit 1
# fi

# json=$(curl -s --location --request GET "${APIGW_URL}/apis/${API_ID}" \
#     -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
#     --header 'accept: application/json' \
#     | jq -r '.apiResponse.api' \
#     | jq --slurpfile meta manifest.json '. + {
#     apiDescription: $meta[0].metadata.description,
#     apiGroups: $meta[0].metadata.groups,
#     maturityState: $meta[0].metadata.maturityState
#     }')

# RESPONSE=$(curl -s --location --request PUT "${APIGW_URL}/apis/${API_ID}" \
# -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
# --header 'accept: application/json' \
# --header 'Content-Type: application/json' \
# --data-raw "${json}" )

# ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')
# API_ID=$(echo $RESPONSE | jq -r '.apiResponse.api.id')

# if [ "$ERROR_DETAILS" != "null" ] ; then
#     echo "--- API metadata update failed: $ERROR_DETAILS"
#     echo $RESPONSE | jq
#     deleteAPI ${API_ID}
#     exit 1
# fi

# json=$(jq -f ./templates/searchscope.jq manifest.json)

# RESPONSE=$(curl -s --location --request POST "${APIGW_URL}/search" \
# -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
# --header 'accept: application/json' \
# --header 'Content-Type: application/json' \
# --data-raw "${json}")

# ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')
# SCOPE_ID=$(echo "$RESPONSE" | jq -r '.gateway_scope[0].id')

# if [ "$ERROR_DETAILS" != "null" ] ; then
#     echo "--- Oauth2 scope search failed: $ERROR_DETAILS"
#     echo $RESPONSE | jq
#     deleteAPI ${API_ID}
#     exit 1
# fi

# if [ "$SCOPE_ID" == "null" ] ; then
#     echo "--- Oauth2 scope not found"
#     echo $RESPONSE | jq
#     deleteAPI ${API_ID}
#     exit 1
# fi

# json=$(curl -s --location --request GET "${APIGW_URL}/scopes/${SCOPE_ID}" \
# -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
# --header 'accept: application/json' \
# | jq -r '.scope' \
# | jq --arg api "$API_ID" '.apiScopes += if (.apiScopes | index($api)) == null then [$api] else [] end')

# RESPONSE=$(curl -s --location --request PUT "${APIGW_URL}/scopes/${SCOPE_ID}" \
# -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
# --header 'accept: application/json' \
# --header 'Content-Type: application/json' \
# --data-raw "${json}" )

# ERROR_DETAILS=$(echo "$RESPONSE" | jq -r '.errorDetails')

# if [ "$ERROR_DETAILS" != "null" ] ; then
#     echo "--- Oauth2 scope update failed: $ERROR_DETAILS"
#     echo $RESPONSE | jq
#     deleteAPI ${API_ID}
#     exit 1
# else
#     echo "--- API created with ID ${API_ID}"
# fi