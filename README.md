# go
ShellScript that compile C++ (or C) source file and execute executable file 

## LICENCE
No Rights Reserved

## 概要

C++ (or C)のプログラムファイルをコンパイルして、生成された実行可能ファイルを実行するシェルスクリプトです。

## 使い方

$ g++ hello.cpp -o hello
$ ./hello
Hello, World!

の作業を

$ go hello
Hello, World!

で済ませてしまうコマンドになります。
go.sh, go1.sh, go2.shのうち、好きなものを名前を変更してパスが通ったディレクトリにコピーしてください。
自分好みに機能を拡張するとより便利になると思います。

## File

* go.sh
作成者が普段使っているものです。作成者好みにgo2.shを拡張してあります。

* go1.sh
最もシンプルで最小限の目的を満たすことができるシェルスクリプトです。

* go2.sh
go1.shを少し拡張してオプションをつけることができます。
