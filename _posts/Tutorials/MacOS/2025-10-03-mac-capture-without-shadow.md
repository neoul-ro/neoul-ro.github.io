---
layout: post
title: "[Mac OS] 맥북 스크린샷 여백 없애기"
date: 2025-10-03 04:44 +0900
author:
tags:
- MacOS
- 맥북 스크린샷 여백
---

## 맥북 스크린샷 여백 없애기

MacOS에서 `⌘ + ⇧ + 5`로 창 지정 스크린 샷을 할 때 아래처럼 여백(shadow)이 생기게 된다.

![shadow](image.png)

아래 명령어를 통해 기본 스크린캡쳐 앱의 설정을 바꿀 수 있다.

~~~bash
defaults write com.apple.screencapture disable-shadow -bool true ; 
killall SystemUIServer
~~~

설정 후 캡쳐하면 다음과 같이 여백이 없이 캡쳐된다.

![alt text](image 1.png)

