package kr.ac.dy.cs.shooppingmallmemo;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class MemoService {

    private final MemoRepository memoRepository;

    //주입!!!(생성자!!!)

    public MemoService(MemoRepository memoRepository) {
        this.memoRepository = memoRepository;
    }

    public void add(String text) {

        var memo = Memo.builder()
                .memo(text)
                .createAt(LocalDateTime.now())
                .build();
        memoRepository.save(memo);

    }

}
