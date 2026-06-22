
/*
 20251261 장문기
 쇼핑몰 룰렛 이벤트 결과 저장 DTO
 */

package kr.ac.dy.cs.roulette;

import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RouletteDto {
    private String userId;
    private int point;
}
