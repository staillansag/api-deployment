. ./scripts/00_Utils.sh

SPEC_TYPE=$(jq -r '.metadata.specificationType' manifest.json)
API_SPEC_FILE=$(jq -r '.metadata.specificationFile' manifest.json)
API_NAME=$(jq -r '.metadata.name' manifest.json)
API_VERSION=$(jq -r '.metadata.version' manifest.json)

# Checking API metadata and existence of file
# We also inject key metadata into the pipeline variables

if [ "$SPEC_TYPE" == "null" ] ; then
    echo "metadata.specificationType missing"
    exit 1
else   
    echo "##vso[task.setvariable variable=SPEC_TYPE;]${SPEC_TYPE}"
fi

if [ "$API_SPEC_FILE" == "null" ] ; then
    echo "metadata.specificationFile missing"
    exit 1
else   
    echo "##vso[task.setvariable variable=API_SPEC_FILE;]${API_SPEC_FILE}"
fi

if [[ ! -f "$API_SPEC_FILE" ]]; then
    echo "The API specification file $API_SPEC_FILE does not exist."
    exit 1
fi

if [ "$API_NAME" == "null" ] ; then
    echo "metadata.name missing"
    exit 1
else   
    echo "##vso[task.setvariable variable=API_NAME;]${API_NAME}"
fi

if [ "$API_VERSION" == "null" ] ; then
    echo "metadata.version missing"
    exit 1
else   
    echo "##vso[task.setvariable variable=SPEC_TYPE;]${API_VERSION}"
fi

# Checking policies. We need at least a transport policy and a routing policy

array_length=$(jq '.transport | length' Meta.json)
if [ "$array_length" -eq 0 ]; then
    echo "transport information missing"
    exit 1
fi

ROUTING=$(jq -r '.routing' manifest.json)
if [ "$ROUTING" == "null" ] ; then
    echo "routing information missing"
    exit 1
fi