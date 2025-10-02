---
layout: post
title: 2. Utterances로 Github Pages 댓글란 만들기
author: blu
date: 2025-10-03 03:57 +0900
tags:
- Github
- Github Pages
- utterances
---

## Github Pages 댓글란

여러 Github Pages로 호스팅되는 사이트를 보면 아래처럼 댓글란이 있는 것을 확인할 수 있다.
![comments](image3.png)

내가 선택한 테마나 대부분의 Jekyll 테마에서는 `disqus`, `utterances`, `giscuc` 등의 댓글 관리 앱을 사용할 수 있도록 설정이 되어 있다.

나는 그 중에서 `utterances`를 이용해 댓글란을 설정해보았다.

## Utterances 란?

`utterances`는 Github repository의 issue를 통해 댓글을 관리하는 Github용 앱이다.

댓글을 작성하기 위해선 Github에 로그인을 해야하고, 댓글을 작성하면 설정한 repository의 issue로 등록되어 관리가 가능한 도구이다.

## Utterances 설치하기

먼저 [Utterances Github app](https://github.com/apps/utterances)을 설치한다.

![utterances](image.png)

Utterances를 사용할 repository를 지정해준다. 나는 comments라는 repo를 따로 만들어서 그 곳에서 댓글을 관리하기로 했다.  

![install utterances](<스크린샷 2025-10-03 오전 5.14.48.png>){: width="70%" .d-block .mx-auto }

설정 후 나오는 configuration를 통해 내 사이트에 추가할 수 있는데, 대부분의 Jekyll 테마에서는 `_config.yml`{:.filepath}에서 설정하도록 되어있다.

## `_config.yml`{:.filepath} 수정하기

`_config.yml`{:.filepath}안에는 이미 댓글 관리를 위한 부분이 작성되어 있을 것이다. 여기에 사용할 댓글 관리 앱과 repository를 지정해준다.  
issue_term은 댓글과 issue를 어떻게 매칭할지 지정하는 것인데, 여러 방법이 있지만 나는 `pathname`으로 설정해주었다.

~~~yaml
comments:
  provider: utterances
  utterances:
    repo: neoul-ro/comments
    issue_term: pathname
~~~
{: file="_config.yml" }

## 설정 후

설정 후에 deploy한 다음 댓글을 작성하면 `neoul-ro/comments` repository에 다음처럼 issue에 해당 내용이 작성되는 것을 확인할 수 있었다.

![issue](image4.png)



다음에는 `Ruby`로 코드를 작성하여 여러 기능을 수행하는 Jekyll Hook 플러그인을 만들어보도록 하겠다.


- [Jekyll 로컬 서버 실행하는 법]({% post_url Tutorials/Github Pages/2025-10-02-initialize-github-pages %}#6-jekyll-서버-시작)
- 폴더 이름에 따라 자동으로 카테고리 지정하기
- media 폴더 자동으로 생성/삭제하기
- media subpath 자동으로 인식하기
- git log를 이용하여 마지막 수정시간 자동으로 입력하기
- Obsidian 이미지 형식 자동으로 인식하기