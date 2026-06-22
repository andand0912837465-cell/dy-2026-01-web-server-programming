package com.shop.config;

import com.shop.entity.Member;
import com.shop.entity.Product;
import com.shop.repository.MemberRepository;
import com.shop.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final ProductRepository productRepository;
    private final MemberRepository memberRepository;

    @Override
    public void run(String... args) {
        // 어드민 계정 생성
        if (!memberRepository.existsByEmail("admin@shop.com")) {
            memberRepository.save(Member.builder()
                    .email("admin@shop.com")
                    .role("ADMIN")
                    .build());
        }

        // 샘플 상품 등록
        if (productRepository.count() == 0) {
            productRepository.save(Product.builder()
                    .name("오버사이즈 무지 티셔츠").brand("MUSINSA STANDARD").price(29000)
                    .category("TOP").stock(100).imageUrl("https://picsum.photos/seed/p1/400/500")
                    .description("편안한 오버사이즈 핏의 베이직 티셔츠. 어떤 코디에도 잘 어울립니다.").build());
            productRepository.save(Product.builder()
                    .name("워싱 데님 팬츠").brand("MUSINSA STANDARD").price(59000)
                    .category("BOTTOM").stock(80).imageUrl("https://picsum.photos/seed/p2/400/500")
                    .description("빈티지한 워싱 처리로 완성된 데님 팬츠. 슬림한 실루엣이 특징입니다.").build());
            productRepository.save(Product.builder()
                    .name("코튼 후드 집업").brand("COVERNAT").price(89000)
                    .category("TOP").stock(60).imageUrl("https://picsum.photos/seed/p3/400/500")
                    .description("부드러운 코튼 소재의 후드 집업. 캐주얼한 스트릿 무드를 연출해보세요.").build());
            productRepository.save(Product.builder()
                    .name("와이드 카고 팬츠").brand("CARHARTT").price(129000)
                    .category("BOTTOM").stock(45).imageUrl("https://picsum.photos/seed/p4/400/500")
                    .description("실용적인 카고 포켓이 달린 와이드 팬츠. 트렌디한 실루엣을 완성합니다.").build());
            productRepository.save(Product.builder()
                    .name("울 체크 오버코트").brand("WOOL&THE GANG").price(259000)
                    .category("OUTER").stock(30).imageUrl("https://picsum.photos/seed/p5/400/500")
                    .description("고급 울 소재로 만든 클래식한 체크 패턴 오버코트입니다.").build());
            productRepository.save(Product.builder()
                    .name("레더 로우탑 스니커즈").brand("NEW BALANCE").price(119000)
                    .category("SHOES").stock(70).imageUrl("https://picsum.photos/seed/p6/400/500")
                    .description("클래식한 디자인의 레더 소재 로우탑 스니커즈. 다양한 코디에 활용하세요.").build());
            productRepository.save(Product.builder()
                    .name("미니멀 캔버스 토트백").brand("STANDARD SUPPLY").price(49000)
                    .category("ACC").stock(90).imageUrl("https://picsum.photos/seed/p7/400/500")
                    .description("실용적이고 심플한 디자인의 캔버스 토트백입니다.").build());
            productRepository.save(Product.builder()
                    .name("스트레치 슬랙스").brand("THEORY").price(98000)
                    .category("BOTTOM").stock(55).imageUrl("https://picsum.photos/seed/p8/400/500")
                    .description("신축성이 뛰어난 슬랙스로 편안한 착용감을 자랑합니다.").build());
            productRepository.save(Product.builder()
                    .name("덕다운 패딩 조끼").brand("PATAGONIA").price(189000)
                    .category("OUTER").stock(40).imageUrl("https://picsum.photos/seed/p9/400/500")
                    .description("가벼우면서 보온성이 뛰어난 덕다운 소재의 패딩 조끼입니다.").build());
            productRepository.save(Product.builder()
                    .name("크루넥 니트 스웨터").brand("POLO RALPH LAUREN").price(149000)
                    .category("TOP").stock(65).imageUrl("https://picsum.photos/seed/p10/400/500")
                    .description("부드러운 울 혼방 소재의 클래식 크루넥 니트 스웨터입니다.").build());
            productRepository.save(Product.builder()
                    .name("척 테일러 하이탑").brand("CONVERSE").price(89000)
                    .category("SHOES").stock(100).imageUrl("https://picsum.photos/seed/p11/400/500")
                    .description("영원한 클래식, 척 테일러 하이탑 스니커즈입니다.").build());
            productRepository.save(Product.builder()
                    .name("버킷햇").brand("STUSSY").price(45000)
                    .category("ACC").stock(80).imageUrl("https://picsum.photos/seed/p12/400/500")
                    .description("스트릿 감성을 더해주는 버킷햇. 다양한 컬러로 스타일링을 완성하세요.").build());
        }
    }
}
