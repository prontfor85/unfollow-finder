# Unfollow Finder — 배포 전체 체크리스트

---

## 앱 기본 설정
1. ✅ iOS 세로 전용으로 수정 (`Info.plist`)
2. ✅ Android BILLING 권한 추가 (`AndroidManifest.xml`)
3. ✅ 앱 메타데이터 작성 — 한국어 / 영어 (`app-store-metadata.md`)
4. ✅ Android Keystore 생성 (`upload-keystore.jks`)

## 배포 전 코드 수정 (2026-07-06 완료)
- ✅ 설정 화면 DEV 프리미엄 토글 제거 (결제 우회 + 심사 리젝 사유)
- ✅ RevenueCat IAP 클라이언트 코드 구현 — **API 키 입력만 남음** (아래 14번)
- ✅ 구매 복원(restore) 실구현 — 스토어 entitlement 기준, localStorage는 미러
- ✅ Android 하드웨어 뒤로가기 처리 (@capacitor/app — 모달/페이월/화면 스택 순서로 닫힘)
- ✅ 파서 수정 — `following_hashtags.json` 등이 팔로잉에 섞여 가짜 언팔로워 생기던 문제
- ✅ 무료 10명 제한 우회 차단 (검색/정렬/홈 비교분석 경로)
- ✅ 비교분석 인덱스 버그 수정 (무료 3개 상한에서 엉뚱한 기록끼리 비교되던 문제)
- ✅ 분석 중 페이월 강제 노출 제거 → "기록 미저장" 안내 토스트로 대체
- ✅ 에러 메시지 현지화(JSZip 영어 원문 노출 제거), 한쪽 파일 누락 안내
- ✅ i18n: 비교 화면 한국어 하드코딩 제거, ja/es 탭 가짜 0 제거, 분석 중 문구 번역 적용
- ✅ "15분 내 도착" 확정 약속 → 완충 문구로 (4개 언어)
- ✅ EN/ES 타이틀 상표 표기 완화 ("Unfollow Finder for Instagram")
- ✅ 접근성: 뒤로가기 aria-label, 페이월 닫기(X) 버튼, 복원 버튼 터치 타깃 44px
- ✅ 네이티브: 기록 내보내기 공유 시트(iOS a[download] 미동작 대응), accept 타입 확장, 검색 인풋 16px(iOS 자동 확대 방지), theme-color 수정(#03C75A→#0E0E12), 저장 실패 토스트
- 백업: `index-backup-20260706.html` (수정 전 원본)

## Android 빌드
5. ✅ `build.gradle`에 keystore 서명 설정 (`android/app/build.gradle` — 비밀번호는 하드코딩 없이 `KEYSTORE_PASSWORD` 환경변수/gradle property로 주입)
6. ✅ AAB 빌드 완료 (`gradlew bundleRelease`, 터미널) — `android/app/build/outputs/bundle/release/app-release.aab`
       (keystore 비밀번호 분실로 upload-keystore.jks 재발급 — 기존 파일은 `upload-keystore-old-lost-password.jks`로 백업)

## iOS 빌드
7. ✅ Xcode에서 개발자 인증서 + 프로비저닝 프로파일 설정 (개인 Apple 계정, Automatically manage signing)
8. ✅ Xcode Archive → Distribute App → App Store Connect 업로드 완료

## 스토어 앱 등록
9. ✅ Google Play Console 앱 등록 + AAB 업로드 완료 (내부 테스트 트랙, 패키지명 `com.prontfor.unfollowfinder2`)
10. ✅ App Store Connect 앱 등록 + 빌드 업로드 완료 (TestFlight에 곧 표시됨, 처리에 몇 분~1시간 소요될 수 있음)

## 인앱구매 설정
11. ✅ Google Play Console 인앱 상품 생성 (`unfollow_finder_premium`, 구매 옵션 `premium-buy`, $2.99, 173개국 활성)
12. ✅ App Store Connect 인앱 상품 생성 (`unfollow_finder_premium`, 비소모품, $2.99, 175개국) — 심사 제출 전 스크린샷 추가 필요
13. ✅ RevenueCat 계정 생성 및 iOS/Android 앱 연동 완료
        - App Store 앱: Bundle ID `com.prontfor.unfollowfinder`, In-App Purchase P8 키 연결 (Valid credentials)
        - Play Store 앱: Package `com.prontfor.unfollowfinder2`, Service Account JSON 연결 (권한 반영 대기 가능성 있음)
        - entitlement 식별자 `premium` 생성 + 상품 `unfollow_finder_premium`(iOS/Android 양쪽) 연결 완료
14. ✅ RevenueCat 공개 SDK 키 입력 + 재빌드/업로드 완료
        - `RC_API_KEY_IOS`=appl_..., `RC_API_KEY_ANDROID`=goog_... 입력 후 `npx cap sync`
        - Android: versionCode 3으로 재빌드 → Play Console 내부 테스트 출시 완료
        - iOS: Build 4로 Archive → App Store Connect 업로드 완료

## 테스트
15. [ ] iOS: TestFlight 내부 테스트 (본인 기기)  
        `🔑 Apple 기기 필요`
16. [ ] Android: Play Console 내부 테스트 트랙 설치  
        `🔑 Android 기기 필요`
17. [ ] IAP 샌드박스 결제 테스트

## 스토어 자료 업로드 (자산 제작 2026-07-26 완료 — 업로드만 남음)
18. [ ] 앱 아이콘 업로드 (iOS / Android)
    - ⚠️ 기존 네이티브 아이콘/스플래시가 **Capacitor 기본 템플릿(파란 X)이었음** → 브랜드 아이콘(보라→핑크 그라데이션)으로 전체 재생성 완료 (`@capacitor/assets`, 소스: `assets/`)
    - **아이콘이 바뀌었으므로 iOS/Android 재빌드 후 업로드 필수**
    - 스토어용: iOS 1024 자동(에셋 카탈로그), Play 512 = `www/icon-512.png`
19. [ ] 스크린샷 업로드 — 제작 완료
    - iOS: `screenshots/png/` (1290×2796, kr/en 각 6장: onboarding·upload·result·compare·history·paywall)
    - Play: `screenshots/png-android/` (1290×2280 — 9:16 이내, kr/en 각 6장)
    - Play 그래픽 이미지(필수): `screenshots/store-assets/feature-graphic-{kr,en}.png` (1024×500)
20. [x] 온보딩 화면 이미지 — 스크린샷 세트에 포함 (`*_onboarding.png`)

## 심사 제출
21. [ ] Google Play 심사 제출 ⏱ 수일 ~ 2주
22. [ ] App Store 심사 제출 ⏱ 1~3일
    - 리뷰어 안내문·개인정보 설문 답변·데모 ZIP: `store-review-notes.md` 참고
    - 제출 전 Vercel 재배포 필요 (데모 ZIP URL 활성화)

---

## 참고 정보

| 항목 | 값 |
|------|-----|
| Bundle ID (iOS) | `com.prontfor.unfollowfinder` |
| Package name (Android) | `com.prontfor.unfollowfinder2` (기존 Play Console 등록 keystore 비번 분실로 변경) |
| 개인정보처리방침 | `https://unfollow-finder-nu.vercel.app/privacy.html` |
| Keystore 위치 | `android/upload-keystore.jks` |
| Keystore alias | `upload` |
