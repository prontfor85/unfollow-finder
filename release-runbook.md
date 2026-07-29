# 출시 실행 런북 (2026-07-27 기준 남은 작업)

코드/자산/문서는 모두 완료. 아래만 실행하면 심사 제출까지 끝. 상세 배경은 `deployment-checklist.md`, 심사 답변은 `store-review-notes.md` 참고.

---

## 0. ⚠️ keystore 비밀번호 교체 (최우선 — 비밀번호가 채팅에 노출된 사고 있었음)

```bash
cd /Users/bhaptics/Documents/Claude/Projects/insta/web/android && "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" -storepasswd -keystore upload-keystore.jks
```
→ 기존 비밀번호 → 새 비밀번호 2회

```bash
cd /Users/bhaptics/Documents/Claude/Projects/insta/web/android && "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" -keypasswd -alias upload -keystore upload-keystore.jks
```
→ 키 비밀번호도 **같은 새 값으로** (빌드 설정이 스토어/키 동일 비밀번호 사용)

새 비밀번호는 비밀번호 관리자에 보관. **분실 시 앱 업데이트 배포 불가.**

## 1. Android AAB 빌드 → Play Console 내부 테스트 업로드

이 맥에는 Java가 없고 Android Studio 내장 JDK를 사용해야 함. 비밀번호는 `read -s`로 입력(히스토리에 안 남음):

```bash
cd /Users/bhaptics/Documents/Claude/Projects/insta/web/android && read -s -p "keystore 비밀번호: " KEYSTORE_PASSWORD && export KEYSTORE_PASSWORD && echo && JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home" ./gradlew bundleRelease
```

- 성공 시 `BUILD SUCCESSFUL` + `app/build/outputs/bundle/release/app-release.aab` 생성 (versionCode 4)
- Play Console → 테스트 → **내부 테스트** → 새 릴리스 만들기 → AAB 업로드 → 출시
- 테스터 탭에 본인 계정 추가 → 참여 링크로 폰에 설치
- 설치 후 **아이콘이 보라-핑크인지 확인** (파란 X면 옛 빌드)

## 2. iOS Archive → App Store Connect 업로드

```bash
open /Users/bhaptics/Documents/Claude/Projects/insta/web/ios/App/App.xcodeproj
```

1. 기기 선택 → **Any iOS Device (arm64)**
2. App 타깃 → Signing & Capabilities → Team 확인
3. **Product → Archive** → Organizer → **Distribute App → App Store Connect → Upload**
4. 처리 10~30분 후 TestFlight에 빌드 3 표시 → 폰에 설치

## 3. git push + Vercel 재배포

```bash
cd /Users/bhaptics/Documents/Claude/Projects/insta/web && git push
```

```bash
cd /Users/bhaptics/Documents/Claude/Projects/insta/web && vercel --prod
```

배포 후 데모 ZIP URL이 404 아닌지 확인:
`https://unfollow-finder-nu.vercel.app/demo/instagram-demo.reviewer-2026-07-20-sample.zip`

## 4. 스토어 자산 업로드

**Play Console** (스토어 등록정보):
- 아이콘 512: `web/www/icon-512.png`
- 그래픽 이미지: `screenshots/store-assets/feature-graphic-kr.png` (영어 등록정보엔 `-en`)
- 스크린샷: `screenshots/png-android/kr_*.png` 6장 (영어: `en_*.png`)
- 언어 추가(en/ja/es) 시 설명은 `app-store-metadata.md`에서 복사

**App Store Connect** (1.0 버전 페이지):
- 6.9형 디스플레이 슬롯에 `screenshots/png/kr_*.png` 6장 (현지화별 en 세트)
- 현지화 언어 추가 → `app-store-metadata.md`의 각 언어 섹션 복사

## 5. 심사 정보 입력 + 제출 (`store-review-notes.md` 옆에 열기)

**App Store Connect:**
1. 앱 개인정보 보호 설문 → 노트 문서 3번 섹션 표 그대로
2. App Review 메모란 → 노트 문서 2번 섹션 영문 전체 복사 (데모 ZIP 안내)
3. 버전 페이지에서 빌드 선택 + **인앱 구입 `unfollow_finder_premium` 추가** (빠지면 IAP 심사 불가)
4. 제출

**Play Console:**
1. 앱 콘텐츠 → 데이터 보안 → 노트 문서 4번 섹션 표 그대로
2. 콘텐츠 등급 설문 → 노트 문서 5번 섹션 (전부 없음 → 전체이용가)
3. 내부 테스트 통과 후 프로덕션으로 같은 AAB 승격 → 제출

**제출 전**: RevenueCat 대시보드에서 Android 앱 패키지명 = `com.prontfor.unfollowfinder2` 확인 (iOS는 `com.prontfor.unfollowfinder` — 서로 다른 게 현재 정상 상태)

## 6. 결제 샌드박스 테스트

- Android: Play Console 설정 → 라이선스 테스트에 본인 계정 추가 → 내부 테스트 빌드에서 결제 → 삭제 → 재설치 → **구매 복원** 확인
- iOS: TestFlight 빌드는 자동 샌드박스 → 같은 시나리오 확인
- "결제를 진행할 수 없어요" 뜨면: 콘솔 인앱 상품 활성 여부 → RevenueCat entitlement `premium`에 상품 연결 여부 순으로 확인
