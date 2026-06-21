/**
    20252364 강한서

    상품 리뷰 정보를 저장하기 위한 DTO 클래스이다.
    review 테이블의 리뷰 번호, 상품 번호, 작성자 아이디, 별점, 리뷰 내용,
    작성일 정보를 Java 객체로 저장하는 역할을 한다.

    리뷰 한 개의 정보를 객체로 관리한다.
    review 테이블의 컬럼 값을 Java 필드로 저장한다.
    상품 상세 페이지에서 리뷰 목록을 출력할 때 사용된다.
 */
package kr.ac.dy.cs.review;

import java.sql.Timestamp;

public class ReviewDto {
    private int id;
    private int productId;
    private String writerId;
    private int rating;
    private String content;
    private Timestamp createdAt;

    public ReviewDto() {
    }

    public ReviewDto(int id, int productId, String writerId, int rating, String content, Timestamp createdAt) {
        this.id = id;
        this.productId = productId;
        this.writerId = writerId;
        this.rating = rating;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    } 

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    } 

    public String getWriterId() {
        return writerId;
    }

    public void setWriterId(String writerId) {
        this.writerId = writerId;
    } 

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    } 

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    } 

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
