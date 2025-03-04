package com.example.blockchain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Block {
    private int index;
    private LocalDateTime timestamp;
    private List<Transaction> transactions;
    private String previousHash;
    private String hash;

    public void calculateHash() {
        try {
            String data = index + timestamp.toString() + transactions.toString() + previousHash;

            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = digest.digest(data.getBytes(StandardCharsets.UTF_8));

            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }

            this.hash = hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Could not calculate hash", e);
        }
    }
}
