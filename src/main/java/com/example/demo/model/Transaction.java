package com.example.demo.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    @Builder.Default
    private String transactionId = UUID.randomUUID().toString();
    private String sender;
    private String receiver;
    private double amount;
    private String paymentScheme;
    @Builder.Default
    private LocalDateTime timestamp = LocalDateTime.now();
    private String source;
}
