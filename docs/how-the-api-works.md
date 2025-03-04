# How the Blockchain API Methods Work Together

Think of your blockchain API as a set of tools that work together to track money through a banking system. Here's how the methods work together in simple terms:

## Adding Transactions
- When someone sends money, you use `POST /transactions` to record this
- The transaction includes sender, receiver, amount, and payment method
- It also tracks the original source of the money
- This transaction sits in a "pending" pool waiting to be added to a block

## Creating Blocks
- After collecting several transactions, you use `POST /mine` to bundle them into a block
- This is like closing a page in a ledger book before starting a new one
- Each block is linked to the previous one through its "hash" (digital fingerprint)
- Once in a block, transactions become permanent and can't be changed

## Viewing Data
- `GET /chain` shows the entire blockchain - all blocks and their transactions
- `GET /pending-transactions` shows transactions waiting to be added to a block
- `GET /accounts/{id}/transactions` shows all transactions for a specific account
- `GET /transactions/{id}` retrieves details about a specific transaction

## Following Money
- `GET /trace` follows the path of money from a starting point through the system
- This shows you how money from one source (like a bank) moves through many accounts
- It maintains the original source information even after many transfers

## Finding Suspicious Activities
- `POST /suspicious` finds transactions using specific payment methods that might indicate fraud
- This helps identify potential money laundering or other financial crimes

All these methods work together to create a complete system that:
1. Records all money movements
2. Groups them into tamper-proof blocks
3. Links blocks into a chronological chain
4. Provides tools to trace money's origin and path through the system

The power comes from how these simple operations combine to create a complete audit trail that can't be altered - giving you full visibility into how money moves through the system.