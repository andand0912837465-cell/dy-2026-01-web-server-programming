/**
 * 20252031 이준성
 * Product의 비즈니스 로직 처리 클래스
 * 상품 목록 조회 시 Cache Aside 패턴 사용하여 대규모 서비스에서의 파싱으로 인한 오버헤드 문제 완화
 * 캐시에 데이터 존재할 경우 캐시 반환, 캐시에 없을 경우 DB에서 조회 후 반환
 * 상품 데이터 변경 시 캐시 무효화
 */

package kr.ac.dy.cs.product;

import java.util.Collections;
import java.util.List;

public class ProductService {

    /** 캐시 유효시간 (밀리초) - 60초 */
    private static final long TTL_MILLIS = 60_000L;

    /** 애플리케이션 전역에서 공유하는 캐시 (단순 메모리 캐시) */
    private static volatile List<ProductDto> cachedProducts = null;
    private static volatile long cachedAt = 0L;

    private final ProductRepository productRepository;

    public ProductService() {
        productRepository = new ProductRepository();
    }

    /**
     * 전체 상품 목록 조회 (Cache Aside)
     */
    public List<ProductDto> getProducts() {

        // 1) 캐시 조회 - 유효하면 그대로 반환 (Cache Hit)
        List<ProductDto> cache = cachedProducts;
        if (cache != null && !isExpired()) {
            return cache;
        }

        // 2) Cache Miss - DB 에서 읽어와 캐시에 적재
        synchronized (ProductService.class) {
            // 동시 진입 시 먼저 채운 스레드의 결과를 재사용
            if (cachedProducts != null && !isExpired()) {
                return cachedProducts;
            }

            List<ProductDto> products = productRepository.selectAll();
            cachedProducts = Collections.unmodifiableList(products);
            cachedAt = System.currentTimeMillis();
            return cachedProducts;
        }
    }

    /**
     * 상품 1건 조회 (by id)
     * 캐시에 있으면 캐시에서 찾고, 없으면 DB 에서 직접 조회한다.
     */
    public ProductDto getProduct(String id) {
        if (id == null || id.isBlank()) {
            return null;
        }

        for (ProductDto product : getProducts()) {
            if (id.equals(product.getId())) {
                return product;
            }
        }

        // 캐시에 없는 경우(만료/신규 등) DB 직접 조회
        return productRepository.selectById(id);
    }

    /**
     * 캐시 만료 여부
     */
    private boolean isExpired() {
        return System.currentTimeMillis() - cachedAt > TTL_MILLIS;
    }

    /**
     * 캐시 무효화 - 상품 추가/수정/삭제 후 호출하면 다음 조회 시 DB에서 다시 읽는다.
     */
    public static void evict() {
        cachedProducts = null;
        cachedAt = 0L;
    }

}
