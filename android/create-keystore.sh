#!/bin/bash
# Android Upload Keystore 생성 스크립트
# 실행: bash create-keystore.sh

OUTPUT="upload-keystore.jks"

echo "================================================"
echo "  Android Upload Keystore 생성"
echo "================================================"
echo ""
echo "비밀번호는 안전한 곳에 꼭 저장해두세요."
echo "잃어버리면 새 앱 업로드가 불가능해집니다."
echo ""

keytool -genkey -v \
  -keystore "$OUTPUT" \
  -alias upload \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

echo ""
echo "✅ 완료: $(pwd)/$OUTPUT"
echo ""
echo "⚠️  이 파일을 절대 GitHub에 올리지 마세요!"
echo "    .gitignore에 이미 추가되어 있습니다."
