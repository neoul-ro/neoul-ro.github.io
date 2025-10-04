---
layout: post
title: 4. Hook으로 마지막 수정 날짜 자동으로 기록하기
date: 2025-10-05 06:00 +0900
author: blu
tags:
- Github
- Github Pages
- Jekyll
---

## 1. 최근 수정 날짜를 자동으로 넣고 싶은 이유

포스트를 작성하다 보면 여러 이유로 포스트를 수정하게 된다.  
대부분의 Jekyll 블로그는 front-matter에 `last_modified_at`을 입력하면 마지막 수정 날짜를 지정할 수 있다.  
하지만 수정할 때마다 `last_modified_at`을 수동으로 입력하는 것은 꽤 번거로운 일이다.    
이번 글에서는 Hook을 이용하여 Git 기록으로 마지막 수정 날짜를 주입하는 방법을 정리했다.

- commit 기록을 이용하여 마지막 수정 시간이 자동으로 표시된다.
- Jekyll 빌드 단계에서 처리돼 추가 명령이 필요 없다.

사용하는 Chirpy 테마에서는 기본적으로 마지막 수정 날짜를 자동으로 기록하는 플러그인이 작성되어 있다.  
오늘은 이 코드을 보며 Jekyll Hook이 할 수 있는 일을 알아보도록 하자.

## 2. Jekyll Hook 동작 방식 이해하기

Chirpy 테마에는 기본으로 `_plugins/posts-lastmod-hook.rb`{: .filepath} 파일이 들어 있다.  
Jekyll은 [공식 Hook API](https://jekyllrb.com/docs/plugins/hooks/)를 제공하며, 특정 시점에 Ruby 코드를 실행할 수 있다.

- `:posts`는 포스트 타입이 초기화될 때마다 호출된다.
- `:post_init` 타이밍은 Markdown을 읽어 front matter를 구성한 직후다.
- Hook 내부에서 `post.data`에 값을 넣으면, Liquid 템플릿에서 바로 활용할 수 있다.

Hook가 제대로 실행되려면 두 가지 조건을 만족해야 한다.

1. 사이트가 Git repository여야 한다. Git 커밋 기록이 없다면 마지막 수정일을 구할 수 없다.
2. `bundle exec jekyll serve`나 `bundle exec jekyll build`를 실행할 때 `_plugins` 폴더가 로드되어야 한다. Chirpy에서는 기본 설정이므로 추가 설정은 필요 없다.
   - Github Pages의 경우 TODO

## 3. `_plugins/posts-lastmod-hook.rb` 살펴보기

~~~ruby
#!/usr/bin/env ruby
#
# Check for changed posts

Jekyll::Hooks.register :posts, :post_init do |post|
  commit_num = `git rev-list --count HEAD "#{ post.path }"`

  if commit_num.to_i > 1
    lastmod_date = `git log -1 --pretty="%ad" --date=iso "#{ post.path }"`
    post.data['last_modified_at'] = lastmod_date
  end
end
~~~
{: file="_plugins/posts-lastmod-hook.rb" }

코드는 단순하지만 필요한 요소가 모두 들어 있다.

- `git rev-list --count HEAD "<path>"`는 해당 파일이 커밋된 횟수를 반환한다. 초안 단계처럼 첫 커밋 이전이라면 0 또는 1이므로 조건문을 건너뛴다.
- `git log -1 --date=iso`는 마지막 커밋의 날짜를 ISO8601 형태로 전달한다. Chirpy는 이 문자열을 Liquid에서 그대로 렌더링하고, RSS나 sitemap에도 반영한다.
- `post.data['last_modified_at']`에 값을 대입하면 front matter에 직접 적은 것과 동일하게 취급된다.

## 4. 결과

다음과 같이 마지막 수정 날짜가 표시되고, 마우스를 올리면 시간까지 표시되게 된다.

![result](image.png){: width="60%"}

다음에는 Hook 플러그인을 이용하여 categories, subpath 등을 자동 설정하는 방법을 알아보도록 하겠다.