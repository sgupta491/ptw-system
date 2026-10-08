package com.ptw.ptw.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "work_request_trade_master",
        uniqueConstraints = {@UniqueConstraint(columnNames = "trade_code"),
          @UniqueConstraint(name = "uk_work_request_trade_name", columnNames = "trade_name")}
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WorkRequestTradeMaster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "trade_code", nullable = false, length = 50)
    private String tradeCode;

    @Column(name = "trade_name", nullable = false, length = 100)
    private String tradeName;

    @Builder.Default
    @Column(name = "active", nullable = false)
    private Boolean active = true;
}