# 6단계. REST API 명세서

작성자: 7반 이민형 | 버전: 0.3.1 | 기준: 현재 프로젝트 기술서 초안_v2.md

## 공통 계약

/api 접두사, JSON UTF-8과 ISO 8601 시각을 사용한다. 인증 수단은 세션과 CSRF를 구현 제안으로 유지한다. 현재 v2의 작성 범위에 맞춰 Security Schemes 정의는 제외하며 인증이 불필요하다는 의미는 아니다. x-access에 접근 조건을 기록한다. 변경 요청은 X-CSRF-TOKEN을 검증한다. 가입과 로그인 전에 토큰을 받고 로그인 후 재발급한다.

## v2 경로 대응

| v2 경로 | v3 경로 | 비고 |
| --- | --- | --- |
| POST /auth/signup | POST /api/users | 동일 회원가입 기능, 리소스형 경로 제안 |
| POST /auth/login | POST /api/auth/sessions | 동일 로그인 기능 |
| POST /auth/google | POST /api/auth/google-sessions | 동일 구글 로그인 |
| POST /auth/logout | DELETE /api/auth/session | 동일 로그아웃 기능 |
| 나머지 경로 | /api 접두사 추가 | 별도 동일 메뉴 판정 API 없음 |

## 전체 API 목록

| Method | Path | 설명 | 인증 | REQ-ID | SCR-ID | DB 테이블 |
| --- | --- | --- | --- | --- | --- | --- |
| POST | /api/users | 이메일 회원가입 | public | REQ-FUNC-001 | SCR-AUTH-001 | users |
| POST | /api/auth/sessions | 이메일 로그인 | public | REQ-FUNC-001 | SCR-AUTH-001 | users |
| POST | /api/auth/google-sessions | 구글 로그인 | public | REQ-FUNC-002 | SCR-AUTH-001 | users, external_accounts |
| POST | /api/me/external-accounts/google | 구글 계정 연결 | user | REQ-FUNC-002 | SCR-ME-001 | users, external_accounts |
| GET | /api/me | 현재 로그인 사용자 조회 | user | REQ-FUNC-001, REQ-FUNC-002, REQ-FUNC-003 | SCR-AUTH-001, SCR-ME-001 | users, external_accounts, user_preferences |
| DELETE | /api/auth/session | 로그아웃 | user | REQ-FUNC-001 | SCR-ME-001 | users |
| GET | /api/menus | 메뉴 목록 조회 | user | REQ-FUNC-007 | SCR-CATALOG-001 | drink_menus, brands, menu_options, reviews, bookmarks |
| POST | /api/menus | 조합과 후기 통합 등록 | user | REQ-FUNC-011, REQ-FUNC-012, REQ-FUNC-013 | SCR-SHARE-001 | brands, drink_menus, menu_options, users, reviews, review_images |
| GET | /api/menus/{menu_id} | 메뉴 상세 조회 | user | REQ-FUNC-004, REQ-FUNC-006, REQ-FUNC-007 | SCR-SURVEY-001, SCR-HOME-001, SCR-CATALOG-001, SCR-CHAT-001 | user_preferences, drink_menus, menu_options, reviews, brands, bookmarks |
| GET | /api/menus/{menu_id}/reviews | 메뉴별 후기 조회 | user | REQ-FUNC-008 | SCR-CATALOG-001 | reviews, review_images, users, drink_menus |
| POST | /api/menus/{menu_id}/reviews | 기존 메뉴에 후기 등록 | user | REQ-FUNC-011, REQ-FUNC-012, REQ-FUNC-013 | SCR-SHARE-001 | brands, drink_menus, menu_options, users, reviews, review_images |
| PUT | /api/me/bookmarks/{menu_id} | 메뉴 북마크 추가 | user | REQ-FUNC-009 | SCR-CATALOG-001 | bookmarks, drink_menus, brands, reviews, users |
| DELETE | /api/me/bookmarks/{menu_id} | 메뉴 북마크 해제 | user | REQ-FUNC-009 | SCR-CATALOG-001, SCR-ME-001 | bookmarks, drink_menus, brands, reviews, users |
| GET | /api/me/bookmarks | 내 북마크 목록 조회 | user | REQ-FUNC-009 | SCR-ME-001 | bookmarks, drink_menus, brands, reviews, users |
| GET | /api/me/preferences | 내 선호 조회 | user | REQ-FUNC-001, REQ-FUNC-003 | SCR-SURVEY-001, SCR-ME-001 | users, user_preferences |
| PUT | /api/me/preferences | 내 선호 저장 및 갱신 | user | REQ-FUNC-003 | SCR-SURVEY-001 | users, user_preferences |
| GET | /api/me/recommendations/survey | 설문 결과 추천 조회 | user | REQ-FUNC-004 | SCR-SURVEY-001 | user_preferences, drink_menus, menu_options, reviews, brands, bookmarks |
| GET | /api/me/recommendations/daily | 데일리 추천 조회 | user | REQ-FUNC-005 | SCR-HOME-001 | user_preferences, drink_menus, menu_options, reviews, brands, bookmarks |
| POST | /api/recommendations/chat | 챗봇 추천 요청 | user | REQ-FUNC-006 | SCR-CHAT-001 | user_preferences, drink_menus, menu_options, reviews, brands, bookmarks |
| GET | /api/brands | 브랜드 목록 조회 | user | REQ-FUNC-012, REQ-FUNC-018 | SCR-SHARE-001, SCR-ADMIN-001 | brands, users, drink_menus, menu_options, reviews, review_images |
| POST | /api/receipt-verifications | 영수증 확인 | user | REQ-FUNC-010 | SCR-SHARE-001 | brands, users |
| GET | /api/me/reviews | 내 후기 목록 조회 | user | REQ-FUNC-014 | SCR-ME-001 | users, reviews, review_images, drink_menus, brands, bookmarks |
| DELETE | /api/me/reviews/{review_id} | 본인 후기 삭제 | owner | REQ-FUNC-015 | SCR-ME-001 | users, reviews, review_images, drink_menus |
| GET | /api/admin/menus | 관리자용 메뉴 목록 조회 | admin | REQ-FUNC-016 | SCR-ADMIN-001 | users, drink_menus, menu_options, brands, reviews, bookmarks |
| GET | /api/admin/menus/{menu_id} | 관리자용 메뉴 상세 조회 | admin | REQ-FUNC-016 | SCR-ADMIN-001 | users, drink_menus, menu_options, brands, reviews, bookmarks |
| PATCH | /api/admin/menus/{menu_id} | 괴식 등급 변경 | admin | REQ-FUNC-016 | SCR-ADMIN-001 | users, drink_menus, menu_options, brands, reviews, bookmarks |
| DELETE | /api/admin/menus/{menu_id} | 메뉴 삭제 | admin | REQ-FUNC-017 | SCR-ADMIN-001 | users, drink_menus, menu_options, reviews, bookmarks |
| POST | /api/admin/brands | 브랜드 추가 | admin | REQ-FUNC-018 | SCR-ADMIN-001 | users, brands, drink_menus |
| DELETE | /api/admin/brands/{brand_id} | 브랜드 삭제 | admin | REQ-FUNC-018 | SCR-ADMIN-001 | users, brands, drink_menus |
| GET | /api/auth/csrf | CSRF 토큰 조회 | public | REQ-FUNC-001, REQ-FUNC-002 | SCR-AUTH-001 |  |

## AI 입력과 처리

| 기능 | 입력 | 서버 처리와 Tool | AI 출력 | 결과와 행동 |
| --- | --- | --- | --- | --- |
| 동일 메뉴 판정 | 조합과 같은 브랜드 기존 메뉴 | 서버가 DB 메뉴와 추가 재료를 조회하고 비교 프롬프트 생성 | JSON 기존 메뉴 ID 또는 null | ID 검증 후 자동 연결 또는 신규 생성. 실패는 등록하지 않음 |
| 설문 추천 | 저장된 5개 응답 | 등록된 추가 재료의 제외 조건으로 DB 후보 선별 | 취향 요약, 후보 메뉴 ID와 이유 | 후보 ID 검증, 최대 1개 표시 후 상세 조회 |
| 홈 추천 | 저장된 취향 | 추가 재료 제외 조건으로 DB 후보 선별 | 후보 메뉴 ID와 이유 | 개수와 갱신 [확인 필요], 현재 최대 3개 제안 |
| 챗봇 | 메시지와 저장된 취향 | DB 후보 선별, 사용자 문장은 비신뢰 입력으로 분리 | 답변, 후보 메뉴 ID와 이유 | 카드 선택으로 상세 조회 |
| 영수증 확인 | 브랜드와 이미지 | 서버에서 판독 프롬프트 생성, 구매 사실과 브랜드 대조 | 판독 가능 여부, 카페 구매 여부, 브랜드 | 성공 시 임시 인증, 판독 불가 또는 불일치는 재제출 |

모든 프롬프트는 서버에서 구성한다. LLM에 임의 SQL이나 쓰기 권한을 주지 않는다. 정상 null과 호출 실패를 구분한다. 모델과 호출 한도는 [확인 필요], 전체 20초와 자동 재시도 없음은 구현 제안이다. 실패는 502/503/504로 구분하고 입력을 유지한다. 추천에는 다음 안내를 반환한다: 기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다.

## 공통 오류

```json
{"code":"BAD_REQUEST","message":"입력값을 확인해주세요.","details":{}}
```


## signup: POST /api/users

요구사항: REQ-FUNC-001
화면: SCR-AUTH-001
DB: users
이메일은 trim 후 소문자로 정규화한다. 공개 가입은 USER 역할만 생성한다. 비밀번호는 UTF-8 72바이트 이내의 BCrypt 입력으로 제한한다. 관리자 승격은 운영자가 별도 수행한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | public |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 201, 400, 409, 403, 500 |

Request Body (application/json):

```json
{
  "$ref": "#/components/schemas/SignupRequest"
}
```

### 응답 201

이메일 회원가입 성공

Schema: `{"$ref":"#/components/schemas/User"}`

example:

```json
{
  "user_id": 1,
  "email": "user@example.com",
  "display_name": "예시",
  "role": "USER",
  "survey_completed": false
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 409

기존 데이터와 충돌합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "CONFLICT",
  "message": "기존 데이터와 충돌합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## login: POST /api/auth/sessions

요구사항: REQ-FUNC-001
화면: SCR-AUTH-001
DB: users
사용자와 관리자는 같은 API를 사용하고 반환된 역할과 설문 완료 여부에 따라 화면을 분기한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | public |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 200, 400, 401, 403, 500 |

Request Body (application/json):

```json
{
  "$ref": "#/components/schemas/LoginRequest"
}
```

### 응답 200

이메일 로그인 성공

Schema: `{"$ref":"#/components/schemas/LoginResult"}`

example:

```json
{
  "user": {
    "user_id": 1,
    "email": "user@example.com",
    "display_name": "예시",
    "role": "USER",
    "survey_completed": false
  }
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## googleLogin: POST /api/auth/google-sessions

요구사항: REQ-FUNC-002
화면: SCR-AUTH-001
DB: users, external_accounts
검증된 sub로 사용자를 조회한다. 연결 계정이 없고 같은 이메일의 기존 계정도 없으면 이메일과 표시 이름으로 새 USER를 생성하고 외부 계정을 연결한다. 같은 이메일의 기존 계정이 있으면 409로 계정 연결을 안내한다. 신규 구글 가입은 구현 제안이다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | public |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 200, 400, 401, 409, 503, 403, 500, 504 |

Request Body (application/json):

```json
{
  "$ref": "#/components/schemas/GoogleCredential"
}
```

### 응답 200

구글 로그인 성공

Schema: `{"$ref":"#/components/schemas/LoginResult"}`

example:

```json
{
  "user": {
    "user_id": 1,
    "email": "user@example.com",
    "display_name": "예시",
    "role": "USER",
    "survey_completed": false
  }
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 409

기존 데이터와 충돌합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "CONFLICT",
  "message": "기존 데이터와 충돌합니다."
}
```

### 응답 503

외부 서비스를 일시적으로 사용할 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_UNAVAILABLE",
  "message": "외부 서비스를 일시적으로 사용할 수 없습니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

### 응답 504

AI 또는 외부 요청 시간이 초과되었습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_TIMEOUT",
  "message": "AI 또는 외부 요청 시간이 초과되었습니다."
}
```

## linkGoogle: POST /api/me/external-accounts/google

요구사항: REQ-FUNC-002
화면: SCR-ME-001
DB: users, external_accounts
현재 로그인 사용자에게 검증된 구글 계정을 연결한다. 이미 다른 사용자에게 연결된 계정은 거부한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 200, 400, 409, 503, 401, 403, 500, 504 |

Request Body (application/json):

```json
{
  "$ref": "#/components/schemas/GoogleCredential"
}
```

### 응답 200

구글 계정 연결 성공

Schema: `{"type":"object","properties":{"linked":{"type":"boolean"}},"required":["linked"]}`

example:

```json
{
  "linked": false
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 409

기존 데이터와 충돌합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "CONFLICT",
  "message": "기존 데이터와 충돌합니다."
}
```

### 응답 503

외부 서비스를 일시적으로 사용할 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_UNAVAILABLE",
  "message": "외부 서비스를 일시적으로 사용할 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

### 응답 504

AI 또는 외부 요청 시간이 초과되었습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_TIMEOUT",
  "message": "AI 또는 외부 요청 시간이 초과되었습니다."
}
```

## getMe: GET /api/me

요구사항: REQ-FUNC-001, REQ-FUNC-002, REQ-FUNC-003
화면: SCR-AUTH-001, SCR-ME-001
DB: users, external_accounts, user_preferences
현재 로그인 사용자 조회

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 401, 500 |

Request Body: 없음.

### 응답 200

현재 로그인 사용자 조회 성공

Schema: `{"$ref":"#/components/schemas/User"}`

example:

```json
{
  "user_id": 1,
  "email": "user@example.com",
  "display_name": "예시",
  "role": "USER",
  "survey_completed": false
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## logout: DELETE /api/auth/session

요구사항: REQ-FUNC-001
화면: SCR-ME-001
DB: users
서버의 로그인 상태를 종료한다. 인증 수단별 무효화 방식은 확인 필요.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 204, 401, 403, 500 |

Request Body: 없음.

### 응답 204

처리 완료, 응답 본문 없음

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## listMenus: GET /api/menus

요구사항: REQ-FUNC-007
화면: SCR-CATALOG-001
DB: drink_menus, brands, menu_options, reviews, bookmarks
카테고리와 페이지로 메뉴를 조회한다. 최신순은 created_at DESC, menu_id DESC. 인기순 기준은 [확인 필요], 현재 제안은 후기 수 DESC, 사용자별 평균의 평균 DESC, menu_id DESC다. 대표 이미지 주소가 null이면 화면에서 기본 이미지를 표시한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | category: {"type":"string","enum":["커피","스무디","티"]}<br>sort: {"type":"string","enum":["latest","popular"],"default":"latest"}<br>page: {"type":"integer","minimum":1,"default":1}<br>size: {"type":"integer","minimum":1,"maximum":100,"default":20} |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 400, 401, 500 |

Request Body: 없음.

### 응답 200

메뉴 목록 조회 성공

Schema: `{"$ref":"#/components/schemas/MenuPage"}`

example:

```json
{
  "items": [
    {
      "menu_id": 1,
      "brand": {
        "brand_id": 1,
        "name": "예시"
      },
      "name": "예시",
      "category": "커피",
      "weirdness_level": "초심자",
      "representative_image_url": "https://example.com/images/drink.webp",
      "average_rating": 1,
      "review_count": 1,
      "is_bookmarked": false,
      "created_at": "2026-09-15T09:00:00+09:00"
    }
  ],
  "page_info": {
    "page": 1,
    "size": 1,
    "total_elements": 1,
    "total_pages": 1
  }
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## createMenu: POST /api/menus

요구사항: REQ-FUNC-011, REQ-FUNC-012, REQ-FUNC-013
화면: SCR-SHARE-001
DB: brands, drink_menus, menu_options, users, reviews, review_images
브랜드와 입력을 검증하고 같은 브랜드의 기존 메뉴와 추가 재료를 조회한다. 서버가 비교 프롬프트를 생성해 LLM에서 기존 메뉴 ID 또는 null을 받는다. ID는 실제 비교 대상에 포함되는지 검사한다. 유효한 ID이면 그 메뉴에 후기만 생성하고 기존 레시피와 대표 이미지는 유지한다. 정상 null이면 새 메뉴, 옵션과 첫 후기를 생성하고 첫 이미지를 대표 이미지로 지정한다. 둘 다 201과 menu_created를 반환한다. 별도 확인 API나 후보 선택 UI를 두지 않는다. LLM 실패, 파싱 오류, 비교 대상 밖 ID는 등록 실패다. 실패를 신규 판정으로 대체하지 않는다. LLM 호출 완료 후 DB 트랜잭션에서 대상 존재와 브랜드를 다시 확인한다. 동시 신규 조합 중복 방지는 후속 개선 과제이며 현재 설계가 이를 보장하지 않는다.
AI 모델과 호출 제한은 [확인 필요]. 현재 제안은 전체 20초, 자동 재시도 없음이다. 외부 장애 503, 시간 초과 504, 출력 구조 또는 후보 ID 오류 502. 사용자 입력을 유지하고 수동 재시도를 제공한다.
이미지 최대 5장, 개인 평점 1~5와 필수 입력은 API에서 검사한다. 파일 형식 JPG/PNG/WebP, 각 5MB, 요청 30MB는 [확인 필요]인 구현 제안이다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 201, 400, 404, 413, 415, 422, 401, 403, 500, 502, 503, 504 |

Request Body (multipart/form-data):

```json
{
  "type": "object",
  "properties": {
    "payload": {
      "$ref": "#/components/schemas/NewMenuPayload"
    },
    "images": {
      "type": "array",
      "items": {
        "type": "string",
        "format": "binary"
      },
      "maxItems": 5,
      "description": "업로드 순서대로 저장. 파일 형식과 용량 제한은 확인 필요.",
      "minItems": 1
    }
  },
  "required": [
    "payload",
    "images"
  ]
}
```

multipart의 payload는 application/json 파트다. images는 파일 배열이며, 영수증 요청은 brand_id와 receipt 파일을 사용한다.

### 응답 201

후기 생성 완료. 새 메뉴 생성 또는 기존 메뉴 연결 결과를 menu_created로 구분한다.

Schema: `{"$ref":"#/components/schemas/MenuCreated"}`

created_menu:

```json
{
  "menu_id": 101,
  "review_id": 201,
  "menu_created": true,
  "representative_image_url": "https://example.com/images/new.webp"
}
```

matched_menu:

```json
{
  "menu_id": 42,
  "review_id": 202,
  "menu_created": false,
  "representative_image_url": null
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 413

파일 또는 요청 용량 제한을 초과했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "PAYLOAD_TOO_LARGE",
  "message": "파일 또는 요청 용량 제한을 초과했습니다."
}
```

### 응답 415

지원하지 않는 이미지 형식입니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNSUPPORTED_MEDIA_TYPE",
  "message": "지원하지 않는 이미지 형식입니다."
}
```

### 응답 422

영수증 확인 실패, 만료 또는 이미 사용한 인증입니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INVALID_VERIFICATION",
  "message": "영수증 확인 실패, 만료 또는 이미 사용한 인증입니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

### 응답 502

AI 결과 형식 또는 추천 조건이 올바르지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INVALID_AI_RESPONSE",
  "message": "AI 결과 형식 또는 추천 조건이 올바르지 않습니다."
}
```

### 응답 503

외부 서비스를 일시적으로 사용할 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_UNAVAILABLE",
  "message": "외부 서비스를 일시적으로 사용할 수 없습니다."
}
```

### 응답 504

AI 또는 외부 요청 시간이 초과되었습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_TIMEOUT",
  "message": "AI 또는 외부 요청 시간이 초과되었습니다."
}
```

## getMenu: GET /api/menus/{menu_id}

요구사항: REQ-FUNC-004, REQ-FUNC-006, REQ-FUNC-007
화면: SCR-SURVEY-001, SCR-HOME-001, SCR-CATALOG-001, SCR-CHAT-001
DB: user_preferences, drink_menus, menu_options, reviews, brands, bookmarks
선택한 메뉴와 추가 재료, 평점, 저장 여부를 조회한다. 평점은 사용자별 현재 후기 평균의 평균이다. 후기가 없으면 null로 제안한다. 대표 이미지 URL이 null이면 기본 이미지를 표시한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | menu_id 필수 |
| Header |  |
| HTTP Status Code | 200, 404, 401, 500 |

Request Body: 없음.

### 응답 200

메뉴 상세 조회 성공

Schema: `{"$ref":"#/components/schemas/MenuDetail"}`

example:

```json
{
  "menu_id": 1,
  "brand": {
    "brand_id": 1,
    "name": "예시"
  },
  "name": "예시",
  "category": "커피",
  "weirdness_level": "초심자",
  "representative_image_url": "https://example.com/images/drink.webp",
  "average_rating": 1,
  "review_count": 1,
  "is_bookmarked": false,
  "created_at": "2026-09-15T09:00:00+09:00",
  "base_drink": "예시",
  "size": "예시",
  "temperature": "예시",
  "recipe_description": "예시",
  "options": [
    {
      "action": "추가",
      "ingredient_name": "예시",
      "quantity": 1,
      "unit": "예시",
      "option_id": 1
    }
  ]
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## listMenuReviews: GET /api/menus/{menu_id}/reviews

요구사항: REQ-FUNC-008
화면: SCR-CATALOG-001
DB: reviews, review_images, users, drink_menus
해당 메뉴에 현재 남아 있는 후기만 created_at DESC, review_id DESC로 조회한다. 사용자 이메일과 비밀번호는 반환하지 않는다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | page: {"type":"integer","minimum":1,"default":1}<br>size: {"type":"integer","minimum":1,"maximum":100,"default":20} |
| Path Parameter | menu_id 필수 |
| Header |  |
| HTTP Status Code | 200, 400, 404, 401, 500 |

Request Body: 없음.

### 응답 200

메뉴별 후기 조회 성공

Schema: `{"$ref":"#/components/schemas/ReviewPage"}`

example:

```json
{
  "items": [
    {
      "review_id": 1,
      "menu_id": 1,
      "author": {
        "user_id": 1,
        "display_name": "예시"
      },
      "rating": 1,
      "content": "예시",
      "images": [
        {
          "image_id": 1,
          "image_url": "https://example.com/images/drink.webp",
          "display_order": 1
        }
      ],
      "created_at": "2026-09-15T09:00:00+09:00"
    }
  ],
  "page_info": {
    "page": 1,
    "size": 1,
    "total_elements": 1,
    "total_pages": 1
  }
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## createReview: POST /api/menus/{menu_id}/reviews

요구사항: REQ-FUNC-011, REQ-FUNC-012, REQ-FUNC-013
화면: SCR-SHARE-001
DB: brands, drink_menus, menu_options, users, reviews, review_images
지정한 메뉴와 현재 사용자, 영수증 인증의 브랜드와 유효 상태를 검사한다. 후기와 이미지 메타데이터를 한 트랜잭션으로 저장하고 인증을 성공 시 소비한다. 반복 후기는 허용하며 순번을 저장하지 않는다. 메뉴 평점은 사용자별 현재 후기 평균을 다시 평균낸다.
이미지 최대 5장, 개인 평점 1~5와 필수 입력은 API에서 검사한다. 파일 형식 JPG/PNG/WebP, 각 5MB, 요청 30MB는 [확인 필요]인 구현 제안이다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | menu_id 필수 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 201, 400, 404, 413, 415, 422, 401, 403, 500 |

Request Body (multipart/form-data):

```json
{
  "type": "object",
  "properties": {
    "payload": {
      "$ref": "#/components/schemas/ReviewPayload"
    },
    "images": {
      "type": "array",
      "items": {
        "type": "string",
        "format": "binary"
      },
      "maxItems": 5,
      "description": "업로드 순서대로 저장. 파일 형식과 용량 제한은 확인 필요."
    }
  },
  "required": [
    "payload"
  ]
}
```

multipart의 payload는 application/json 파트다. images는 파일 배열이며, 영수증 요청은 brand_id와 receipt 파일을 사용한다.

### 응답 201

기존 메뉴에 후기 등록 성공

Schema: `{"$ref":"#/components/schemas/Review"}`

example:

```json
{
  "review_id": 1,
  "menu_id": 1,
  "author": {
    "user_id": 1,
    "display_name": "예시"
  },
  "rating": 1,
  "content": "예시",
  "images": [
    {
      "image_id": 1,
      "image_url": "https://example.com/images/drink.webp",
      "display_order": 1
    }
  ],
  "created_at": "2026-09-15T09:00:00+09:00"
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 413

파일 또는 요청 용량 제한을 초과했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "PAYLOAD_TOO_LARGE",
  "message": "파일 또는 요청 용량 제한을 초과했습니다."
}
```

### 응답 415

지원하지 않는 이미지 형식입니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNSUPPORTED_MEDIA_TYPE",
  "message": "지원하지 않는 이미지 형식입니다."
}
```

### 응답 422

영수증 확인 실패, 만료 또는 이미 사용한 인증입니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INVALID_VERIFICATION",
  "message": "영수증 확인 실패, 만료 또는 이미 사용한 인증입니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## addBookmark: PUT /api/me/bookmarks/{menu_id}

요구사항: REQ-FUNC-009
화면: SCR-CATALOG-001
DB: bookmarks, drink_menus, brands, reviews, users
현재 사용자의 북마크를 생성한다. 반복 요청에도 한 건만 유지한다. is_bookmarked는 true다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | menu_id 필수 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 200, 404, 401, 403, 500 |

Request Body: 없음.

### 응답 200

메뉴 북마크 추가 성공

Schema: `{"$ref":"#/components/schemas/BookmarkState"}`

example:

```json
{
  "menu_id": 1,
  "is_bookmarked": true
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## removeBookmark: DELETE /api/me/bookmarks/{menu_id}

요구사항: REQ-FUNC-009
화면: SCR-CATALOG-001, SCR-ME-001
DB: bookmarks, drink_menus, brands, reviews, users
북마크가 이미 없어도 204를 반환하는 초안.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | menu_id 필수 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 204, 401, 403, 500 |

Request Body: 없음.

### 응답 204

처리 완료, 응답 본문 없음

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## listMyBookmarks: GET /api/me/bookmarks

요구사항: REQ-FUNC-009
화면: SCR-ME-001
DB: bookmarks, drink_menus, brands, reviews, users
saved_at 최신순으로 조회한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | page: {"type":"integer","minimum":1,"default":1}<br>size: {"type":"integer","minimum":1,"maximum":100,"default":20} |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 400, 401, 500 |

Request Body: 없음.

### 응답 200

내 북마크 목록 조회 성공

Schema: `{"$ref":"#/components/schemas/BookmarkPage"}`

example:

```json
{
  "items": [
    {
      "menu": {
        "menu_id": 1,
        "brand": {
          "brand_id": 1,
          "name": "예시"
        },
        "name": "예시",
        "category": "커피",
        "weirdness_level": "초심자",
        "representative_image_url": "https://example.com/images/drink.webp",
        "average_rating": 1,
        "review_count": 1,
        "is_bookmarked": false,
        "created_at": "2026-09-15T09:00:00+09:00"
      },
      "saved_at": "2026-09-15T09:00:00+09:00"
    }
  ],
  "page_info": {
    "page": 1,
    "size": 1,
    "total_elements": 1,
    "total_pages": 1
  }
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## getPreferences: GET /api/me/preferences

요구사항: REQ-FUNC-001, REQ-FUNC-003
화면: SCR-SURVEY-001, SCR-ME-001
DB: users, user_preferences
설문 미완료로 선호 정보가 없으면 404를 반환한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 404, 401, 500 |

Request Body: 없음.

### 응답 200

내 선호 조회 성공

Schema: `{"$ref":"#/components/schemas/Preference"}`

example:

```json
{
  "preferred_categories": [
    "커피"
  ],
  "preferred_tastes": [
    "예시"
  ],
  "sweetness_preference": "예시",
  "excluded_ingredients": [
    "예시"
  ],
  "challenge_level": "초심자",
  "updated_at": "2026-09-15T09:00:00+09:00"
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## savePreferences: PUT /api/me/preferences

요구사항: REQ-FUNC-003
화면: SCR-SURVEY-001
DB: users, user_preferences
현재 사용자만 대상으로 생성 또는 갱신한다. 과거 이력은 저장하지 않는다. 저장 후 별도로 추천을 요청하며 추천 실패에도 응답은 유지된다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 200, 400, 401, 403, 500 |

Request Body (application/json):

```json
{
  "$ref": "#/components/schemas/PreferenceInput"
}
```

### 응답 200

내 선호 저장 및 갱신 성공

Schema: `{"$ref":"#/components/schemas/Preference"}`

example:

```json
{
  "preferred_categories": [
    "커피"
  ],
  "preferred_tastes": [
    "예시"
  ],
  "sweetness_preference": "예시",
  "excluded_ingredients": [
    "예시"
  ],
  "challenge_level": "초심자",
  "updated_at": "2026-09-15T09:00:00+09:00"
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## getSurveyRecommendation: GET /api/me/recommendations/survey

요구사항: REQ-FUNC-004
화면: SCR-SURVEY-001
DB: user_preferences, drink_menus, menu_options, reviews, brands, bookmarks
저장된 취향과 등록된 추가 재료를 비교해 제외 조건을 적용한다. 남은 DB 후보를 LLM에 전달하고 ID와 추천 조건을 재검사해 최대 1개를 반환한다. 기본 음료의 전체 성분은 사용자가 주문 시 확인하도록 ingredient_notice를 반환한다.
AI 모델과 호출 제한은 [확인 필요]. 현재 제안은 전체 20초, 자동 재시도 없음이다. 외부 장애 503, 시간 초과 504, 출력 구조 또는 후보 ID 오류 502. 사용자 입력을 유지하고 수동 재시도를 제공한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 404, 503, 401, 500, 504, 502 |

Request Body: 없음.

### 응답 200

설문 결과 추천 조회 성공

Schema: `{"$ref":"#/components/schemas/SurveyRecommendation"}`

example:

```json
{
  "taste_summary": "예시",
  "items": [
    {
      "menu": {
        "menu_id": 1,
        "brand": {
          "brand_id": 1,
          "name": "예시"
        },
        "name": "예시",
        "category": "커피",
        "weirdness_level": "초심자",
        "representative_image_url": "https://example.com/images/drink.webp",
        "average_rating": 1,
        "review_count": 1,
        "is_bookmarked": false,
        "created_at": "2026-09-15T09:00:00+09:00"
      },
      "reason": "예시"
    }
  ],
  "ingredient_notice": "기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다."
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 503

외부 서비스를 일시적으로 사용할 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_UNAVAILABLE",
  "message": "외부 서비스를 일시적으로 사용할 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

### 응답 504

AI 또는 외부 요청 시간이 초과되었습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_TIMEOUT",
  "message": "AI 또는 외부 요청 시간이 초과되었습니다."
}
```

### 응답 502

AI 결과 형식 또는 추천 조건이 올바르지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INVALID_AI_RESPONSE",
  "message": "AI 결과 형식 또는 추천 조건이 올바르지 않습니다."
}
```

## getDailyRecommendations: GET /api/me/recommendations/daily

요구사항: REQ-FUNC-005
화면: SCR-HOME-001
DB: user_preferences, drink_menus, menu_options, reviews, brands, bookmarks
저장된 취향과 등록된 추가 재료의 제외 조건으로 홈 추천을 제공한다. 기본 음료 성분 확인 안내를 반환한다. 추천 수와 갱신 기준은 [확인 필요], 최대 3개는 현재 구현 제안이다.
AI 모델과 호출 제한은 [확인 필요]. 현재 제안은 전체 20초, 자동 재시도 없음이다. 외부 장애 503, 시간 초과 504, 출력 구조 또는 후보 ID 오류 502. 사용자 입력을 유지하고 수동 재시도를 제공한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 404, 503, 401, 500, 504, 502 |

Request Body: 없음.

### 응답 200

데일리 추천 조회 성공

Schema: `{"$ref":"#/components/schemas/RecommendationList"}`

example:

```json
{
  "items": [
    {
      "menu": {
        "menu_id": 1,
        "brand": {
          "brand_id": 1,
          "name": "예시"
        },
        "name": "예시",
        "category": "커피",
        "weirdness_level": "초심자",
        "representative_image_url": "https://example.com/images/drink.webp",
        "average_rating": 1,
        "review_count": 1,
        "is_bookmarked": false,
        "created_at": "2026-09-15T09:00:00+09:00"
      },
      "reason": "예시"
    }
  ],
  "generated_at": "2026-09-15T09:00:00+09:00",
  "ingredient_notice": "기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다."
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 503

외부 서비스를 일시적으로 사용할 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_UNAVAILABLE",
  "message": "외부 서비스를 일시적으로 사용할 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

### 응답 504

AI 또는 외부 요청 시간이 초과되었습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_TIMEOUT",
  "message": "AI 또는 외부 요청 시간이 초과되었습니다."
}
```

### 응답 502

AI 결과 형식 또는 추천 조건이 올바르지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INVALID_AI_RESPONSE",
  "message": "AI 결과 형식 또는 추천 조건이 올바르지 않습니다."
}
```

## chatRecommendation: POST /api/recommendations/chat

요구사항: REQ-FUNC-006
화면: SCR-CHAT-001
DB: user_preferences, drink_menus, menu_options, reviews, brands, bookmarks
현재 메시지와 저장된 취향을 사용해 추가 재료의 제외 조건을 적용한 DB 후보를 추천한다. 답변과 후보 ID를 검사하고 기본 음료 성분 확인 안내를 반환한다. 대화 유지 방식과 입력 제한은 [확인 필요], 현재 메시지만 사용하는 것은 구현 제안이다.
AI 모델과 호출 제한은 [확인 필요]. 현재 제안은 전체 20초, 자동 재시도 없음이다. 외부 장애 503, 시간 초과 504, 출력 구조 또는 후보 ID 오류 502. 사용자 입력을 유지하고 수동 재시도를 제공한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 200, 400, 404, 503, 401, 403, 500, 504, 502 |

Request Body (application/json):

```json
{
  "$ref": "#/components/schemas/ChatRequest"
}
```

### 응답 200

챗봇 추천 요청 성공

Schema: `{"$ref":"#/components/schemas/ChatResult"}`

example:

```json
{
  "answer": "예시",
  "items": [
    {
      "menu": {
        "menu_id": 1,
        "brand": {
          "brand_id": 1,
          "name": "예시"
        },
        "name": "예시",
        "category": "커피",
        "weirdness_level": "초심자",
        "representative_image_url": "https://example.com/images/drink.webp",
        "average_rating": 1,
        "review_count": 1,
        "is_bookmarked": false,
        "created_at": "2026-09-15T09:00:00+09:00"
      },
      "reason": "예시"
    }
  ],
  "ingredient_notice": "기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다."
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 503

외부 서비스를 일시적으로 사용할 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_UNAVAILABLE",
  "message": "외부 서비스를 일시적으로 사용할 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

### 응답 504

AI 또는 외부 요청 시간이 초과되었습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_TIMEOUT",
  "message": "AI 또는 외부 요청 시간이 초과되었습니다."
}
```

### 응답 502

AI 결과 형식 또는 추천 조건이 올바르지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INVALID_AI_RESPONSE",
  "message": "AI 결과 형식 또는 추천 조건이 올바르지 않습니다."
}
```

## listBrands: GET /api/brands

요구사항: REQ-FUNC-012, REQ-FUNC-018
화면: SCR-SHARE-001, SCR-ADMIN-001
DB: brands, users, drink_menus, menu_options, reviews, review_images
브랜드 목록 조회

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 401, 500 |

Request Body: 없음.

### 응답 200

브랜드 목록 조회 성공

Schema: `{"type":"array","items":{"$ref":"#/components/schemas/Brand"}}`

example:

```json
[
  {
    "brand_id": 1,
    "name": "예시"
  }
]
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## verifyReceipt: POST /api/receipt-verifications

요구사항: REQ-FUNC-010
화면: SCR-SHARE-001
DB: brands, users
브랜드와 카페 구매 사실을 확인한다. 단일 서버 메모리에서 사용자/브랜드/만료/사용 상태를 관리한다. 유효 시간 15분 제안. 재시작 시 소멸하고 재인증한다. 원본과 판독 결과는 저장 및 로깅 금지. 실제 진위와 세부 레시피 구매를 보장하지 않는다.
프롬프트는 서버에서 생성한다. 전체 20초 제한, 자동 재시도 없음. 외부 장애 503, 시간 초과 504, 출력 JSON 형식 오류 502. 사용자가 수동 재시도한다. AI 출력은 저장하지 않는다.
허용 이미지 JPG/PNG/WebP, 파일당 5MB, 전체 요청 30MB 제안. 확장자뿐 아니라 실제 디코딩과 MIME을 검증한다.
AI 모델과 호출 제한은 [확인 필요]. 현재 제안은 전체 20초, 자동 재시도 없음이다. 외부 장애 503, 시간 초과 504, 출력 구조 또는 후보 ID 오류 502. 사용자 입력을 유지하고 수동 재시도를 제공한다.
이미지 최대 5장, 개인 평점 1~5와 필수 입력은 API에서 검사한다. 파일 형식 JPG/PNG/WebP, 각 5MB, 요청 30MB는 [확인 필요]인 구현 제안이다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 200, 400, 404, 413, 415, 422, 503, 401, 403, 500, 504, 502 |

Request Body (multipart/form-data):

```json
{
  "type": "object",
  "properties": {
    "brand_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "receipt": {
      "type": "string",
      "format": "binary"
    }
  },
  "required": [
    "brand_id",
    "receipt"
  ]
}
```

multipart의 payload는 application/json 파트다. images는 파일 배열이며, 영수증 요청은 brand_id와 receipt 파일을 사용한다.

### 응답 200

영수증 확인 성공

Schema: `{"$ref":"#/components/schemas/VerificationResult"}`

example:

```json
{
  "verification_id": "예시",
  "brand_id": 1,
  "expires_at": "2026-09-15T09:00:00+09:00",
  "status": "VERIFIED"
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 413

파일 또는 요청 용량 제한을 초과했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "PAYLOAD_TOO_LARGE",
  "message": "파일 또는 요청 용량 제한을 초과했습니다."
}
```

### 응답 415

지원하지 않는 이미지 형식입니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNSUPPORTED_MEDIA_TYPE",
  "message": "지원하지 않는 이미지 형식입니다."
}
```

### 응답 422

영수증 확인 실패, 만료 또는 이미 사용한 인증입니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INVALID_VERIFICATION",
  "message": "영수증 확인 실패, 만료 또는 이미 사용한 인증입니다."
}
```

### 응답 503

외부 서비스를 일시적으로 사용할 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_UNAVAILABLE",
  "message": "외부 서비스를 일시적으로 사용할 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

### 응답 504

AI 또는 외부 요청 시간이 초과되었습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UPSTREAM_TIMEOUT",
  "message": "AI 또는 외부 요청 시간이 초과되었습니다."
}
```

### 응답 502

AI 결과 형식 또는 추천 조건이 올바르지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INVALID_AI_RESPONSE",
  "message": "AI 결과 형식 또는 추천 조건이 올바르지 않습니다."
}
```

## listMyReviews: GET /api/me/reviews

요구사항: REQ-FUNC-014
화면: SCR-ME-001
DB: users, reviews, review_images, drink_menus, brands, bookmarks
현재 사용자의 남아 있는 후기를 created_at DESC, review_id DESC로 조회한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | user |
| Query Parameter | page: {"type":"integer","minimum":1,"default":1}<br>size: {"type":"integer","minimum":1,"maximum":100,"default":20} |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 400, 401, 500 |

Request Body: 없음.

### 응답 200

내 후기 목록 조회 성공

Schema: `{"$ref":"#/components/schemas/MyReviewPage"}`

example:

```json
{
  "items": [
    {
      "review_id": 1,
      "menu_id": 1,
      "author": {
        "user_id": 1,
        "display_name": "예시"
      },
      "rating": 1,
      "content": "예시",
      "images": [
        {
          "image_id": 1,
          "image_url": "https://example.com/images/drink.webp",
          "display_order": 1
        }
      ],
      "created_at": "2026-09-15T09:00:00+09:00",
      "menu": {
        "menu_id": 1,
        "brand": {
          "brand_id": 1,
          "name": "예시"
        },
        "name": "예시",
        "category": "커피",
        "weirdness_level": "초심자",
        "representative_image_url": "https://example.com/images/drink.webp",
        "average_rating": 1,
        "review_count": 1,
        "is_bookmarked": false,
        "created_at": "2026-09-15T09:00:00+09:00"
      }
    }
  ],
  "page_info": {
    "page": 1,
    "size": 1,
    "total_elements": 1,
    "total_pages": 1
  }
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## deleteMyReview: DELETE /api/me/reviews/{review_id}

요구사항: REQ-FUNC-015
화면: SCR-ME-001
DB: users, reviews, review_images, drink_menus
본인 여부를 확인하고 후기의 이미지 주소를 수집한다. 해당 사진이 메뉴 대표 이미지이면 주소를 NULL로 비운다. 이미지 행과 후기 행을 한 트랜잭션에서 삭제하고 커밋 후 실제 파일을 정리한다. 메뉴와 다른 사람의 후기는 유지한다. 남은 후기만으로 사용자별 평균과 메뉴 평점을 다시 계산한다. 화면은 대표 이미지 URL이 null이면 기본 이미지를 표시한다. 다른 후기 사진으로 자동 교체하지 않는다. 없는 후기는 404, 타인의 후기는 403이다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | owner |
| Query Parameter | 없음 |
| Path Parameter | review_id 필수 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 204, 404, 401, 403, 500 |

Request Body: 없음.

### 응답 204

처리 완료, 응답 본문 없음

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## adminListMenus: GET /api/admin/menus

요구사항: REQ-FUNC-016
화면: SCR-ADMIN-001
DB: users, drink_menus, menu_options, brands, reviews, bookmarks
관리자용 메뉴 목록 조회

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | admin |
| Query Parameter | page: {"type":"integer","minimum":1,"default":1}<br>size: {"type":"integer","minimum":1,"maximum":100,"default":20} |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 400, 401, 403, 500 |

Request Body: 없음.

### 응답 200

관리자용 메뉴 목록 조회 성공

Schema: `{"$ref":"#/components/schemas/MenuPage"}`

example:

```json
{
  "items": [
    {
      "menu_id": 1,
      "brand": {
        "brand_id": 1,
        "name": "예시"
      },
      "name": "예시",
      "category": "커피",
      "weirdness_level": "초심자",
      "representative_image_url": "https://example.com/images/drink.webp",
      "average_rating": 1,
      "review_count": 1,
      "is_bookmarked": false,
      "created_at": "2026-09-15T09:00:00+09:00"
    }
  ],
  "page_info": {
    "page": 1,
    "size": 1,
    "total_elements": 1,
    "total_pages": 1
  }
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## adminGetMenu: GET /api/admin/menus/{menu_id}

요구사항: REQ-FUNC-016
화면: SCR-ADMIN-001
DB: users, drink_menus, menu_options, brands, reviews, bookmarks
관리자용 메뉴 상세 조회

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | admin |
| Query Parameter | 없음 |
| Path Parameter | menu_id 필수 |
| Header |  |
| HTTP Status Code | 200, 404, 401, 403, 500 |

Request Body: 없음.

### 응답 200

관리자용 메뉴 상세 조회 성공

Schema: `{"$ref":"#/components/schemas/MenuDetail"}`

example:

```json
{
  "menu_id": 1,
  "brand": {
    "brand_id": 1,
    "name": "예시"
  },
  "name": "예시",
  "category": "커피",
  "weirdness_level": "초심자",
  "representative_image_url": "https://example.com/images/drink.webp",
  "average_rating": 1,
  "review_count": 1,
  "is_bookmarked": false,
  "created_at": "2026-09-15T09:00:00+09:00",
  "base_drink": "예시",
  "size": "예시",
  "temperature": "예시",
  "recipe_description": "예시",
  "options": [
    {
      "action": "추가",
      "ingredient_name": "예시",
      "quantity": 1,
      "unit": "예시",
      "option_id": 1
    }
  ]
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## adminUpdateLevel: PATCH /api/admin/menus/{menu_id}

요구사항: REQ-FUNC-016
화면: SCR-ADMIN-001
DB: users, drink_menus, menu_options, brands, reviews, bookmarks
관리자만 괴식 등급을 변경한다. 추가 필드는 거부한다. 기본 음료의 전체 재료와 관리자 재료 검토 기능은 제공하지 않는다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | admin |
| Query Parameter | 없음 |
| Path Parameter | menu_id 필수 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 200, 400, 404, 401, 403, 500 |

Request Body (application/json):

```json
{
  "$ref": "#/components/schemas/LevelPatch"
}
```

### 응답 200

괴식 등급 변경 성공

Schema: `{"$ref":"#/components/schemas/MenuDetail"}`

example:

```json
{
  "menu_id": 1,
  "brand": {
    "brand_id": 1,
    "name": "예시"
  },
  "name": "예시",
  "category": "커피",
  "weirdness_level": "초심자",
  "representative_image_url": "https://example.com/images/drink.webp",
  "average_rating": 1,
  "review_count": 1,
  "is_bookmarked": false,
  "created_at": "2026-09-15T09:00:00+09:00",
  "base_drink": "예시",
  "size": "예시",
  "temperature": "예시",
  "recipe_description": "예시",
  "options": [
    {
      "action": "추가",
      "ingredient_name": "예시",
      "quantity": 1,
      "unit": "예시",
      "option_id": 1
    }
  ]
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## adminDeleteMenu: DELETE /api/admin/menus/{menu_id}

요구사항: REQ-FUNC-017
화면: SCR-ADMIN-001
DB: users, drink_menus, menu_options, reviews, bookmarks
관리자 연결 데이터 처리 정책은 [확인 필요]. 현재 구현 제안은 후기나 북마크가 있으면 409로 거부하고, 없으면 옵션부터 정리한 뒤 메뉴를 삭제한다. FK는 삭제 제한을 유지한다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | admin |
| Query Parameter | 없음 |
| Path Parameter | menu_id 필수 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 204, 404, 409, 401, 403, 500 |

Request Body: 없음.

### 응답 204

처리 완료, 응답 본문 없음

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 409

기존 데이터와 충돌합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "CONFLICT",
  "message": "기존 데이터와 충돌합니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## adminCreateBrand: POST /api/admin/brands

요구사항: REQ-FUNC-018
화면: SCR-ADMIN-001
DB: users, brands, drink_menus
브랜드 추가

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | admin |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 201, 400, 409, 401, 403, 500 |

Request Body (application/json):

```json
{
  "$ref": "#/components/schemas/BrandRequest"
}
```

### 응답 201

브랜드 추가 성공

Schema: `{"$ref":"#/components/schemas/Brand"}`

example:

```json
{
  "brand_id": 1,
  "name": "예시"
}
```

### 응답 400

입력값을 확인해주세요.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "BAD_REQUEST",
  "message": "입력값을 확인해주세요."
}
```

### 응답 409

기존 데이터와 충돌합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "CONFLICT",
  "message": "기존 데이터와 충돌합니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## adminDeleteBrand: DELETE /api/admin/brands/{brand_id}

요구사항: REQ-FUNC-018
화면: SCR-ADMIN-001
DB: users, brands, drink_menus
연결 메뉴가 있으면 FK 제한에 따라 409를 반환한다. 추가 삭제 정책은 확인 필요.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | admin |
| Query Parameter | 없음 |
| Path Parameter | brand_id 필수 |
| Header | X-CSRF-TOKEN 필수 |
| HTTP Status Code | 204, 404, 409, 401, 403, 500 |

Request Body: 없음.

### 응답 204

처리 완료, 응답 본문 없음

### 응답 404

대상 데이터를 찾을 수 없습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "NOT_FOUND",
  "message": "대상 데이터를 찾을 수 없습니다."
}
```

### 응답 409

기존 데이터와 충돌합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "CONFLICT",
  "message": "기존 데이터와 충돌합니다."
}
```

### 응답 401

로그인이 필요합니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "UNAUTHENTICATED",
  "message": "로그인이 필요합니다."
}
```

### 응답 403

요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "FORBIDDEN",
  "message": "요청 권한이 없거나 CSRF 토큰이 유효하지 않습니다."
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## getCsrf: GET /api/auth/csrf

요구사항: REQ-FUNC-001, REQ-FUNC-002
화면: SCR-AUTH-001
DB: 없음, 세션 상태
가입과 로그인 전에도 호출 가능. 세션에 연결된 CSRF 토큰을 반환한다. 로그인과 로그아웃 후 다시 발급받는다.

| 항목 | 정의 |
| --- | --- |
| 인증 여부 | public |
| Query Parameter | 없음 |
| Path Parameter | 없음 |
| Header |  |
| HTTP Status Code | 200, 500 |

Request Body: 없음.

### 응답 200

CSRF 토큰

Schema: `{"$ref":"#/components/schemas/CsrfToken"}`

example:

```json
{
  "header_name": "X-CSRF-TOKEN",
  "token": "예시"
}
```

### 응답 500

요청을 처리하지 못했습니다.

Schema: `{"$ref":"#/components/schemas/Error"}`

example:

```json
{
  "code": "INTERNAL_ERROR",
  "message": "요청을 처리하지 못했습니다."
}
```

## 공통 DTO와 Response Schema

### Error

```json
{
  "type": "object",
  "properties": {
    "code": {
      "type": "string",
      "description": "기계 판독용 오류 코드",
      "example": "BAD_REQUEST"
    },
    "message": {
      "type": "string",
      "description": "사용자 안내",
      "example": "입력값을 확인해주세요."
    },
    "details": {
      "type": "object",
      "additionalProperties": true
    }
  },
  "required": [
    "code",
    "message"
  ]
}
```

### User

```json
{
  "type": "object",
  "properties": {
    "user_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "display_name": {
      "type": "string",
      "maxLength": 50
    },
    "role": {
      "type": "string",
      "enum": [
        "USER",
        "ADMIN"
      ]
    },
    "survey_completed": {
      "type": "boolean"
    }
  },
  "required": [
    "user_id",
    "email",
    "display_name",
    "role",
    "survey_completed"
  ]
}
```

### Author

```json
{
  "type": "object",
  "properties": {
    "user_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "display_name": {
      "type": "string"
    }
  },
  "required": [
    "user_id",
    "display_name"
  ]
}
```

### SignupRequest

```json
{
  "type": "object",
  "properties": {
    "email": {
      "type": "string",
      "format": "email",
      "maxLength": 255
    },
    "password": {
      "type": "string",
      "description": "8자 이상, UTF-8 기준 최대 72바이트 제안. 바이트 제한은 서버가 추가 검사.",
      "format": "password",
      "writeOnly": true,
      "minLength": 8,
      "maxLength": 72
    },
    "display_name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 50
    }
  },
  "required": [
    "email",
    "password",
    "display_name"
  ],
  "additionalProperties": false
}
```

### LoginRequest

```json
{
  "type": "object",
  "properties": {
    "email": {
      "type": "string",
      "format": "email"
    },
    "password": {
      "type": "string",
      "format": "password",
      "writeOnly": true
    }
  },
  "required": [
    "email",
    "password"
  ],
  "additionalProperties": false
}
```

### GoogleCredential

```json
{
  "type": "object",
  "properties": {
    "id_token": {
      "type": "string",
      "description": "Google ID 토큰. 서버가 서명, iss, aud, exp, sub 및 이메일 확인 상태를 검증한다. 제공 클라이언트 ID는 환경 설정이다.",
      "writeOnly": true
    }
  },
  "required": [
    "id_token"
  ],
  "additionalProperties": false
}
```

### LoginResult

```json
{
  "type": "object",
  "properties": {
    "user": {
      "$ref": "#/components/schemas/User"
    }
  },
  "required": [
    "user"
  ],
  "description": "서버 세션을 만들고 Set-Cookie로 세션 쿠키를 전달한다. 응답의 사용자 역할과 설문 완료 여부로 화면 분기."
}
```

### Brand

```json
{
  "type": "object",
  "properties": {
    "brand_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "name": {
      "type": "string",
      "maxLength": 100
    }
  },
  "required": [
    "brand_id",
    "name"
  ]
}
```

### BrandRequest

```json
{
  "type": "object",
  "properties": {
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 100
    }
  },
  "required": [
    "name"
  ]
}
```

### PreferenceInput

```json
{
  "type": "object",
  "properties": {
    "preferred_categories": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": [
          "커피",
          "스무디",
          "티"
        ]
      },
      "minItems": 1,
      "uniqueItems": true
    },
    "preferred_tastes": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "minItems": 1,
      "uniqueItems": true
    },
    "sweetness_preference": {
      "type": "string",
      "minLength": 1,
      "maxLength": 50
    },
    "excluded_ingredients": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "uniqueItems": true,
      "description": "먹지 못하는 재료. 해당 없음은 빈 배열."
    },
    "challenge_level": {
      "type": "string",
      "enum": [
        "초심자",
        "중급자",
        "상급자"
      ]
    }
  },
  "required": [
    "preferred_categories",
    "preferred_tastes",
    "sweetness_preference",
    "excluded_ingredients",
    "challenge_level"
  ],
  "description": "현재 사용자 설문 응답 5개. PostgreSQL JSONB 배열로 저장하며 배열 항목은 문자열, 카테고리는 지정 enum을 검증한다. 세부 문구는 [확인 필요].",
  "additionalProperties": false
}
```

### Preference

```json
{
  "allOf": [
    {
      "$ref": "#/components/schemas/PreferenceInput"
    },
    {
      "type": "object",
      "properties": {
        "updated_at": {
          "type": "string",
          "format": "date-time"
        }
      },
      "required": [
        "updated_at"
      ]
    }
  ]
}
```

### MenuOptionInput

```json
{
  "type": "object",
  "properties": {
    "action": {
      "type": "string",
      "enum": [
        "추가"
      ]
    },
    "ingredient_name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 100
    },
    "quantity": {
      "type": "number",
      "nullable": true,
      "description": "정량 표현이 없으면 null 허용. 수량이 있으면 양수이고 unit은 필수. API에서 검사한다.",
      "maximum": 99999999.99,
      "minimum": 0,
      "exclusiveMinimum": true
    },
    "unit": {
      "type": "string",
      "description": "수량 사용 시 필수",
      "nullable": true,
      "maxLength": 30
    }
  },
  "required": [
    "action",
    "ingredient_name"
  ],
  "description": "추가 재료만 입력한다. 기본 음료 전체 재료와 제외 또는 변경 관계는 관리하지 않는다. quantity가 null이면 unit도 null로 제안하며 수량 사용 시 단위를 필수로 검사한다."
}
```

### MenuOption

```json
{
  "allOf": [
    {
      "$ref": "#/components/schemas/MenuOptionInput"
    },
    {
      "type": "object",
      "properties": {
        "option_id": {
          "type": "integer",
          "format": "int64",
          "minimum": 1
        }
      },
      "required": [
        "option_id"
      ]
    }
  ]
}
```

### MenuInput

```json
{
  "type": "object",
  "properties": {
    "brand_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "base_drink": {
      "type": "string",
      "minLength": 1,
      "maxLength": 100
    },
    "size": {
      "type": "string",
      "description": "표준값과 누락 처리 기준은 확인 필요",
      "nullable": true,
      "maxLength": 50
    },
    "temperature": {
      "type": "string",
      "description": "표준값과 누락 처리 기준은 확인 필요",
      "nullable": true,
      "maxLength": 30
    },
    "options": {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/MenuOptionInput"
      }
    },
    "name": {
      "type": "string",
      "minLength": 1,
      "maxLength": 100
    },
    "category": {
      "type": "string",
      "enum": [
        "커피",
        "스무디",
        "티"
      ]
    },
    "weirdness_level": {
      "type": "string",
      "enum": [
        "초심자",
        "중급자",
        "상급자"
      ]
    },
    "recipe_description": {
      "type": "string",
      "nullable": true
    }
  },
  "required": [
    "brand_id",
    "base_drink",
    "options",
    "name",
    "category",
    "weirdness_level"
  ],
  "description": "추가 재료와 수량만 관리한다. action은 추가만 허용한다. LLM 판정으로 기존 메뉴에 연결되면 입력한 메뉴명과 조합 정보로 기존 메뉴를 덮어쓰지 않는다.",
  "additionalProperties": false
}
```

### MenuCard

```json
{
  "type": "object",
  "properties": {
    "menu_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "brand": {
      "$ref": "#/components/schemas/Brand"
    },
    "name": {
      "type": "string"
    },
    "category": {
      "type": "string",
      "enum": [
        "커피",
        "스무디",
        "티"
      ]
    },
    "weirdness_level": {
      "type": "string",
      "enum": [
        "초심자",
        "중급자",
        "상급자"
      ]
    },
    "representative_image_url": {
      "type": "string",
      "format": "uri",
      "nullable": true
    },
    "average_rating": {
      "type": "number",
      "minimum": 1,
      "maximum": 5,
      "nullable": true,
      "description": "메뉴별 각 사용자의 현재 후기 평균을 구한 뒤 그 평균들을 다시 평균낸다. 후기 없는 사용자는 제외, 메뉴에 후기가 전혀 없으면 null. UI 표시 자릿수는 [확인 필요]."
    },
    "review_count": {
      "type": "integer",
      "minimum": 0
    },
    "is_bookmarked": {
      "type": "boolean"
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    }
  },
  "required": [
    "menu_id",
    "brand",
    "name",
    "category",
    "weirdness_level",
    "representative_image_url",
    "average_rating",
    "review_count",
    "is_bookmarked",
    "created_at"
  ]
}
```

### MenuDetail

```json
{
  "allOf": [
    {
      "$ref": "#/components/schemas/MenuCard"
    },
    {
      "type": "object",
      "properties": {
        "base_drink": {
          "type": "string"
        },
        "size": {
          "type": "string",
          "nullable": true
        },
        "temperature": {
          "type": "string",
          "nullable": true
        },
        "recipe_description": {
          "type": "string",
          "nullable": true
        },
        "options": {
          "type": "array",
          "items": {
            "$ref": "#/components/schemas/MenuOption"
          }
        }
      },
      "required": [
        "base_drink",
        "options"
      ]
    }
  ]
}
```

### ReviewImage

```json
{
  "type": "object",
  "properties": {
    "image_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "image_url": {
      "type": "string",
      "format": "uri"
    },
    "display_order": {
      "type": "integer",
      "minimum": 1,
      "maximum": 5
    }
  },
  "required": [
    "image_id",
    "image_url",
    "display_order"
  ]
}
```

### Review

```json
{
  "type": "object",
  "properties": {
    "review_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "menu_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "author": {
      "$ref": "#/components/schemas/Author"
    },
    "rating": {
      "type": "integer",
      "minimum": 1,
      "maximum": 5
    },
    "content": {
      "type": "string",
      "nullable": true
    },
    "images": {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/ReviewImage"
      },
      "maxItems": 5
    },
    "created_at": {
      "type": "string",
      "format": "date-time"
    }
  },
  "required": [
    "review_id",
    "menu_id",
    "author",
    "rating",
    "images",
    "created_at"
  ],
  "description": "현재 남아 있는 후기. 삭제한 후기와 파일은 제거하며 삭제된 후기는 응답과 평균 계산에 포함하지 않는다."
}
```

### ReviewInput

```json
{
  "type": "object",
  "properties": {
    "rating": {
      "type": "integer",
      "minimum": 1,
      "maximum": 5
    },
    "content": {
      "type": "string",
      "description": "선택 입력, 최대 2,000자 제안. 삭제 후 영구 본문은 제거한다.",
      "maxLength": 2000
    }
  },
  "required": [
    "rating"
  ]
}
```

### NewMenuPayload

```json
{
  "type": "object",
  "properties": {
    "menu": {
      "$ref": "#/components/schemas/MenuInput"
    },
    "first_review": {
      "$ref": "#/components/schemas/ReviewInput"
    },
    "verification_id": {
      "type": "string",
      "description": "현재 사용자와 선택 브랜드에 연결된 유효한 인증 식별자"
    }
  },
  "required": [
    "menu",
    "first_review",
    "verification_id"
  ],
  "description": "한 번 제출한 조합과 후기. first_review는 새 메뉴이면 첫 후기, 기존 메뉴로 판정되면 추가 후기다."
}
```

### ReviewPayload

```json
{
  "allOf": [
    {
      "$ref": "#/components/schemas/ReviewInput"
    },
    {
      "type": "object",
      "properties": {
        "verification_id": {
          "type": "string",
          "description": "현재 사용자와 대상 메뉴 브랜드의 인증 식별자"
        }
      },
      "required": [
        "verification_id"
      ]
    }
  ]
}
```

### MenuCreated

```json
{
  "type": "object",
  "properties": {
    "menu_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "review_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "representative_image_url": {
      "type": "string",
      "format": "uri",
      "nullable": true
    },
    "menu_created": {
      "type": "boolean",
      "description": "true는 새 메뉴와 후기 생성, false는 기존 메뉴에 후기 생성"
    }
  },
  "required": [
    "menu_id",
    "review_id",
    "representative_image_url",
    "menu_created"
  ],
  "description": "후기는 두 분기 모두 새로 생성한다. 기존 메뉴 연결이면 해당 메뉴의 레시피와 대표 이미지를 유지한다. 반환 menu_id로 상세를 조회한다."
}
```

### BookmarkState

```json
{
  "type": "object",
  "properties": {
    "menu_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "is_bookmarked": {
      "type": "boolean"
    }
  },
  "required": [
    "menu_id",
    "is_bookmarked"
  ]
}
```

### Bookmark

```json
{
  "type": "object",
  "properties": {
    "menu": {
      "$ref": "#/components/schemas/MenuCard"
    },
    "saved_at": {
      "type": "string",
      "format": "date-time"
    }
  },
  "required": [
    "menu",
    "saved_at"
  ]
}
```

### MyReview

```json
{
  "allOf": [
    {
      "$ref": "#/components/schemas/Review"
    },
    {
      "type": "object",
      "properties": {
        "menu": {
          "$ref": "#/components/schemas/MenuCard"
        }
      },
      "required": [
        "menu"
      ]
    }
  ]
}
```

### PageInfo

```json
{
  "type": "object",
  "properties": {
    "page": {
      "type": "integer",
      "minimum": 1
    },
    "size": {
      "type": "integer",
      "minimum": 1
    },
    "total_elements": {
      "type": "integer",
      "format": "int64",
      "minimum": 0
    },
    "total_pages": {
      "type": "integer",
      "minimum": 0
    }
  },
  "required": [
    "page",
    "size",
    "total_elements",
    "total_pages"
  ]
}
```

### MenuPage

```json
{
  "type": "object",
  "properties": {
    "items": {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/MenuCard"
      }
    },
    "page_info": {
      "$ref": "#/components/schemas/PageInfo"
    }
  },
  "required": [
    "items",
    "page_info"
  ]
}
```

### ReviewPage

```json
{
  "type": "object",
  "properties": {
    "items": {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/Review"
      }
    },
    "page_info": {
      "$ref": "#/components/schemas/PageInfo"
    }
  },
  "required": [
    "items",
    "page_info"
  ]
}
```

### BookmarkPage

```json
{
  "type": "object",
  "properties": {
    "items": {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/Bookmark"
      }
    },
    "page_info": {
      "$ref": "#/components/schemas/PageInfo"
    }
  },
  "required": [
    "items",
    "page_info"
  ]
}
```

### MyReviewPage

```json
{
  "type": "object",
  "properties": {
    "items": {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/MyReview"
      }
    },
    "page_info": {
      "$ref": "#/components/schemas/PageInfo"
    }
  },
  "required": [
    "items",
    "page_info"
  ]
}
```

### Recommendation

```json
{
  "type": "object",
  "properties": {
    "menu": {
      "$ref": "#/components/schemas/MenuCard"
    },
    "reason": {
      "type": "string",
      "description": "저장된 취향과 현재 요청을 바탕으로 한 추천 이유"
    }
  },
  "required": [
    "menu",
    "reason"
  ]
}
```

### RecommendationList

```json
{
  "type": "object",
  "properties": {
    "items": {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/Recommendation"
      },
      "maxItems": 3
    },
    "generated_at": {
      "type": "string",
      "format": "date-time"
    },
    "ingredient_notice": {
      "type": "string",
      "description": "기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다.",
      "example": "기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다."
    }
  },
  "required": [
    "items",
    "generated_at",
    "ingredient_notice"
  ],
  "description": "홈 추천 최대 3개. 후보 없음은 빈 배열. 결과 영구 저장 없음. 매 요청 결과 동일성은 보장하지 않는다."
}
```

### SurveyRecommendation

```json
{
  "type": "object",
  "properties": {
    "taste_summary": {
      "type": "string"
    },
    "items": {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/Recommendation"
      },
      "maxItems": 1
    },
    "ingredient_notice": {
      "type": "string",
      "description": "기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다.",
      "example": "기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다."
    }
  },
  "required": [
    "taste_summary",
    "items",
    "ingredient_notice"
  ],
  "description": "정상 추천 1개. 후보 없음은 빈 배열로 제안한다."
}
```

### ChatRequest

```json
{
  "type": "object",
  "properties": {
    "message": {
      "type": "string",
      "minLength": 1,
      "maxLength": 1000
    }
  },
  "required": [
    "message"
  ],
  "description": "현재 메시지와 저장된 취향만 사용한다. 이전 대화는 전달하거나 저장하지 않는다.",
  "additionalProperties": false
}
```

### ChatResult

```json
{
  "type": "object",
  "properties": {
    "answer": {
      "type": "string"
    },
    "items": {
      "type": "array",
      "items": {
        "$ref": "#/components/schemas/Recommendation"
      },
      "maxItems": 3
    },
    "ingredient_notice": {
      "type": "string",
      "description": "기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다.",
      "example": "기본 음료의 전체 성분은 주문 시 직접 확인하세요. 등록된 추가 재료 정보만 비교하며, 정보가 없다는 이유로 해당 성분이 없다고 판단하지 않습니다."
    }
  },
  "required": [
    "answer",
    "items",
    "ingredient_notice"
  ]
}
```

### VerificationResult

```json
{
  "type": "object",
  "properties": {
    "verification_id": {
      "type": "string"
    },
    "brand_id": {
      "type": "integer",
      "format": "int64",
      "minimum": 1
    },
    "expires_at": {
      "type": "string",
      "format": "date-time"
    },
    "status": {
      "type": "string",
      "enum": [
        "VERIFIED"
      ]
    }
  },
  "required": [
    "verification_id",
    "brand_id",
    "expires_at",
    "status"
  ]
}
```

### LevelPatch

```json
{
  "type": "object",
  "properties": {
    "weirdness_level": {
      "type": "string",
      "enum": [
        "초심자",
        "중급자",
        "상급자"
      ]
    }
  },
  "required": [
    "weirdness_level"
  ],
  "additionalProperties": false
}
```

### CsrfToken

```json
{
  "type": "object",
  "properties": {
    "header_name": {
      "type": "string",
      "enum": [
        "X-CSRF-TOKEN"
      ]
    },
    "token": {
      "type": "string"
    }
  },
  "required": [
    "header_name",
    "token"
  ]
}
```

### MenuMatchOutput

```json
{
  "type": "integer",
  "format": "int64",
  "minimum": 1,
  "nullable": true,
  "description": "내부 LLM의 JSON 출력. 동일한 기존 메뉴 ID 하나 또는 null. null은 신규 메뉴를 뜻하며 오류나 빈 응답을 null로 간주하지 않는다."
}
```
