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
5. [ ] `build.gradle`에 keystore 서명 설정
6. [ ] Android Studio에서 AAB 빌드 (Release)  
       `🔑 Keystore 비밀번호 필요`

## iOS 빌드
7. [ ] Xcode에서 개발자 인증서 + 프로비저닝 프로파일 설정  
       `🔑 Apple Developer 계정 로그인 필요`
8. [ ] Xcode Archive → IPA 내보내기

## 스토어 앱 등록
9. [ ] Google Play Console 앱 등록 + AAB 업로드  
       `🔑 Google 개발자 계정 로그인 필요`
10. [ ] App Store Connect 앱 등록 + IPA 업로드 (TestFlight)  
        `🔑 Apple Developer 계정 로그인 필요`

## 인앱구매 설정
11. [ ] Google Play Console 인앱 상품 생성 (`unfollow_finder_premium` / $2.99)  
        `🔑 Google 개발자 계정`
12. [ ] App Store Connect 인앱 상품 생성 (`unfollow_finder_premium` / $2.99)  
        `🔑 Apple Developer 계정`
13. [ ] RevenueCat 계정 생성 및 iOS/Android 앱 연동  
        `🔑 RevenueCat 신규 가입 (revenuecat.com)`  
        → 대시보드에서 entitlement 식별자를 `premium`으로 생성하고 상품(`unfollow_finder_premium`)을 연결
14. [ ] RevenueCat 공개 SDK 키 발급 → `www/index.html`의 `RC_API_KEY_IOS` / `RC_API_KEY_ANDROID` 상수에 입력 → `npx cap sync` 후 재빌드  
        (IAP 코드는 구현 완료 — 키가 비어 있으면 결제 버튼은 "결제를 진행할 수 없어요" 안내만 표시)

## 테스트
15. [ ] iOS: TestFlight 내부 테스트 (본인 기기)  
        `🔑 Apple 기기 필요`
16. [ ] Android: Play Console 내부 테스트 트랙 설치  
        `🔑 Android 기기 필요`
17. [ ] IAP 샌드박스 결제 테스트

## 스토어 자료 업로드
18. [ ] 앱 아이콘 업로드 (iOS / Android)
19. [ ] 스크린샷 업로드 (iOS 1290×2796 / Android 1080×1920)
20. [ ] 온보딩 화면 이미지 업로드

## 심사 제출
21. [ ] Google Play 심사 제출 ⏱ 수일 ~ 2주
22. [ ] App Store 심사 제출 ⏱ 1~3일

---

## 참고 정보

| 항목 | 값 |
|------|-----|
| Bundle ID | `com.prontfor.unfollowfinder` |
| 개인정보처리방침 | `https://unfollow-finder-nu.vercel.app/privacy.html` |
| Keystore 위치 | `android/upload-keystore.jks` |
| Keystore alias | `upload` |
