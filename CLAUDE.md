# 언팔 찾기 (Unfollow Finder)

인스타그램 데이터 내보내기 ZIP을 기기 안에서 분석해 언팔로워를 찾아주는 Capacitor(iOS/Android) 앱. 배포 준비 단계.

## 구조
- UI/로직 전체가 단일 파일: `www/index.html` (~2,700줄)
  - 파일 상단 15~28행은 **인라인 JSZip 라이브러리** — 절대 수정하지 말 것. 앱 코드는 그 아래부터.
  - 다국어는 `const T = { ko, en, ja, es }` 객체. **문자열 수정/추가 시 4개 언어 모두 반영할 것.**
  - 화면 전환은 `go(name)` + `screenStack`(히스토리 API 안 씀), 하단 CTA는 `renderButton(name)`.
- 네이티브 프로젝트: `ios/`, `android/` — 루트에서 `npx cap sync` 하면 www가 복사됨. **www 수정 후 sync 필수.**
- Android 서명 키(`android/upload-keystore.jks`)는 **git에 없음** — 기기 간 이동 시 안전한 경로로 별도 전달.
- 배포 절차/완료 내역: `deployment-checklist.md`

## 2026-07-06 완료된 수정 (요약)
UI/UX 전수 리뷰 후 배포 차단급 5건 + 주요 개선 반영, 프리뷰 검증 완료 (상세 diff는 해당 커밋 참고):
1. 설정의 DEV 프리미엄 토글 제거
2. 결제를 RevenueCat 실연동 코드로 교체 (`purchasePremium`/`restorePurchase`/`initPurchases`) — 스토어 entitlement가 진실, `localStorage['iuf_premium']`은 미러
3. 비교분석을 인덱스 대신 스냅샷 객체(`state.compareTargetSnap`, `renderCompare`) 기반으로 수정
4. Android 뒤로가기 처리 (`@capacitor/app`, `closeTopLayer()` → `goBack()`)
5. ZIP 파서 엄격 매칭 — `following_hashtags.json` 오염 제거 (`handleZip`)
6. 무료 10명 제한 우회 차단 (`renderList`의 freeSet 클램프 + 홈 비교 버튼 프리미엄 게이트)
7. 에러 현지화(`userErr`/`zip_open_error`), 부분 파일 안내, i18n 하드코딩 제거, 15분 문구 완충, 접근성(aria/터치타깃/16px 인풋), theme-color 수정, 기록 내보내기 네이티브 공유 시트

## 남은 배포 작업
1. RevenueCat 가입 → entitlement `premium` 생성, 상품 `unfollow_finder_premium` 연결
2. 발급받은 공개 SDK 키를 `www/index.html`의 `RC_API_KEY_IOS` / `RC_API_KEY_ANDROID` 상수에 입력 → `npx cap sync` → 재빌드
   (키가 비어 있는 동안 결제 버튼은 "결제를 진행할 수 없어요" 안내만 표시 — 무료 지급 없음)
3. 샌드박스 결제/복원 테스트, 실기기에서 뒤로가기·파일 선택·공유 시트 확인
4. 잔여 리스크: 가이드 이미지(`www/guide/`)에 Meta 로고 포함 실제 스크린샷 — 심사 지적 시 이미지 교체 필요

## 로컬 실행/테스트
- 프리뷰: `npx http-server www -p 8787 -c-1`
- 실데이터 없이 테스트: 브라우저 콘솔에서 인라인 JSZip으로 가짜 내보내기 ZIP 생성 →
  `zip.file('followers_1.json', ...)` + `zip.file('following.json', {relationships_following: [...]})` 형태
  (항목 형식: `{string_list_data:[{value:'유저명', href, timestamp}]}`) → `handleZip(file)` 호출
- 언어 강제: `setLang('en'|'ja'|'es'|'ko')`, 프리미엄 시뮬레이션: `localStorage.setItem('iuf_premium','true')` (콘솔 전용)
