. ./scripts/00_Utils.sh

echo "APIGW_URL         = ${APIGW_URL}"
echo "APIGW_USERNAME    = ${APIGW_USERNAME}"
echo "API_ID            = ${API_ID}"
echo "API_POLICY_ID     = ${API_POLICY_ID}"

if [[ ! -f "./templates/enforcements.json" ]]; then
    echo "The enforcements.json file does not exist in the templates folder"
    exit 1
fi

# We create a copy of the enforcements template json file

cp ./templates/enforcements.json ./tmp_enforcements.json

# We then create the individual policy enforcement according the the specifications found in the manifest.json file
# Each time we create a policy enforcement, we enrich the enforcements template with its ID

array_length=$(jq '.transport | length' manifest.json)
if [ "$array_length" -gt 0 ]; then
    createPolicyEnforcement "./templates/transport.jq" "manifest.json" "transport" "./tmp_enforcements.json"
fi

if jq -e 'has("iam")' manifest.json > /dev/null; then
    createPolicyEnforcement "./templates/iam.jq" "manifest.json" "IAM" "./tmp_enforcements.json"
fi

if jq -e 'has("requestTransformations")' manifest.json > /dev/null; then
    createPolicyEnforcement "./templates/reqt.jq" "manifest.json" "requestPayloadProcessing" "./tmp_enforcements.json"
fi

if jq -e 'has("requestValidation")' manifest.json > /dev/null; then
    createPolicyEnforcement "./templates/reqv.jq" "manifest.json" "requestPayloadProcessing" "./tmp_enforcements.json"
fi

if jq -e 'has("routing")' manifest.json > /dev/null; then
    createPolicyEnforcement "./templates/strouting.jq" "manifest.json" "routing" "./tmp_enforcements.json"
fi

if jq -e 'has("backendAuthentication")' manifest.json > /dev/null; then
    createPolicyEnforcement "./templates/beauth.jq" "manifest.json" "routing" "./tmp_enforcements.json"
fi

if jq -e 'has("throttling")' manifest.json > /dev/null; then
    createPolicyEnforcement "./templates/throttling.jq" "manifest.json" "LMT" "./tmp_enforcements.json"
fi

if jq -e 'has("caching")' manifest.json > /dev/null; then
    createPolicyEnforcement "./templates/caching.jq" "manifest.json" "LMT" "./tmp_enforcements.json"
fi

if jq -e 'has("responseTransformations")' manifest.json > /dev/null; then
    createPolicyEnforcement "./templates/rest.jq" "manifest.json" "responseProcessing" "./tmp_enforcements.json"
fi

if jq -e 'has("responseValidation")' manifest.json > /dev/null; then
    createPolicyEnforcement "./templates/resv.jq" "manifest.json" "responseProcessing" "./tmp_enforcements.json"
fi

# Then we update the default policy with the content of the enforcements template

json=$(curl -s --location --request GET "${APIGW_URL}/policies/${POLICY_ID}" \
    -u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
    --header 'accept: application/json' | jq --slurpfile replacement tmp_enforcements.json '.policy.policyEnforcements = $replacement[0]')

RESPONSE=$(curl -s --location --request PUT "${APIGW_URL}/policies/${POLICY_ID}" \
-u ${APIGW_USERNAME}:${APIGW_PASSWORD} \
--header 'accept: application/json' \
--header 'Content-Type: application/json' \
--data-raw "${json}")

ERROR_DETAILS=$(echo $RESPONSE | jq -r '.errorDetails')

if [ "$ERROR_DETAILS" != "null" ] ; then
    echo "Policy update failed: $ERROR_DETAILS"
    exit 1
fi
