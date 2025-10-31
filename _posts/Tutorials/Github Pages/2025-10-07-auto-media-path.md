---
layout: post
title: 6. Hook으로 미디어 파일 경로 설정 자동화하기
date: 2025-10-07 04:23 +0900
author: blu
tags:
- Github
- Github Pages
- Jekyll
---

## 1. Hook으로 미디어 파일 경로 설정 자동화하기

front matter에서 이미지나 동영상의 경로(폴더)를 `media_subpath`로 
하지만 새 글을 쓸 때마다 front matter에 `media_subpath`를 일일이 적어 주는 것은 꽤 번거롭다.  
[5편]({% post_url Tutorials/Github Pages/2025-10-05-auto-categories %})에서 폴더 구조만으로 카테고리를 자동화했듯이, 이미지가 들어갈 폴더도 Hook으로 채우면 손이 훨씬 덜 간다.

- 카테고리를 기준으로 media 폴더 구조를 재사용할 수 있다.
- 글 제목을 바꿔도 slug가 유지되는 한 Hook가 동일한 경로를 만들어 준다.
- front matter에서 `media_subpath`를 비워 둬도 안전하다.

## 2. `media_subpath`가 사용되는 위치

`refactor-content.html`에서는 포스트 본문에 있는 `![image](foo.png)` 같은 마크다운을 읽어, `media_subpath`가 있으면 `/media/.../foo.png` 형태로 바꿔 준다.

<!-- 동영상(`embed/video.html`), 오디오(`embed/audio.html`), `<head>`에 들어가는 Open Graph 이미지 등도 모두 동일한 로직을 따른다. -->

즉 `media_subpath`만 잘 채워져 있으면, 마크다운에서는 파일명만 넣어도 된다.

## 3. 폴더 규칙 정하기

나는 이미 포스트를 `_posts/<대분류>/<소분류>/<slug>.md` 구조로 저장하고 있다.  
이미지는 같은 구조의 `/media/<대분류>/<소분류>/<slug>/` 아래에 두면 찾기 쉽다.

1. `_posts/Tutorials/Github Pages/2025-10-07-auto-media-path.md`
2. `/media/Tutorials/Github Pages/2025-10-07-auto-media-path/이미지.png`

Hook는 위 규칙을 그대로 따라 `categories` 배열과 파일명을 조합해 `media_subpath` 값을 만든다.

## 4. `_plugins/auto-media-subpath.rb` 분석하기

~~~ruby
# _plugins/auto_media_subpath.rb
Jekyll::Hooks.register :posts, :pre_render do |post, payload|
  cats = (post.data['categories'] || []).join("/")
  slug = post.basename_without_ext
  subpath = "/media/#{cats}/#{slug}"
  post.data['media_subpath'] = subpath
end
~~~
{: file="_plugins/auto-media-subpath.rb" }

핵심은 세 줄이다.

- **카테고리 연결**: `post.data['categories']`가 배열이면 `/`로 합쳐 `Tutorials/Github Pages`처럼 만든다.
- **slug 추출**: `post.basename_without_ext`는 파일명에서 확장자만 뺀 값으로, 포스트 URL의 slug와 동일하다.
- **front matter 주입**: `post.data['media_subpath']`에 `/media/...` 값을 넣으면 Liquid에서 바로 사용할 수 있다.

Hook 시점은 `:pre_render`로 잡았다.  
이는 마크다운이 HTML로 변환되기 직전이므로, 모든 include가 실행되기 전에 `media_subpath`가 준비된다.

## 5. 작성 흐름과 동작 확인

1. 새 글을 만들 때 `media_subpath`를 비워 둔다. `jekyll_compose` 템플릿에서도 해당 항목을 제거해 두면 편하다.
2. 이미지 파일은 원하는 위치에 저장하되, 최종적으로는 `/media/<categories>/<slug>/`로 옮겨 놓는다.
3. `bundle exec jekyll serve`를 실행해 포스트를 열면, `![diagram](architecture.png)`처럼 파일명만 적어도 자동으로 `/media/.../architecture.png` 경로로 렌더링된다.
4. 경로가 바뀌었는지 확인하고 싶다면 개발자 도구나 페이지 소스에서 `<img src="...">` 값을 보면 된다.

Hook는 front matter에 직접 입력한 값을 덮어쓴다.  
특정 글에서만 다른 경로를 쓰고 싶다면 `categories`를 조절하거나, Hook 내부에서 예외 처리를 넣어도 좋다.

- **이미지 폴더를 자동으로 만들어 줄 수 있나요?** 필요하다면 Ruby의 `FileUtils.mkdir_p`를 이용해 폴더를 생성하도록 Hook를 확장할 수 있다. 예시로 `_plugins/auto-media-folder.rb`{: .filepath}를 별도로 작성해 두면 media 폴더 생성과 청소까지 자동화할 수 있다.

앞선 글에서 다룬 카테고리 자동화와 함께 쓰면, 포스트를 만들고 이미지만 올려도 경로가 모두 정리된다.  
이제는 이미지 경로 때문에 front matter를 만질 일이 거의 없다.
다음에는 포스트를 생성하면 `/media/<categories>/<slug>/` 폴더를 만들어주는 방법을 알아보도록 하겠다.
