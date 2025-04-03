# iOS-base-webview
Base iOS Webview Project (using tuist, UIKit)

## 📌 사용 방법

### 1️⃣ Tuist 설치 및 설정
1. 기존 `tuist` 제거 (이전 버전 충돌 방지)
   ```sh
   curl -Ls https://uninstall.tuist.io | bash
   ```
2. `mise` 설치 (tuist를 `mise`로 관리)
   ```sh
   curl https://mise.run | sh
   ```
3. `mise` 활성화
   mise 설치 후 터미널에 표시되는 명령어 입력
4. `mise` 버전 확인
   ```sh
   mise --version
   ```
5. `tuist` 설치
   ```sh
   mise install tuist
   ```
6. `tuist` 글로벌 활성화
   ```sh
   mise use -g tuist
   ```
7. `tuist` 버전 확인
   ```sh
   tuist version
   ```

### 2️⃣ 템플릿 프로젝트 생성
1. **템플릿을 클론합니다.**
   ```sh
   git clone https://github.com/wnsdud12/iOS-base-webview.git 사용할프로젝트명 // 사용할 프로젝트명으로 폴더명을 변경
   cd 사용할프로젝트명
   rm -rf .git // 깃 제거
   ```
2. **프로젝트 이름 변경**
   - `Project.swift`에서 `name` 값을 원하는 프로젝트 이름으로 수정합니다.
   - `bundleId`도 적절한 도메인으로 변경합니다.
3. **템플릿에서 필요한 패키지 설치**
   ```sh
   tuist install
   ```
4. **프로젝트 생성 & Xcode 자동 실행**
   ```sh
   tuist generate
   ```
5. **프로젝트 매니페스트 수정 (필요 시)**
   ```sh
   tuist edit
   ```

### 3️⃣ 오류 발생 시 대처 방법

1. mise 신뢰 경고

오류 메시지 예시
```
mise WARN  Config files in ~/path/to/your/project/mise.toml are not trusted.
Trust them with `mise trust`. See https://mise.jdx.dev/cli/trust.html for more information.
```
해결 방법
```zsh
mise trust
```
추후 다른 오류 발생 시 해당 섹션을 업데이트하여 해결 방법을 추가할 예정입니다.

###
