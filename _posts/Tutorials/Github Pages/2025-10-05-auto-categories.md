---
layout: post
title: 5. Hook으로 카테고리 설정 자동화하기
date: 2025-10-05 06:31 +0900
author: blu
tags:
- Github
- Github Pages
- Jekyll
---

## 1. 카테고리를 반복 입력하지 않으려면?

글을 쓰다 보면 front matter에 `categories:`를 매번 채우는 일이 가장 번거롭다.  
[3편]({% post_url Tutorials/Github Pages/2025-10-04-post-a-post %})에서 `jekyll-compose`로 새 글을 만들도록 자동화했지만, 여전히 카테고리는 수동으로 입력해야 했다.  
나는 포스트를 할 때 경로를 이미 `/_posts/대분류/소분류/slug.md` 형태로 정리되어 있기 때문에, 경로를 읽어서 카테고리를 채우면 더 이상 손댈 일이 없다.

- 폴더 구조만 맞춰두면 front matter는 비워도 된다.
- Git Hook이 아니라 Jekyll Hook이기 때문에 빌드 단계에서 자동으로 반영된다.

## 2. `categories`가 분류하는 법

`categories`는 배열 형태로 작성하면 순서대로 대분류 → 소분류로 매핑된다.

```markdown
categories:
  - Tutorials
  - Github Pages
```

위와 같이 두 개의 값이 있다면 카테고리는 `Tutorials > Github Pages`가 된다.  
나는 이미 포스트를 작성할 때 `_posts/Tutorials/Github Pages/` 폴더 안에 작성하기 때문에 굳이 `categories`를 따로 설정할 필요가 없었다. (이게 작성하는 입장에서도 분류하기 쉽다.)

![folder](image.png){: width="30%"}

## 3. Hook으로 경로에서 카테고리 추출하기

`_plugins/auto-categories.rb`{: .filepath}를 작성하여 이를 자동화해주었다.  
파일은 포스트가 초기화될 때 경로를 읽어 카테고리를 채워준다.  
`Ruby` 언어를 모르더라도 ChatGPT로 한두 번 디버깅하면 잘 동작한다.

~~~ruby
# Automatically derive categories from each post's directory structure when
# the front matter leaves them blank.
Jekyll::Hooks.register :posts, :post_init do |post|
  categories = post.data['categories']
  next unless categories.nil? || (categories.respond_to?(:empty?) && categories.empty?)

  relative_path = post.relative_path
  next unless relative_path

  segments = File.dirname(relative_path).split(File::SEPARATOR)
  segments.shift if segments.first == '_posts'
  segments.reject! { |segment| segment.nil? || segment.empty? || segment == '.' }
  next if segments.empty?

  post.data['categories'] = segments
end
~~~
{: file="_plugins/auto-categories.rb" }

핵심 포인트는 다음과 같다.

- **수동 설정 가능**: front matter에 이미 `categories`를 입력해두었다면 Hook는 아무 것도 하지 않는다.
- `post.relative_path`를 이용하면 `_posts/Tutorials/Github Pages/파일명.md` 형태의 경로를 얻을 수 있다.
- 결과적으로 `post.data['categories']`에 값이 들어가 Liquid 템플릿에서 바로 사용할 수 있다.

## 4. `_config.yml`{: .filepath} 파일 수정하기

이제 front matter에서 `categories`를 작성할 필요가 없어졌다.  
`_config.yml`{: .filepath}에서 `jekyll_compose`로 포스트를 생성할 때, `categories` 부분은 기본으로 설정되지 않도록 변경해주어야 한다.

~~~yaml
jekyll_compose:
  # Prepopulate new posts generated via `jekyll post`.
  default_front_matter:
    posts:
      layout: post
      author: blu
      # 이 부분은 지워주자
      # categories:
      #   - ~
      tags:
        - ~
      comments: true
      media_subpath: ~
~~~
{: file="_config.yml" }

이제 `bundle exec jekyll post "새 글"`을 실행하면 `categories:` 항목이 비어 있는 상태로 생성된다.  Hook가 경로를 읽어 자동으로 채울 것이므로 더 이상 템플릿에 자리 표시자를 넣지 않아도 된다.

## 5. 동작 확인 절차

1. `_posts/Tutorials/Github Pages/`처럼 원하는 경로에 새 포스트를 만들고 저장한다.
2. front matter에서 `categories:`를 제거했거나 빈 배열인 상태인지 확인한다.
3. `bundle exec jekyll serve`로 로컬 서버를 실행한다.
4. 브라우저에서 해당 포스트를 열면 카테고리가 정상적으로 표시된다.

카테고리가 바뀌었다면 경로를 옮긴 뒤 다시 빌드하면 Hook가 새 경로 기준으로 값을 갱신해 준다.

## 6. 자주 겪는 문제와 해결 방법

- **폴더 이름 주의점**: Jekyll은 자동으로 공백을 하이픈으로 변환하지만, 경로와 카테고리 배열이 달라질 수 있다. 폴더 이름은 영문 소문자와 하이픈을 권장한다. (나는 무시하고 작성하였지만 잘 동작하기는 했다.)
- **카테고리를 수동 지정**: front matter에 값을 명시하면 Hook가 건너뛰므로 기존 방식대로 직접 입력할 수 있다.
- **초안(Draft)의 경우**: `_drafts`{: .filepath} 폴더는 카테고리를 파악할 폴더 구조가 없기 때문에 Hook가 빈 배열을 그대로 둔다. 게시 전에 `_posts/대분류/소분류/` 경로로 옮기면 된다.

## 7. 다음에 할 일

카테고리 외에도 이미지 경로나 첨부 파일 위치 등 반복되는 필드를 Hook로 채울 수 있다.  
다음 글에서는 media 경로를 자동으로 맞춰주는 Hook를 살펴볼 예정이다.

