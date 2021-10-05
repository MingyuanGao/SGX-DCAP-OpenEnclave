#!/bin/bash

# https://software.intel.com/content/www/us/en/develop/articles/intel-software-guard-extensions-data-center-attestation-primitives-quick-install-guide.html
# https://github.com/openenclave/openenclave/blob/master/docs/GettingStartedDocs/Contributors/NonAccMachineSGXLinuxGettingStarted.md
# https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/QuoteGeneration/pccs


# Run the following command to verify if it can fetch the root CA CRL from the Intel PCK service
curl --noproxy "*" -v -k -G "https://localhost:8081/sgx/certification/v3/rootcacrl"
echo -e "\n"
