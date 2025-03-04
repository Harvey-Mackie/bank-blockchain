package com.example.blockchain.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TransactionRequest {
    private String sender;
    private String receiver;
    private double amount;
    private String paymentScheme;
    private String source;
}