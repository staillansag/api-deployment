. ./scripts/00_Utils.sh

echo "APIGW_URL         = ${APIGW_URL}"
echo "APIGW_USERNAME    = ${APIGW_USERNAME}"
echo "SPEC_TYPE         = ${SPEC_TYPE}"
echo "API_SPEC_FILE     = ${API_SPEC_FILE}"
echo "API_NAME          = ${API_NAME}"
echo "API_VERSION       = ${API_VERSION}"

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
    exit 1
else
    # We store the API ID in the pipeline
    API_ID=$(echo $RESPONSE | jq -r '.apiResponse.api.id')
    echo "##vso[task.setvariable variable=API_ID;]${API_ID}"

    # We also store the ID of the default policy attached to this API
    API_POLICY_ID=$(echo $RESPONSE | jq -r '.apiResponse.api.policies[0]')
    echo "##vso[task.setvariable variable=API_POLICY_ID;]${API_POLICY_ID}"
fi

echo "API_ID            = ${API_ID}"
echo "API_POLICY_ID     = ${API_POLICY_ID}"
