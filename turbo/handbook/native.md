---
permalink: /handbook/native.html
description: "Turbo Native lets your majestic monolith form the center of your native iOS and Android apps, with seamless transitions between web and native sections."
---

[DHHの許諾](https://github.com/hotwired/turbo-site/issues/96)のもと、[公式のTurboHandbook](https://turbo.hotwired.dev/handbook/introduction)を[オリジナル](https://github.com/hotwired/turbo-site/commit/59943d962b37a02c1dcb68ebaa1057f713a45975)として、翻訳をしています。
このサイトの全ての文責は、[株式会社万葉](https://everyleaf.com/)にあります。

# Go Native on iOS & Android
# iOS と Android をネイティブにやる

Turbo Native for iOS provides the tooling to wrap your Turbo-enabled web app in a native iOS shell. It manages a single WKWebView instance across multiple view controllers, giving you native navigation UI with all the client-side performance benefits of Turbo. See <a href="https://github.com/hotwired/turbo-ios">Turbo Native: iOS</a> for more details.

iOS のための Turbo ネイティブは、 Turbo 対応の Web アプリケーションをネイティブな iOS のシェルにラップするためのツールを提供します。そのツールは複数の View Controller にまたがった単一の WKWebView インスタンス(※1)を管理し、 Turbo によって最適化されたクライアントサイドのパフォーマンスを備えたネイティブなナビゲーション UI を提供します。詳細は <a href="https://github.com/hotwired/turbo-ios">Turbo Native: iOS</a> をご覧ください。


Turbo Native for Android provides the same kind of tooling, managing a single WebView instance across multiple Fragment destinations. See <a href="https://github.com/hotwired/turbo-android">Turbo Native: Android</a> for more details.

Android のための Turbo ネイティブも、複数のデスティネーションにまたがった単一の WebView のインスタンスを管理するための同様のツールを提供します。詳細は <a href="https://github.com/hotwired/turbo-android">Turbo Native: Android</a> をご覧ください。

The best way to see what's possible with the native adapters is to setup the demo native application. We have one [for iOS](https://github.com/hotwired/turbo-ios/blob/main/Demo/README.md) and [for Android](https://github.com/hotwired/turbo-android/blob/main/demo/README.md). You can open the code in your native environments and follow along to explore all the features.

ネイティブアダプタで何ができるのか調べるのに最も良い方法は、デモのネイティブアプリケーションを設定してみることです。 [iOS 用](https://github.com/hotwired/turbo-ios/blob/main/Demo/README.md)と [Android 用](https://github.com/hotwired/turbo-android/blob/main/demo/README.md)を用意しています。手元のネイティブ環境でコードを開いてみて、すべての機能を試してみてください。

-----
※1: [WKWebView](https://developer.apple.com/documentation/webkit/wkwebview) は iOS アプリから WEB ページを見るために利用されるクラスです。