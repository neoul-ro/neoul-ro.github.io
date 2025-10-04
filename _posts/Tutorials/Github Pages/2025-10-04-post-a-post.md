---
layout: post
title: 3. 명령어로 Jekyll 포스트 템플릿 자동화하기
date: 2025-10-04 07:02 +0900
author: blu
tags:
- Github
- Github Pages
- Jekyll
---

## 1. 포스트 템플릿 자동화가 필요한 이유

Chirpy 테마를 처음 설정했을 때는 `_posts/`{: .filepath} 폴더에 있는 샘플 파일을 복사해서 제목과 날짜를 일일이 바꿨다.  
하지만 블로그를 꾸준히 운영하려면 날짜, 카테고리, 기본 front matter를 매번 타이핑하는 일이 은근 번거롭다.  
[1편]({% post_url Tutorials/Github Pages/2025-10-02-initialize-github-pages %})에서 로컬 Jekyll 환경을 구축했다면, 이제 터미널에서 명령 한 번으로 새 글 뼈대를 만드는 자동화가 가능하다.

- 카테고리와 태그 구조를 통일할 수 있다.
- 포스트 파일명이 날짜로 정렬되어 나중에 찾기 쉽다.
- 기본 템플릿이 자동으로 채워지므로 작성에만 집중할 수 있다.

이번 글에서는 `jekyll-compose` 플러그인을 설치해 `bundle exec jekyll post` 명령어로 새 글을 생성하는 과정을 정리한다.

## 2. `jekyll-compose` 설치하기

### 2.1. `Gemfile`{: .filepath}에 플러그인 추가

`jekyll-compose`는 포스트, 페이지, 초안(draft) 등의 템플릿을 자동으로 생성해주는 Jekyll 플러그인이다.  
프로젝트 루트에서 `Gemfile`{: .filepath}에 다음 내용을 추가한다. `logger`는 Ruby 3.5에서 발생하는 경고를 잠재우기 위한 의존성이다.

~~~ruby
# Provides `jekyll post` and other content scaffolding commands.
gem "jekyll-compose", group: :jekyll_plugins

# Explicit dependency to silence Ruby 3.5 logger warning.
gem "logger"
~~~
{: file="Gemfile" }

플러그인을 추가했다면 의존성을 설치한다. [1편]({% post_url Tutorials/Github Pages/2025-10-02-initialize-github-pages %}#4-jekyll-설치하기)에서 Ruby와 Bundler를 이미 설치해두었으니 바로 실행 가능하다.

~~~bash
bundle install
~~~

설치 후 `bundle exec jekyll -v`를 실행했을 때 에러가 없다면 플러그인이 정상적으로 로드된 것이다.

### 2.2. `_config.yml`{: .filepath}에서 기본 front matter 지정

`jekyll-compose`는 `_config.yml`{: .filepath}의 `jekyll_compose.default_front_matter`에 정의한 값을 기본 front matter로 채워준다.

~~~yaml
jekyll_compose:
  # Prepopulate new posts generated via `jekyll post`.
  default_front_matter:
    posts:
      layout: post
      author: blu
      categories:
        - ~
      tags:
        - ~
      comments: true
      media_subpath: ~
~~~
{: file="_config.yml" }


[2편]({% post_url Tutorials/Github Pages/2025-10-03-utterances %})에서 댓글 설정을 해두었다면, 새 글이 생성될 때 `comments: true` 같은 공통 옵션을 미리 넣어 둘 수도 있다.  
각 필드는 아래처럼 동작한다.  
- `title`: 생성되는 포스트의 제목을 설정한다. 파일명과는 상관없이 화면에 노출되는 제목은 `title` 값이 사용된다.
- `author`: `_data/authors.yml`{: .filepath}에 정의된 키와 매칭되어 이름, 링크 등을 자동으로 붙여준다.
- `categories`: Chirpy의 폴더 기반 카테고리를 설정할 수 있다. 작성하는 순서대로 대분류에서 소분류 순서로 카테고리가 된다.
- `tags`: 포스트 하단의 태그 목록과 검색 필터에 쓰인다.
- `comments`: `true`로 두면 [Utterances 설정]({% post_url Tutorials/Github Pages/2025-10-03-utterances %})을 따라 댓글 영역이 렌더링된다.
- `media_subpath`: 실제 이미지가 위치할 폴더를 지정한다. 이 부분을 추가하면 이미지를 추가할 때 하위 경로만 작성하면 된다.
`~`는 자리 표시자로, 빈 상태로 작성된다.

## 3. `bundle exec jekyll post` 명령어 사용하기

플러그인이 준비되었다면 루트 디렉터리(예: `neoul-ro.github.io/`)에서 다음 명령을 실행한다.  
포스트 생성의 경우는 [1편]({% post_url Tutorials/Github Pages/2025-10-02-initialize-github-pages %}#6-jekyll-서버-시작)에서 실행했던 Jekyll 서버를 끈 상태여도 무방하다.

~~~bash
bundle exec jekyll post "test"
~~~

성공하면 아래와 같이 새 파일 위치가 출력된다.

```
New post created at _posts/2025-10-04-test.md
```

파일을 열어보면 `_config.yml`{: .filepath}에서 정의한 기본 front matter가 채워져 있다.  
제목은 입력한 문자열이 `kebab-case`로 변환되어 파일명에 포함되고, 날짜는 실행 시점의 타임존을 따라간다.

{: .text-center}
![result](image.png){: width="80%"}

## 4. 생성 직후 점검 목록

- **Front matter 보완**: `author`, `tags`, `categories`가 원하는 값인지 확인하고 필요 시 추가 필드를 작성한다. 댓글 설정을 위해서는 `comments: true`를 유지해야 [2편]({% post_url Tutorials/Github Pages/2025-10-03-utterances %})에서 구성한 Utterances가 동작한다.
- **로컬 프리뷰**: `bundle exec jekyll serve`로 서버를 띄워 브라우저에서 확인할 수 있다. 이전 글([1편]({% post_url Tutorials/Github Pages/2025-10-02-initialize-github-pages %}#6-jekyll-서버-시작))을 참고.

## 5. 활용 팁

- 초안 작성 시에는 `bundle exec jekyll draft "My Draft"`를 사용하면 `_drafts/`{: .filepath}에 생성된 파일을 완성 후 `publish` 명령으로 옮길 수 있다.
- 파일명을 다시 정리하고 싶다면 `bundle exec jekyll rename "old-title" "new-title"` 명령을 활용한다. 날짜까지 함께 바뀌므로 퍼머링크도 자동으로 업데이트된다.
- 스크린샷의 그림자가 거슬린다면 [Mac 스크린샷 여백 제거]({% post_url Tutorials/MacOS/2025-10-03-mac-capture-without-shadow %}) 글에서 정리한 설정으로 이미지를 깔끔하게 관리할 수 있다.

명령어 기반 워크플로우를 구축해두면 새 글을 쓸 때마다 반복 작업을 줄이고 콘텐츠 작성에 집중할 수 있다.

다음에는 마지막 수정 날짜를 자동으로 표시하는 Hook 플러그인 코드를 살펴보도록 하겠다.

