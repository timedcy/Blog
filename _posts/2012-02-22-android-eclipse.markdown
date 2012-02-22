---
layout: post
title: Android ADT & eclipse 3.7
categories:
- Android
---
写文档的人总是不靠谱。按照[Android SDK的文档](http://developer.android.com/sdk/installing.html)，是无法在eclipse 3.7中装上ADT的，会遇到这样的错误：

> Cannot complete the install because one or more required items could not be found.
> Software being installed: Android Development Tools 15.0.0.v201110251216-213216 (com.android.ide.eclipse.adt.feature.group 15.0.0.v201110251216-213216)
> Missing requirement: Android Development Tools 15.0.0.v201110251216-213216 (com.android.ide.eclipse.adt.feature.group 15.0.0.v201110251216-213216) requires ‘org.eclipse.wst.sse.core 0.0.0′ but it could not be found

要解决这个问题，需要在 *Help -> Install New Software -> Available Software Sites*中加入<code>http://download.eclipse.org/releases/indigo</code>，这样安装时就不会找不到包了。
