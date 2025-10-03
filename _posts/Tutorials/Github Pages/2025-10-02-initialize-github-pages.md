---
layout: post
title: 1. Github Pages 설정하기
author: blu
date: 2025-10-02 03:28 +0900
tags:
  - Github
  - Github Pages
  - Jekyll
---

## 1. Github 계정 만들기

[Github](https://github.com)에서 계정 생성하기.

기존 Github 계정을 사용해도 되지만 여러 author와 같이 꾸며나가고 싶어 새로운 Github 계정을 만들게 되었다. 기존 계정이 있는 사람은 계속 사용하면 된다.

## 2. 테마 고르기

Github Pages는 Ruby 언어를 사용하는 Jekyll을 지원한다.  
직접 Jekyll을 통해 사이트를 만드는 것도 멋진 일이지만, 다양한 분들이 만들어둔 theme를 사용할 수 있다는 것도 장점이다.

[#jekyll-theme](https://github.com/topics/jekyll-theme) Github 토픽이나 Jekyll 테마를 공유, 판메하는 사이트에서 Jekyll 템플릿을 찾아볼 수 있다.  
테크 블로그를 위해 카테고리가 제대로 표시되고, 현재 페이지의 목차, 읽고 난 뒤에 유사한 컨텐츠를 추천, 세련된 디자인 등의 기준으로 괜찮은 테마를 찾아보았다.

위 기준으로 [Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) 테마를 선택했다.
![[image2.png]]

아래의 작업은 Chirpy 테마 기준으로 작성되어 있어 다른 테마를 사용할 때와는 초기 설정 과정이 다소 다를 수 있다.

## 3. github.io Repository 만들기

![[image1.png]]

[Chirpy](https://github.com/cotes2020/jekyll-theme-chirpy)를 내 repository로 fork한다. 이 때 repository name은 `{github-username}.github.io`로 설정하여야 한다.  
e.g., `neoul-ro.github.io`

<!-- markdownlint-capture -->
<!-- markdownlint-disable -->
> Repository는 Github Pages로 호스팅하면 `README.md`{: .filepath}나 `index.html`{: .filepath} 등을 홈페이지처럼 사용할 수 있다. 이 때 도메인은 `{username}.github.io/{repo_name}`이 된다.
> 
> `{username}.github.io`이름의 repository만 default 페이지인 `{username}.github.io`로 호스팅된다.
{: .prompt-tip }
<!-- markdownlint-restore -->

## 4. Jekyll 설치하기

결과적으로 호스팅은 Github Action에서 진행하겠지만, 수정한 부분을 바로바로 빌드해서 확인하기 위해서는 로컬 환경(또는 Docker로)에 Jekyll을 설치해야 한다.  
특히, Chirpy에서 초기 설정 코드를 사용하기 위해선 Jekyll 설치가 필수.

설치 과정은 MacOS 기준으로 작성하였다.

### 4.1. [`homebrew`](https://brew.sh/)나 [`Git`](https://git-scm.com/)이 없다면 미리 설치하도록 하자

~~~bash
# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# git
brew install git
~~~

### 4.2. `Ruby` 설치

~~~bash
# chruby, ruby-install 설치
brew install chruby ruby-install

# ruby 설치
ruby-install ruby 3.4.1

# chruby 명령어를 이용하도록 .zshrc에 추가
echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
echo "chruby ruby-3.4.1" >> ~/.zshrc
~~~

설치 후 터미널을 새로 열거나, `source` 하여 초기화한 후 `ruby` 설치를 확인한다.

~~~bash
source ~/.zshrc

# ruby 설치 확인
ruby -v # should be ruby 3.4.1 or newer
~~~

<!-- markdownlint-capture -->
<!-- markdownlint-disable -->
> 가끔 `.zshrc`에 줄바꿈이 안되어 있어서 `vi`나 기본 텍스트 에디터로 확인하는 편이다.  
~~~bash
vi ~/.zshrc
# 또는
open -a TextEdit ~/.zshrc
~~~
{: .prompt-tip }
<!-- markdownlint-restore -->

### 4.3. `Jekyll` 설치

~~~bash
# jekyll 설치
gem install jekyll

# jekyll 설치 확인
jekyll -v # should be jekyll 4.4.1 or newer
~~~

## 5. Chirpy 초기 설정

### 5.1. `Node.js` 설치

Chirpy는 초기 설정 shell script를 통해 편하게 초기 설정이 가능하다. 하지만 초기 설정을 위해 `Node.js`가 설치되어 있어야 한다.

[Node.js](https://nodejs.org/ko/download) 에서 설치하거나, MacOS라면 아래 명령어로 설치할 수 있다.

~~~
# nvm 설치
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Node.js 설치
nvm install 22

# Node.js 설치 확인
node -v # "v22.20.0"가 출력되어야 합니다.
nvm current # "v22.20.0"가 출력되어야 합니다.
npm -v # 10.9.3가 출력되어야 합니다.
~~~

### 5.2. Fork한 repository를 clone한 뒤, `tools/init.sh`{:.filepath}를 이용하여 초기화한다.

~~~bash
git clone https://github.com/{username}/{username}.github.io.git
# https://github.com/neoul-ro/neoul-ro.github.io.git

cd {username}.github.io # neoul-ro.github.io
bash tools/init.sh
~~~

## 6. `Jekyll` 서버 시작

다음 명령어를 통해 `Jekyll` 서버를 시작할 수 있다.

~~~bash
bundle exec jekyll serve
~~~

서버를 켠 뒤, 로컬 서버 주소 [http://127.0.0.1:4000](http://127.0.0.1:4000/)를 통해 홈페이지를 볼 수 있다.  
물론 로컬 서버이기 때문에 `{username}.github.io`로 접속할 수는 없다. Deploy는 [8. Github Action으로 Deploy하기](#8-github-action으로-deploy하기) 참조.

## 7. 기본 설정
### 7.1. `_config.yml`{: .filepath} 설정

`_config.yml`{: .filepath} 파일에서 홈페이지의 기본 설정을 할 수 있다. 나는 다음과 같이 입력하였다.  
아바타 파일 또한 `assets/img/avatar.png`{:.filepath} 파일로 저장하여 바꿀 수 있다.

~~~yaml
lang: ko-KR
timezone: Asia/Seoul
title: neoul RoAD
tagline: Robotics & Autonomous Driving
description: >- 
  neoul blog about Robotics & Autonomous Driving
url: "https://neoul-ro.github.io"
github:
  username: neoul-ro
social:
  name: neoul
  email: neoul.ro@gmail.com
  links:
    - https://github.com/neoul-ro
avatar: "/assets/img/avatar.png"
~~~
{: file="_config.yml" }

외에도 링크가 카테고리를 포함하도록 `permalink`를 변경하였고, 많은 포스트에서 수식을 사용할 것 같아 `math`를 기본으로 사용하게 하였다.
~~~yaml
defaults:
  - scope:
      path: ""
      type: posts
    values:
      layout: post
      comments: true
      toc: true
      permalink: /posts/:categories/:title/
      math: true
~~~
{: file="_config.yml" }

### 7.2. `_data/authors.yml`{: .filepath} 설정

`_data/authors.yml`{: .filepath}에서 author 정보를 설정하여야 포스트 작성 시 `header`의 `author`를 인식하여 정보를 띄워준다.  실제로 띄우는 author 이름은 name 란에 정의한다. 이름을 누르면  `url`의 링크로 연결된다.

~~~yaml
neoul:
  name: neoul
  twitter:
  url: https://github.com/neoul-ro/
~~~

## 8. Github Action으로 Deploy하기

초기 설정을 완료했다면, 변경 내용을 commit, push한다.
Github의 Repository 설정 > Pages에서 Github Actions를 이용하여 deploy한다.

![[image3.png]]
![[image4.png]]

작성 중 빌드 오류는 Jekyll 서버 터미널에서 확인이 가능하고, Deploy에서의 빌드 오류는 repository의 Actions 탭에서 확인 가능하다.

## Reference
[https://chirpy.cotes.page/posts/getting-started/](https://chirpy.cotes.page/posts/getting-started/)


