# 심사 제출 준비물 (App Review / Play 심사)

작성: 2026-07-26 · 제출 시 콘솔에 붙여넣을 답변과 리뷰어 안내 모음

---

## 1. 리뷰어용 데모 ZIP

앱 테스트에는 인스타그램 데이터 내보내기 ZIP이 필요한데, 심사관은 인스타 계정 데이터를 준비하기 어려우므로 **데모 ZIP을 반드시 리뷰 노트에 첨부**해야 합니다.

- 파일 위치: `web/www/demo/instagram-demo.reviewer-2026-07-20-sample.zip` (1.8KB, 앱 번들에도 포함됨)
- 공개 URL: `https://unfollow-finder-nu.vercel.app/demo/instagram-demo.reviewer-2026-07-20-sample.zip`
  ⚠️ **Vercel 재배포 후에 URL이 활성화됩니다** (`web/`에서 `vercel --prod`)
- 파서 검증 완료: 팔로워 25 / 팔로잉 35 → 나를 팔로우 안 함 15 · 맞팔 20 · 내가 팔로우 안 함 5, 계정 @demo.reviewer 자동 인식

## 2. App Review 노트 (Apple — 그대로 복사)

```
HOW TO TEST THIS APP

This app analyzes the user's own Instagram data-export ZIP file, entirely
on-device. It never asks for Instagram credentials and makes no network
requests with user data.

Since requesting a real Instagram data export takes time, please use our
sample export file to test:

1. Download the sample ZIP on the test device:
   https://unfollow-finder-nu.vercel.app/demo/instagram-demo.reviewer-2026-07-20-sample.zip
2. Open the app → complete onboarding → tap "Analyze".
3. You may skip the in-app Instagram export guide (tap "Skip").
4. On the upload screen, select the downloaded ZIP file.
5. Tap "Analyze" to see results (15 unfollowers, 20 mutuals, 5 fans).

IN-APP PURCHASE
- One-time non-consumable "Premium" ($2.99): unlocks the full result list
  (free tier shows top 10), unlimited history, and the Compare feature.
- Purchases are processed via StoreKit through RevenueCat. Restore Purchase
  is available on the paywall.

PRIVACY
- No account, no login, no server. The ZIP is parsed locally in the app.
- The privacy policy is available in-app (Settings → Privacy Policy) and at
  https://unfollow-finder-nu.vercel.app/privacy.html
```

## 3. Apple App Privacy (개인정보 보호 설문)

RevenueCat(IAP SDK) 사용 기준. 제출 전 RevenueCat 공식 문서의 최신 권고("Apple App Privacy" 페이지)와 대조 권장.

| 질문 | 답변 |
|------|------|
| Do you collect data from this app? | **Yes** (RevenueCat이 구매 정보 수집) |
| Purchases → Purchase History | ✅ 수집함 |
| ├ Linked to user's identity? | **No** (익명 앱 사용자 ID만 사용) |
| ├ Used for tracking? | **No** |
| └ Purpose | App Functionality |
| Identifiers / Contact Info / Content / Usage Data / Diagnostics 등 나머지 전부 | 수집 안 함 |

- 인스타그램 ZIP 데이터(팔로워 목록)는 **기기를 떠나지 않으므로 "수집"에 해당하지 않음** (Apple 정의상 수집 = 기기 외부 전송).

## 4. Google Play Data Safety (데이터 보안 설문)

| 질문 | 답변 |
|------|------|
| Does your app collect or share any of the required user data types? | **Yes** |
| Financial info → Purchase history | 수집함 · 공유 안 함 |
| ├ Processed ephemerally? | No |
| ├ Required or optional? | Optional (프리미엄 구매 시에만) |
| └ Purpose | App functionality |
| Data encrypted in transit? | **Yes** |
| Can users request data deletion? | RevenueCat 대시보드를 통해 삭제 처리 가능 → **Yes** 권장 (지원 이메일 prontfor.studio@gmail.com 기재) |
| 나머지 데이터 유형 전부 | 수집 안 함 |

## 5. 콘텐츠 등급 설문 힌트

- 폭력/성적 콘텐츠/도박/약물: 전부 없음
- 사용자 생성 콘텐츠(UGC)·소셜 기능: **없음** (타인과 상호작용 없음, 본인 데이터 분석만)
- 개인 위치 공유: 없음
- 예상 등급: 만 3세+/전체이용가

## 6. 알려진 심사 리스크와 대응

1. **가이드 이미지의 Meta 로고** (`www/guide/`): 실제 인스타그램 UI 스크린샷 사용 중.
   → 지적받으면: 스크린샷을 단순 일러스트/모형으로 교체 후 재제출.
2. **"Instagram" 명칭 사용**: 앱 이름은 `Unfollow Finder`(상표 미포함), 부제·설명에서만
   "for Instagram" 형태로 사용 — Apple 4.1/상표 가이드에 일반적으로 허용되는 패턴.
   스토어 등록 시 앱 이름에 Instagram을 넣지 말 것.
3. **IAP 심사**: 심사관이 구매를 테스트할 수 있으므로 App Store Connect에서
   IAP 상품(unfollow_finder_premium)을 **앱 버전과 함께 심사 제출**에 포함할 것.
4. **계정 없는 앱**: "로그인이 없는데 왜 소셜 앱인가" 질문 대비 → 리뷰 노트에
   "No account system; analyzes user's own exported data locally" 명시(위 노트에 포함됨).

## 7. 제출 직전 최종 체크

- [ ] RevenueCat 키 입력 후 빌드인지 확인 (키 없으면 결제 버튼이 안내만 표시됨 → IAP 심사 불가)
- [ ] Vercel 재배포 (`vercel --prod`) — 데모 ZIP URL + privacy.html 최신화
- [ ] 스크린샷 업로드: iOS `screenshots/png/`(6장: onboarding, upload, result, compare, history, paywall) / Play `screenshots/png-android/`(6장)
- [ ] Play 그래픽 이미지: `screenshots/store-assets/feature-graphic-{kr,en}.png`
- [ ] 새 앱 아이콘 포함 빌드인지 확인 (2026-07-26에 Capacitor 기본 아이콘 → 브랜드 아이콘으로 교체됨. **재빌드 필수**)
