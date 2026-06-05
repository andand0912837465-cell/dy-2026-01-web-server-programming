package kr.ac.dy.cs.shooppingmallmemo;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@RequiredArgsConstructor
@Controller
public class IndexController {

    private final MemoService memoService;

    @GetMapping("/")
    public String index() {

        memoService.add("메모내용!!");

        return "index";
    }


}
