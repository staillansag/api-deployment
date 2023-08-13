. ./scripts/00_Utils.sh

echo "APIGW_URL         = ${APIGW_URL}"
echo "APIGW_USERNAME    = ${APIGW_USERNAME}"
echo "API_ID            = ${API_ID}"

if [ -z "$API_ID" ]; then
    echo "API_ID is empty - API wasn't created so nothing to do"
    exit 0
fi

RESPONSE=$(curl -s --location --request DELETE "${APIGW_URL}/apis/${API_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD})

ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "--- API deletion failed: $ERROR_DETAILS"
    exit 1
fi
