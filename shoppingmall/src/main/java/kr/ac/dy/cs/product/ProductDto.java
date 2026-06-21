/**
20252364 강한서

상품 정보를 저장하기 위한 DTO 클래스이다.
 product 테이블의 상품 번호, 상품명, 브랜드명, 가격, 상품 설명, 이미지 경로를
Java 객체로 저장하고 JSP 화면과 DAO 사이에서 전달하는 역할을 한다.

상품 한 개의 정보를 객체로 관리한다.
product 테이블의 컬럼 값을 Java 필드로 저장한다.
 상품 목록 페이지와 상품 상세 페이지에서 상품 정보를 출력할 때 사용된다.
 */
package kr.ac.dy.cs.product;

public class ProductDto {
    private int id;
    private String name;
    private String brand;
    private int price;
    private String description;
    private String imageUrl;

    public ProductDto() {
    }

    public ProductDto(int id, String name, String brand, int price, String description, String imageUrl) {
        this.id = id;
        this.name = name;
        this.brand = brand;
        this.price = price;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    } 

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    } 

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    } 

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    } 

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    } 

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
}
