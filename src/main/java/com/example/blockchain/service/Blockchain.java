package com.example.blockchain.service;

import com.example.blockchain.model.Block;
import com.example.blockchain.model.Transaction;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class Blockchain {
    private List<Block> chain = new ArrayList<>();
    private List<Transaction> pendingTransactions = new ArrayList<>();

    public Blockchain() {
        // Create genesis block
        List<Transaction> genesisTransactions = new ArrayList<>();
        genesisTransactions.add(Transaction.builder()
                .sender("GENESIS")
                .receiver("SYSTEM")
                .amount(0.0)
                .paymentScheme("GENESIS")
                .source("N/A")
                .build());

        Block genesisBlock = Block.builder()
                .index(0)
                .timestamp(LocalDateTime.now())
                .transactions(genesisTransactions)
                .previousHash("0")
                .build();

        genesisBlock.calculateHash();
        chain.add(genesisBlock);
    }

    public void addTransaction(String sender, String receiver, double amount,
                               String paymentScheme, String source) {
        Transaction transaction = Transaction.builder()
                .sender(sender)
                .receiver(receiver)
                .amount(amount)
                .paymentScheme(paymentScheme)
                .source(source)
                .build();

        pendingTransactions.add(transaction);
    }

    public Block createBlock() {
        if (pendingTransactions.isEmpty()) {
            return null;
        }

        int newIndex = chain.size();
        Block newBlock = Block.builder()
                .index(newIndex)
                .timestamp(LocalDateTime.now())
                .transactions(new ArrayList<>(pendingTransactions))
                .previousHash(chain.get(newIndex - 1).getHash())
                .build();

        newBlock.calculateHash();
        chain.add(newBlock);

        // Clear pending transactions
        pendingTransactions = new ArrayList<>();

        return newBlock;
    }

    public List<Transaction> getTransactionsForAccount(String accountId) {
        List<Transaction> result = new ArrayList<>();

        for (Block block : chain) {
            for (Transaction tx : block.getTransactions()) {
                if (tx.getSender().equals(accountId) || tx.getReceiver().equals(accountId)) {
                    result.add(tx);
                }
            }
        }

        return result;
    }

    public List<Transaction> traceMoney(String sourceAccount, double amount) {
        List<Transaction> moneyTrail = new ArrayList<>();
        List<String> visited = new ArrayList<>();

        traceMoneyRecursive(sourceAccount, amount, moneyTrail, visited);

        return moneyTrail;
    }

    private void traceMoneyRecursive(String accountId, double amount,
                                     List<Transaction> trail, List<String> visited) {
        if (visited.contains(accountId)) {
            return; // Prevent cycles
        }

        visited.add(accountId);

        for (Block block : chain) {
            for (Transaction tx : block.getTransactions()) {
                if (tx.getSender().equals(accountId) && !trail.contains(tx)) {
                    trail.add(tx);
                    traceMoneyRecursive(tx.getReceiver(), tx.getAmount(), trail, visited);
                }
            }
        }
    }

    public List<Transaction> findSuspiciousTransactions(List<String> suspiciousSchemes) {
        List<Transaction> suspicious = new ArrayList<>();

        for (Block block : chain) {
            for (Transaction tx : block.getTransactions()) {
                if (suspiciousSchemes.contains(tx.getPaymentScheme())) {
                    suspicious.add(tx);
                }
            }
        }

        return suspicious;
    }

    public List<Block> getChain() {
        return new ArrayList<>(chain);
    }

    public List<Transaction> getPendingTransactions() {
        return new ArrayList<>(pendingTransactions);
    }
}