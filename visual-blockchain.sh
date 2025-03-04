#!/bin/bash

# Enhanced Blockchain Visualization with better flow representation
# For use with: http://localhost:8080/api/blockchain/chain

# API URL
API_URL="http://localhost:8080/api/blockchain/chain"

# Fetch data
echo "Fetching blockchain data..."
curl -s $API_URL > blockchain.json

# Check if fetch was successful
if [ $? -ne 0 ]; then
    echo "Error: Could not connect to API"
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "This script requires jq to parse JSON"
    echo "Install with: sudo apt-get install jq"
    exit 1
fi

# Get number of blocks
BLOCK_COUNT=$(jq '. | length' blockchain.json)
echo "BLOCKCHAIN FLOW VISUALIZATION"
echo "============================="
echo "Total blocks: $BLOCK_COUNT"
echo ""

# Display each block
for i in $(seq 0 $(($BLOCK_COUNT-1))); do
    # Block header
    BLOCK_INDEX=$(jq ".[$i].index" blockchain.json)
    echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
    echo "┃                     BLOCK #$BLOCK_INDEX                    ┃"
    echo "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫"

    # Block hash
    HASH=$(jq -r ".[$i].hash" blockchain.json)
    echo "┃ Hash: ${HASH:0:16}...${HASH: -8}               ┃"

    # Previous hash for non-genesis blocks
    if [ $i -gt 0 ]; then
        PREV_HASH=$(jq -r ".[$i].previousHash" blockchain.json)
        echo "┃ Prev: ${PREV_HASH:0:16}...${PREV_HASH: -8}               ┃"
    else
        echo "┃ Prev: Genesis Block                              ┃"
    fi

    # Transactions
    TX_COUNT=$(jq ".[$i].transactions | length" blockchain.json)
    echo "┃                                                    ┃"
    echo "┃ Transactions: $TX_COUNT                                     ┃"
    echo "┃                                                    ┃"

    # Show each transaction briefly
    for j in $(seq 0 $(($TX_COUNT-1))); do
        SENDER=$(jq -r ".[$i].transactions[$j].sender" blockchain.json)
        RECEIVER=$(jq -r ".[$i].transactions[$j].receiver" blockchain.json)
        AMOUNT=$(jq -r ".[$i].transactions[$j].amount" blockchain.json)
        SCHEME=$(jq -r ".[$i].transactions[$j].paymentScheme" blockchain.json)
        SOURCE=$(jq -r ".[$i].transactions[$j].source" blockchain.json)

        # Truncate long account numbers for display
        if [ ${#SENDER} -gt 20 ]; then
            SENDER="${SENDER:0:17}..."
        fi
        if [ ${#RECEIVER} -gt 20 ]; then
            RECEIVER="${RECEIVER:0:17}..."
        fi

        echo "┃ ⮡ $SENDER → $RECEIVER ┃"
        echo "┃   Amount: £$AMOUNT via $SCHEME                ┃"
        echo "┃   Source: $SOURCE                       ┃"
        echo "┃                                                    ┃"
    done

    # Block footer
    echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"

    # Show connector to next block with chain links
    if [ $i -lt $(($BLOCK_COUNT-1)) ]; then
        echo "                        ┃                        "
        echo "                        ┃ HASH LINKED            "
        echo "                        ┃                        "
        echo "                        ▼                        "
    fi
done

# Clean up
rm blockchain.json

# Keep terminal open
echo ""
echo "End of blockchain visualization. Press Enter to exit."
read