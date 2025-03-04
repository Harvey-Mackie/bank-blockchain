package com.example.demo.controller;

import com.example.demo.model.Block;
import com.example.demo.model.Transaction;
import com.example.demo.model.dto.TransactionRequest;
import com.example.demo.service.Blockchain;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/blockchain")
@RequiredArgsConstructor
class BlockchainController {
    private final Blockchain blockchain;

    @GetMapping("/chain")
    public ResponseEntity<List<Block>> getChain() {
        return ResponseEntity.ok(blockchain.getChain());
    }

    @PostMapping("/transactions")
    public ResponseEntity<String> addTransaction(@RequestBody TransactionRequest request) {
        blockchain.addTransaction(
                request.getSender(),
                request.getReceiver(),
                request.getAmount(),
                request.getPaymentScheme(),
                request.getSource()
        );

        return ResponseEntity.ok("Transaction added to pending transactions");
    }

    @PostMapping("/mine")
    public ResponseEntity<String> createBlock() {
        Block block = blockchain.createBlock();

        if (block == null) {
            return ResponseEntity.badRequest().body("No pending transactions to mine");
        }

        return ResponseEntity.ok("Block created with index: " + block.getIndex());
    }

    @GetMapping("/trace")
    public ResponseEntity<List<Transaction>> traceMoneyFlow(
            @RequestParam String account,
            @RequestParam double amount) {
        return ResponseEntity.ok(blockchain.traceMoney(account, amount));
    }

    @GetMapping("/accounts/{accountId}/transactions")
    public ResponseEntity<List<Transaction>> getAccountTransactions(@PathVariable String accountId) {
        return ResponseEntity.ok(blockchain.getTransactionsForAccount(accountId));
    }

    @PostMapping("/suspicious")
    public ResponseEntity<List<Transaction>> findSuspiciousTransactions(@RequestBody List<String> schemes) {
        return ResponseEntity.ok(blockchain.findSuspiciousTransactions(schemes));
    }

    @GetMapping("/pending")
    public ResponseEntity<List<Transaction>> getPendingTransactions() {
        return ResponseEntity.ok(blockchain.getPendingTransactions());
    }
}