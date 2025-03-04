#!/bin/bash

# Configuration
API_BASE_URL="http://localhost:8080/api/blockchain"

# Function to display results
display_result() {
  local title=$1
  local response=$2

  echo "$title"
  echo "----------------------------------------"
  echo "$response" | jq '.' 2>/dev/null || echo "$response"
  echo "----------------------------------------"
  echo ""
}

# Function to check if the API is up
check_api() {
  echo "Checking if blockchain API is available..."

  response=$(curl -s -X GET "$API_BASE_URL/health")

  if [ $? -ne 0 ]; then
    echo "Error: API is not available at $API_BASE_URL"
    echo "Make sure the Spring Boot application is running."
    exit 1
  else
    echo "API is available and responding!"
    display_result "API Health Status" "$response"
  fi
}

# Function to create a transaction
create_transaction() {
  local sender=$1
  local receiver=$2
  local amount=$3
  local scheme=$4
  local source=$5

  echo "Creating transaction: $sender -> $receiver ($amount via $scheme, source: $source)"

  response=$(curl -s -X POST "$API_BASE_URL/transactions" \
    -H "Content-Type: application/json" \
    -d '{
            "sender": "'$sender'",
            "receiver": "'$receiver'",
            "amount": '$amount',
            "paymentScheme": "'$scheme'",
            "source": "'$source'"
        }')

  display_result "Transaction Created" "$response"
}

# Function to mine pending transactions
mine_transactions() {
  echo "Mining pending transactions..."

  response=$(curl -s -X POST "$API_BASE_URL/mine")

  display_result "Mining Result" "$response"
}

# Function to check the blockchain
check_blockchain() {
  echo "Getting current blockchain state..."

  response=$(curl -s -X GET "$API_BASE_URL/chain")

  display_result "Blockchain State" "$response"
}

# Function to get pending transactions
get_pending() {
  echo "Getting pending transactions..."

  response=$(curl -s -X GET "$API_BASE_URL/pending-transactions")

  display_result "Pending Transactions" "$response"
}

# Function to trace money
trace_money() {
  local account=$1
  local amount=$2

  echo "Tracing money flow from $account ($amount)..."

  response=$(curl -s -X GET "$API_BASE_URL/trace?sourceAccount=$account&amount=$amount")

  display_result "Money Trail" "$response"
}

# Function to check suspicious transactions
check_suspicious() {
  echo "Checking for suspicious transactions..."

  response=$(curl -s -X POST "$API_BASE_URL/aml/suspicious" \
    -H "Content-Type: application/json" \
    -d '["Cash Deposit", "Faster Payments"]')

  display_result "Suspicious Transactions" "$response"
}

# Function to get account transactions
get_account_transactions() {
  local account=$1

  echo "Getting all transactions for account: $account"

  response=$(curl -s -X GET "$API_BASE_URL/accounts/$account/transactions")

  display_result "Account Transactions" "$response"
}

# Main simulation script
main() {
  echo "=== Lloyds Blockchain Simulation ==="
  echo "This script will simulate a series of financial transactions to demonstrate"
  echo "the transaction tracking and anti-money laundering capabilities."
  echo ""

  # Define accounts with sort codes and account numbers
  LLOYDS_ACCOUNT="30-94-57_20348751"
  EMPLOYEE_ACCOUNT="40-47-22_89123456"
  LANDLORD_ACCOUNT="20-45-18_73124589"
  TESCO_ACCOUNT="60-23-49_12398754"
  FRIEND_ACCOUNT="50-12-34_78912345"
  UNKNOWN_ACCOUNT="99-99-99_12345678"
  ACCOUNT1="12-34-56_11111111"
  ACCOUNT2="12-34-56_22222222"
  ACCOUNT3="12-34-56_33333333"
  ATM_ID="ATM_CASH_DEPOSIT_7593"

  # Check if API is available
  check_api

  # Check initial blockchain state
  check_blockchain

  echo "=== Scenario 1: Salary Payment ==="
  echo "Lloyds Bank (30-94-57 20348751) pays employee (40-47-22 89123456) their monthly salary via BACS"
  echo ""

  create_transaction "$LLOYDS_ACCOUNT" "$EMPLOYEE_ACCOUNT" 2500.00 "BACS" "$LLOYDS_ACCOUNT"
  get_pending
  mine_transactions
  check_blockchain

  echo "=== Scenario 2: Multiple Payments ==="
  echo "Employee pays rent, buys groceries, and transfers money to a friend"
  echo ""

  create_transaction "$EMPLOYEE_ACCOUNT" "$LANDLORD_ACCOUNT" 1200.00 "Standing Order" "$LLOYDS_ACCOUNT"
  create_transaction "$EMPLOYEE_ACCOUNT" "$TESCO_ACCOUNT" 85.75 "Debit Card" "$LLOYDS_ACCOUNT"
  create_transaction "$EMPLOYEE_ACCOUNT" "$FRIEND_ACCOUNT" 50.00 "Faster Payments" "$LLOYDS_ACCOUNT"
  get_pending
  mine_transactions
  check_blockchain

  echo "=== Scenario 3: Cash Deposit ==="
  echo "Unknown user makes a cash deposit and transfers to multiple accounts"
  echo ""

  create_transaction "$ATM_ID" "$UNKNOWN_ACCOUNT" 5000.00 "Cash Deposit" "Unknown"
  mine_transactions

  create_transaction "$UNKNOWN_ACCOUNT" "$ACCOUNT1" 1500.00 "Faster Payments" "Unknown"
  create_transaction "$UNKNOWN_ACCOUNT" "$ACCOUNT2" 1500.00 "Faster Payments" "Unknown"
  create_transaction "$UNKNOWN_ACCOUNT" "$ACCOUNT3" 2000.00 "Faster Payments" "Unknown"
  mine_transactions
  check_blockchain

  echo "=== Scenario 4: Money Tracing ==="
  echo "Tracing money flow from Lloyds through the system"
  echo ""

  trace_money "$LLOYDS_ACCOUNT" 2500.00

  echo "=== Scenario 5: AML Checks ==="
  echo "Checking for suspicious transactions based on payment schemes"
  echo ""

  check_suspicious

  echo "=== Scenario 6: Account Analysis ==="
  echo "Checking all transactions for the employee account"
  echo ""

  get_account_transactions "$EMPLOYEE_ACCOUNT"

  echo "=== Simulation Complete ==="
}

# Run the main simulation
main

