/**
 * 20251261 장문기
 * 쇼핑몰 룰렛 이벤트 서비스
 */
package kr.ac.dy.cs.roulette;

import java.util.Random;

public class RouletteService {
    private final RouletteRepository repository = new RouletteRepository();

    public int spin(String userId) {
        if (repository.alreadyPlayedToday(userId)) return -1;

        int[] rewards = {0,10,30,50,100};
        int point = rewards[new Random().nextInt(rewards.length)];

        repository.insert(RouletteDto.builder()
                .userId(userId)
                .point(point)
                .build());

        return point;
    }
}
