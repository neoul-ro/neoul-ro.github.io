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

## 1. Github Pages 댓글란

여러 Github Pages로 호스팅되는 사이트를 보면 아래처럼 댓글란이 있는 것을 확인할 수 있다.
![comments](image3.png)

내가 선택한 테마나 대부분의 Jekyll 테마에서는 `disqus`, `utterances`, `giscuc` 등의 댓글 관리 앱을 사용할 수 있도록 설정이 되어 있다.

나는 그 중에서 `utterances`를 이용해 댓글란을 설정해보았다.

## 2. Utterances 란?

`utterances`는 Github repository의 issue를 통해 댓글을 관리하는 Github용 앱이다.

댓글을 작성하기 위해선 Github에 로그인을 해야하고, 댓글을 작성하면 설정한 repository의 issue로 등록되어 관리가 가능한 도구이다.

## 3. Utterances 설치하기

먼저 [Utterances Github app](https://github.com/apps/utterances)을 설치한다.

![utterances](image.png)

Utterances를 사용할 repository를 지정해준다. 나는 comments라는 repo를 따로 만들어서 그 곳에서 댓글을 관리하기로 했다.  

{: .text-center}
![install utterances](image2.png){: width="70%"}

설정 후 나오는 configuration를 통해 내 사이트에 추가할 수 있는데, 대부분의 Jekyll 테마에서는 `_config.yml`{:.filepath}에서 설정하도록 되어있다.

## 4. `_config.yml`{:.filepath} 수정하기

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

## 5. 결과

설정 후에 deploy한 다음 댓글을 작성하면 `neoul-ro/comments` repository에 다음처럼 issue에 해당 내용이 작성되는 것을 확인할 수 있었다.

![issue](image4.png)



다음에는 명령어로 포스트 md 파일 자동 생성하는 방법을 알아보도록 하겠다.