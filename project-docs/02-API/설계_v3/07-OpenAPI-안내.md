# 7단계. OpenAPI 3.0 YAML

작성자: 7반 이민형 | 버전: 0.3.1 | 기준: 현재 프로젝트 기술서 초안_v2.md

[전체 YAML](7반_이민형_괴식도감-API.yml)

OpenAPI 3.0.3, API 30개다. 통합 등록 API의 201 응답은 menu_created로 새 메뉴 생성과 기존 메뉴 연결을 구분한다. x-requirements, x-screens, x-db-tables로 추적한다. 현재 v2의 작성 범위에 따라 Security Schemes는 정의하지 않으며 접근 조건은 x-access와 설명에 명시한다. 인증과 CSRF 검증은 구현 시 필요하다.

검증 범위와 결과는 [8단계](../../01-기획-요구사항/설계_v3/08-추적성-검증.md)를 따른다.
