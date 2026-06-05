package kr.ac.dy.cs.shooppingmallmemo;


import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name="memo")
public class Memo {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name="id")
    Long id;

    @Column(name="memo", length = 255)
    String memo;

    @Column(name="create_at")
    LocalDateTime createAt;
}
