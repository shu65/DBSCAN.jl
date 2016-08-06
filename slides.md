class: center, middle

# Juliaによる<br>解析アルゴリズムの実装

WACODE 夏期講習 2016年8月6日

佐藤建太 (@bicycle1885)

---

## アジェンダ

* 自己紹介
* Julia言語の紹介
* Juliaの基本
* Juliaのパッケージング

---

## 自己紹介

* 佐藤建太
* GitHub/Twitter: @bicycle1885
* 東大農学部の院生 (バイオインフォマティクス)
* Julia歴はもうすぐ3年くらい (Python/Rは3-4年くらい)

<img src="images/bicycle1885.jpg" style="height: 200px;">

---

## Juliaとの関わり

* BioJuliaプロジェクト
    * Juliaでバイオインフォマティクスの基礎ツールを作るグループ
    * <https://github.com/BioJulia/Bio.jl>
* JuliaTokyo
    * 東京周辺のJulia言語コミュニティ (次回ミートアップは9月3日)
    * <http://julia.tokyo/>

<figure>
    <img src="images/BioJl_Design_1.png" style="width: 250px; float: left;">
    <img src="images/juliatokyo.png" style="width: 250px; float: right;">
</figure>

---

## Juliaとの関わり

* JuliaCon at MITに2015と2016に参加
    * 2015: Julia Summer of Code Student <http://julialang.org/blog/2015/10/biojulia-sequence-analysis>
    * 2016: BioJuliaプロジェクトへの支援で <http://julialang.org/blog/2016/04/biojulia2016>
* 10個くらいJuliaのパッケージを作ってる
* ほかJulia本体や関連パッケージでバグを見つけたらせっせとパッチを送っている

---
class: middle, center

<img src="images/640px-Merkava4m-Windbreaker-0036a.jpg" style="height: 550px;">
.note[By IDF Spokesperson Unit, modification by User:MathKnight - File:Armored Corps Operate Near the Gaza Border (14743522533).jpg, CC BY 2.0, https://commons.wikimedia.org/w/index.php?curid=34361430]

<!--
<img src="images/Flickr_-_Israel_Defense_Forces_-_188th_Brigade_Training_Day,_March_2008.jpg" style="height: 550px;">

.note[By Neil Cohen, Israel Defense Forces (188th Brigade Training Day, March
2008) [CC BY 2.0 (http://creativecommons.org/licenses/by/2.0)], via Wikimedia
Commons]
-->

---
class: middle, center

<img src="images/T-28-1.jpg" style="width: 750px;">

---
class: middle, center

<img src="images/Karl6.jpg" style="width: 750px;">

---
class: middle, center

<img src="images/640px-Captured_L3_and_L3_cc_tankettes.jpg" style="width: 750px;">

---
class: middle, center

<img src="images/640px-Type_97_light_armored_car_Te-Ke_02.jpg" style="width: 750px;">

---
class: middle, center

<figure>
    <img src="images/T-28-1.jpg" style="float: left; height: 170px;">
    <img src="images/Karl6.jpg" style="float: right; height: 170px;">
    <img src="images/640px-Merkava4m-Windbreaker-0036a.jpg" style="width: 400px;">
    <img src="images/640px-Captured_L3_and_L3_cc_tankettes.jpg" style="float: left; height: 170px;">
    <img src="images/640px-Type_97_light_armored_car_Te-Ke_02.jpg" style="float: right; height: 170px;">
</figure>

---

## Julia言語とは

> Juliaは**高レベル**・**高パフォーマンス**な**技術計算**のための**動的**プログラミング言語で、他の技術計算環境のユーザーに**馴染みのある文法**を備えている。

<http://julialang.org/>

--
* **高レベル** - 型システム・GC・例外機構・ジェネリクスなど

--
* **高パフォーマンス** - 型推論とJust-in-time (JIT) コンパイル

--
* **技術計算** - 豊富な数値型・多次元配列・線形代数ライブラリ

--
* **動的** - スクリプト言語のような処理系・対話的実行

--
* **馴染みのある文法** - MATLABやLuaに似た文法

---

## Julia言語とは

> Juliaは**高レベル**・**高パフォーマンス**な**技術計算**のための**動的**プログラミング言語で、他の技術計算環境のユーザーに**馴染みのある文法**を備えている。

<http://julialang.org/>

<p style="font-size: 45px; text-align: center; margin-top: 100px;">Juliaは科学・技術計算の<strong>主力言語</strong></p>

---

## Juliaを作った動機

"Why We Created Julia"
> In short, because we are greedy.

<http://julialang.org/blog/2012/02/why-we-created-julia>


--
つまり、**何でもできる言語**が欲しかった


--
Stefan Karpinski, Jeff Bezanson, Viral Shah, Alan Edelman

<figure>
    <img src="images/stefan.jpg" style="width: 150px; margin-left: 15px; float: left;">
    <img src="images/jeff.jpg" style="width: 150px; margin-left: 15px; float: left;">
    <img src="images/viral.jpg" style="width: 150px; margin-left: 15px; float: left;">
    <img src="images/alan.jpg" style="width: 150px; margin-left: 15px; float: left;">
</figure>

---

## Juliaのコード

.font75[
```julia
quicksort(xs) = quicksort!(copy(xs))
quicksort!(xs) = quicksort!(xs, 1, length(xs))

function quicksort!(xs, lo, hi)
    if lo < hi
        p = partition(xs, lo, hi)
        quicksort!(xs, lo, p - 1)
        quicksort!(xs, p + 1, hi)
    end
    return xs
end

function partition(xs, lo, hi)
    pivot = div(lo + hi, 2)
    pvalue = xs[pivot]
    xs[pivot], xs[hi] = xs[hi], xs[pivot]
    j = lo
    @inbounds for i in lo:hi-1
        if xs[i] ≤ pvalue
            xs[i], xs[j] = xs[j], xs[i]
            j += 1
        end
    end
    xs[j], xs[hi] = xs[hi], xs[j]
    return j
end
```
]

---

## パフォーマンス比較 (C言語 = 1.0)

![](images/benchmarks_table.png)

* コンパイル言語に匹敵する実行速度
* PythonやRと比べると5-500倍ほど

---
layout: true

## Juliaのパフォーマンスの秘密

---

実行時の**型推論**とコンパイル

```julia
julia> @code_typed 1 + 1
LambdaInfo for +(::Int64, ::Int64)
:(begin
        return (Base.box)($(Expr(:static_parameter, 1)),(Base.add_int)(x,y))
    end::Int64)
```

---

実行時の型推論と**コンパイル**

```julia
julia> @code_native 1 + 1
        .section        __TEXT,__text,regular,pure_instructions
Filename: int.jl
        pushq   %rbp
        movq    %rsp, %rbp
Source line: 32
        leaq    (%rdi,%rsi), %rax
        popq    %rbp
        retq
Source line: 32
        nopw    (%rax,%rax)
```

---
layout: false

## 汎用言語としての機能

* 型システム
* ガーベッジコレクション
* 例外
* 多重ディスパッチ
* ジェネリクス
* モジュール
* マクロ
* 正規表現
* データ構造 (辞書・集合など)
* マルチスレッド (v0.5から)

---

## 技術計算のための機能

* 数値型
    * 8-128 bitsの符号つき・符号なし整数
    * 16-64 bitsの浮動小数点数
    * 任意精度の整数・浮動小数点数
* 多次元配列
    * ベクトル (1次元配列), 行列 (2次元配列), ...
* ライブラリ
    * 行列の演算 (積・行列分解など)
    * FFT・擬似乱数生成器・疎行列など

---

## C言語へのインターフェース

ラッパー無しでC言語の関数を呼び出し可能

```julia
julia> ccall((:getenv, "libc"), Cstring, (Cstring,), "HOME")
Cstring(0x00007fff5854ba92)
julia> unsafe_string(ans)
"/Users/kenta"
```

* 既存のプログラム資産がすぐに利用可能
* C++, Python, Rなど他の言語へのインターフェースも
    * <https://github.com/Keno/Cxx.jl>
    * <https://github.com/stevengj/PyCall.jl>
    * <https://github.com/JuliaStats/RCall.jl>

---

## 動的実行環境

<figure>
    <img src="images/REPL.png" style="width: 350px; float: left;">
    <img src="images/Jupyter.png" style="width: 350px; float: right;">
</figure>

---

## 開発環境

* 各種エディターのプラグイン
    * Atom: <https://atom.io/packages/language-julia>
    * Vim/NeoVim: <https://github.com/JuliaLang/julia-vim>
    * Emacs: <https://github.com/JuliaLang/julia-emacs>
    * Jupyter Notebook: <https://github.com/JuliaLang/IJulia.jl>
* その他のツール
    * 統合開発環境
        * Atom: <http://junolab.org/>
        * Eclipse: <https://github.com/JuliaComputing/JuliaDT>
    * デバッガ: <https://github.com/Keno/Gallium.jl>

---

## Juliaのバージョン

* 最新リリース版はv0.4系 (0.4.6)
    * 現在v0.5のrelease candidateが出ている
    * **v1.0は2017年**に予定されている
* Julia本体もパッケージもすべて**Semantic Versioning**準拠
    * バージョン = `<MAJOR>.<MINOR>.<PATCH>`
        1. `MAJOR`: 互換性のないAPIの変更
        2. `MINOR`: 互換性のある機能追加
        3. `PATCH`: 互換性のあるバグ修正
    * 詳しくは: <http://semver.org/>

---

## Juliaのコミュニティ

* **研究者**が中心的役割
    * MITのラボでJeff Bezanson氏が研究としてJuliaを開発
    * 主要な開発者はアメリカの大学に集中している
    * 他にもインドが開発の中心地らしい
* **アカデミック**のユーザが多い
    * JuliaStats: 統計処理のグループ
    * JuliaOpt: 最適化のグループ
    * BioJulia: 生物学のグループ
    * QuantEcon: 計量経済学のグループ
    * 他多数 <http://julialang.org/community/>

---

## 注意!

* 今日使うJuliaは**v0.5 RC1**
    * 資料はv0.5向けに作成
* v0.4 => v0.5はかなり多くの変更があった
    * v0.4との差分にも言及
    * v0.5の変更に追従していないパッケージがまだたくさん
* deprecated warningsがたくさん出るので
    * パッケージは最新のものにする
    * 起動時に--depwarn=noを推奨

---
class: center, middle

# Juliaの**基本**

---

## 基本文法 - リテラル

```julia
# 真偽値                    # 文字
true                        'B'
false                       '字'
# 整数                      # 文字列
42                          "string"
12_000_000                  "文字列"
0x9f
0x1234ABCD
# 浮動小数点数              # 配列
3.14                        [1, 2, 3]
6.022e23                    [1 2 3
                             4 5 6]
```

Juliaの1次元配列は、 **縦ベクトル**であることに注意

---

## 基本文法 - 変数

```julia
x = 123
y = 3.14
# 複数
i = j = 0
x, y, z = 10, 1.23, "foo"
# マルチバイト文字
η, Θ, ζ = 0.01, 10, 333
```

エディターのJuliaプラグインやREPLは**LaTeX**によるマルチバイト文字での入力補助をサポート (例: `\eta<TAB>` ➠ `η`)

---

## 基本文法 - 演算

```julia
2 + 3  # 和
2 - 3  # 差
2 * 3  # 積
div(2, 3)  # 商
2 / 3  # 割り算
2 % 3  # 剰余
2 ^ 3  # 指数
```

x / yは**浮動小数点数** (例: 2 / 3 = 0.6666...) になるので注意

---

## 基本文法 - if/elseif/else

```julia
x = 3.14
if x > 0
    println("positive")
elseif x < 0
    println("negative")
else
    println("zero")
end
# これはダメ
if x
    println("non zero")
end
```

条件部分は**真偽値**でなければいけない (例: `if 0`はエラー)

---

## 基本文法 - for/while

Pythonと異なり、範囲の右側の値も含む

```julia
for i in 1:10
    println(i)
end
i = 1
while i <= 10
    println(i)
end
```

* `break`: ループからの脱出
* `continue`: ループの残り部分をスキップ

---

## 基本文法 - 関数定義

```julia
# function ... end (ユークリッドの互除法)
function gcd(a, b)
    while b != 0
        t = b
        b = mod(a, b)
        a = t
    end  
    return a
end

# 1行定義 (2引数の乱択)
choice(x, y) = rand() > 0.5 ? x : y
```

* `function f(...) ... end と f(...) = ...` の2通りの方法
* `return`は**省略可**

---

## 基本文法 - 無名関数

```julia
# xのインクリメント
x -> x + 1

# map, filter, reduceなどの関数は第一引数に関数を取れる
map(x -> x + 1, [1, 4, 8])

# 第一引数の関数は`do`構文で後置できる
map([1, 4, 8]) do x
    return x + 1
end

# 例: ファイルを開いて必ず閉じるイディオム
open("data.txt") do input
    # do something
end
```

---

## 基本文法 - 型

```julia
type Alien
    name::String
    age::Int
    aerobic::Bool
end
```

```julia
julia> x = Alien("Lisp Monster", 10_000, false)
Alien("Lisp Monster",10000,false)

julia> x.name
"Lisp Monster"

julia> x.age += 1
10001
```

型宣言(`::String`など)は任意だが、あれば**型推論**が動いて速い

---

## 基本文法 - 例外

投げ方:
```julia
error("oh no")
throw(ArgumentError("the argument is wrong"))
```

捕まえ方:
```julia
try
    x = [1, 2, 3]
    x[4]  # error!
catch ex
    println(ex)
end
```

`catch ... end`の間では`rethrow()`で例外を再度投げることができる

---

## 基本文法 - ファイルIO

```julia
input = open("data.txt")
for line in eachline(input)
    # do something
end
close(input)
```

自動的にファイルを閉じる書き方:
```julia
open("data.txt") do input
    for line in eachline(input)
        # do something
    end
end
```

`open`のように第1引数に関数をとる関数は`do ... end`で引数の関数を後置できる

---

## 基本文法 - 内包表記

```julia
# ベクトル
[2^n for n in 1:10]

[2^n for n in 1:10 if iseven(n)]  # v0.5

# 辞書
Dict(n => 2^n for n in 1:10)  # v0.5
```

`(<expr> for <variable> in <iterator>)`は`Generator`というオブジェクトを作る

---

## 基本文法 - マクロ

```julia
x = 3
@show x
@assert x > 0
```

プログラムの**書き換え**機能

* `@time`: ベンチマーク
* `@profile`: プロファイル
* `@inbounds`:
* `@inline`: 関数のインライン化

---

## 基本文法 - モジュール

```julia
module Foo

export sayfoo

function sayfoo()
    println("foo!")
end

end
```

```julia
using Foo   # sayfoo()
import Foo  # Foo.sayfoo()
```

`using`は`export`された名前を現在の名前空間で使えるようにする

---

## 基本仕様 - 型システム

Juliaの型は**抽象(abstract)型**と**具体(concrete)型**に分けられる

* 抽象型: インスタンス化できないが、他の型の基本型(supertype)になれる
* 具体型: インスタンス化できるが、他の型の基本型になれない

具体例:
* 抽象型`Unsigned`は、`UInt8`や`UInt64`などの具体型の基本型
* 抽象型`AbstractVector{Int}`は、`Vector{Int}`や`UnitRange{Int}`などの具体型の基本型

---

## 基本仕様 - 型システム

最も上位の型は`Any`型

```julia
julia> Int <: Signed <: Integer <: Real <: Number <: Any
true
```

データ型全体は、内部ノードが抽象型、葉が具体型の木構造のグラフ

.note[若干ウソ e.g`. Any <: Any`]

```julia
julia> subtypes(AbstractFloat)
4-element Array{Any,1}:
 BigFloat
 Float16
 Float32
 Float64
julia> supertype(Float64)
AbstractFloat
```

---

## 基本仕様 - 型システム

<img src="images/typetree.svg" style="height: 600px;">

---

## 基本仕様 - 多重ディスパッチ

**引数の型**に応じて実行されるメソッドが決まる機能

```julia
function foo(x::Int)
    println("Int")
end

function foo(x::Int, y::Int)
    println("Int, Int")
end

function foo(x::Int, y::Float64)
    println("Int, Float64")
end

foo(1)       #> Int
foo(1, 2)    #> Int, Int
foo(1, 2.0)  #> Int, Float64
```

---

## 基本仕様 - 多重ディスパッチ

引数の型を指定しなければ`::Any`と同じ

```julia
function foo(x)  # same as x::Any
    println("Any")
end

function foo(x::Int)
    println("Int")
end

foo(1)    #> Int
foo(1.0)  #> Any
foo("1")  #> Any
```

今日はあまり詳しく説明できないが、Juliaの基礎をなす重要な機能なので修得必須

---

## データ構造 - 配列 `Array{T,n}`

`Array{T,n}`は`T`を要素の型、`n`を次元数とする配列

`Array{Int,1}`は整数`Int`の1次元配列(ベクター)
`Array{Float64,2}`は浮動小数点数`Float64`の2次元配列(行列)
`Array{T,1}`には`Vector{T}`、`Array{T,2`}には`Matrix{T}`という別名がそれぞれ付いている

```julia
# Array{Int,1} (= Vector{Int})
[1, 2, 3, 4, 5]
# Array{Float64,2} (= Matrix{Float64})
[1.0 0.0
 0.0 2.0]
```

---

## データ構造 - 配列 `Array{T,n}`

インデックスは**1**から始まる:
```julia
xs = [1, 2, 3]
xs[1]  # OK!
xs[0]  # ERROR!
xs = [1 2 3
      4 5 6]
xs[2,3]  # 2行3列目
最後の要素はendでアクセス:

xs = [1, 2, 3]
xs[end]
xs[end-1]
xs = [1 2 3
      4 5 6]
xs[1,end]  # 1行3列目
```

メソッド: `length(array), isempty(array), in(elm, array), push!(array, elm), pop!(array), append!(array1, array2), ...`

---

## データ構造 - 辞書 `Dict{K,V}`

`Dict{K,V}`は`K`をキーの型、`V`を値の型とする辞書

* `Dict{String,Int}`は文字列`String`から整数`Int`へのマッピング

```julia
julia> dict = Dict("one" => 1)
Dict{String,Int64} with 1 entry:
  "one" => 1
julia> dict["two"] = 2
2
julia> dict
Dict{String,Int64} with 2 entries:
  "two" => 2
  "one" => 1
```

メソッド: `length(dict), isempty(dict), haskey(dict, key), delete!(dict, key), ...`

---

## データ構造 - 集合 `Set{T}`

`Set{T}`は`T`を要素の型とする集合

* `Set{Int}`は整数`Int`の集合

```julia
julia> Set([1, 3, 10])
Set([10,3,1])
julia> push!(ans, 5)
Set([10,3,5,1])
```

メソッド: `length(set), isempty(set), in(elm, set), push!(set, elm), delete!(set, elm), ...`

---

## データ構造 - タプル `Tuple{T1,T2,...}`

`Tuple{T1,T2,...}`は値の組
* `Tuple{Int,String}`は整数`Int`と文字列`String`のペア(組)
* 配列型`Array`と違ってimmutableであることに注意

```julia
julia> 3, 3.14, "pi",
(3,3.14,"pi")
julia> typeof((3, 3.14, "pi"))
Tuple{Int64,Float64,String}
```

メソッド: `length(tuple), isempty(tuple), in(elm, tuple), ...`

---

## データ構造 - データフレーム `DataFrame`

外部パッケージのDataFrames.jlが`DataFrame`を提供している

```julia
using DataFrames
d = DataFrame(
    name=["Alice", "Bob", "Charlie"],
    age=[30, 24, 42])
d[:age]  # age列
d[2,:]   # 2行目
```

メソッド: `nrow(df), ncol(df), head(df), join(df1, df2, on=col), ...`

---

## データ構造 - 文字列 `String`

`String`はUnicode文字列
* 文字列は不変 (immutable)
* v0.4の`ASCIIString`と`UTF8String`がv0.5で`String`に統一された

```julia
s = "foobar"
s[1]
s[end]
s = "アブラカタブラ"
length(s)
```

メソッド: `length(str), isempty(str), lowercase(str), uppercase(str), search(str, chars), split(str, delim), join(strs, delim), ...`

---

## コード例 - TSVのパース

```julia
function parse_tsv(filepath)
    rows = Vector{Float64}[]
    open(filepath) do input
        for line in eachline(input)
            values = [
                parse(Float64, x)
                for x in split(chomp(line), '\t')]
            push!(rows, values)
        end
    end
    return hcat(rows...)'
end
```

実際には`readdlm`関数を使うべき

---

## コード例 - 最短経路探索 (Dijkstra法)

.font75[
```julia
import Base.Collections: heapify!, heappop!

function search_shortest_path(graph, source)
    dist = Float64[]
    prev = Int[]
    heap = Pair{Float64,Int}[]
    for i in 1:length(graph)
        d = i == source ? 0.0 : Inf
        push!(dist, d)
        push!(prev, 0)
        push!(heap, d => i)
    end
    heapify!(heap)

    while !isempty(heap)
        d, u = heappop!(heap)
        for v in graph[u]
            if d + 1 < dist[v]
                dist[v] = d + 1
                prev[v] = u
            end
        end
    end

    return dist, prev
end
```
]

---

## 調べ方

公式マニュアルが一番の基礎

* Juliaのマニュアル:
    * <http://docs.julialang.org/en/latest/>
* REPL
    * 名前が分かっているとき
        * `julia>`のときに?キーを押すとヘルプモード
    * キーワード検索
        * ヘルプモードでクエリを`"..."`で囲む

---

## 質問など

Juliaは変化が激しいので、現在のベストプラクティスは他のパッケージを参考にするか詳しい人に聞くのがよい

* Google Group:
    * <https://groups.google.com/forum/#!forum/julia-users>
* StackOverflow:
    * <http://stackoverflow.com/questions/tagged/julia-lang/>
* Slack (JuliaTokyo):
    * <https://juliatokyo.slack.com/>

---
class: center, middle

# Juliaのパッケージング

---

## パッケージ - 仕組み

* Juliaのパッケージは、**Gitのレポジトリ**
    * パッケージの公開先は、**GitHub**が基本
* **METADATA.jl**に登録されたパッケージが「公式パッケージ」
    * 現在~1,100パッケージほどが登録されている
    * 最近ガードが厳しめ (ドキュメント・テスト・命名法)
    * 公式パッケージ一覧: <http://pkg.julialang.org/>
    * それ以外は「野良パッケージ」

---

## パッケージ - インストール (公式)

パッケージのインストール先は`Pkg.dir()`で確認:
```julia
julia> Pkg.dir()
"/Users/kenta/.julia/v0.5"
```

`Pkg.update()`でMETADATA.jlを更新し、`Pkg.dir()`以下にパッケージ (= Gitレポジトリ) を`Pkg.add(name)`で追加する:
```julia
julia> Pkg.update()
...
julia> Pkg.add("Optim")
INFO: Cloning cache of PositiveFactorizations from https://github.com/timholy/PositiveFactorizations.jl.git
INFO: Installing DualNumbers v0.2.2
INFO: Installing Optim v0.5.0
INFO: Installing PositiveFactorizations v0.0.2
INFO: Package database updated
```

---

## パッケージ - インストール (野良)

`Pkg.clone(url)`にレポジトリのURLを渡す:
```julia
julia> Pkg.clone("git@github.com:bicycle1885/IntervalHeaps.jl.git")
INFO: Cloning IntervalHeaps from git@github.com:bicycle1885/IntervalHeaps.jl.git
ERROR: error authenticating:  ssh-agent
INFO: Computing changes...
INFO: No packages to install, update or remove
```

依存解決もしてくれるので、野良パッケージもインストールし易い。

---

## パッケージ - 開発ツール - PkgDev.jl

* PkgDev.jl - <https://github.com/JuliaLang/PkgDev.jl>
* パッケージのテンプレート生成・バージョニング・公開のためのツール群
* v0.5から外部パッケージとして標準ライブラリから分離された
    * v0.4では`PkgDev`でなく`Base.Pkg`を使ってた

---

## パッケージ - その他開発に便利なツール

* Documenter.jl - <https://github.com/JuliaDocs/Documenter.jl>
    * MarkdownによるJuliaのドキュメント生成ツール
        * Optim.jl: <http://www.juliaopt.org/Optim.jl/latest/>
        * Bio.jl: <http://biojulia.github.io/Bio.jl/latest/>
* Compat.jl - <https://github.com/JuliaLang/Compat.jl>
    * 互換性を高めるためのツール
    * 言語の新機能を取り入れつつ、後方互換性を保ちたいときに使う
* BinDeps.jl - <https://github.com/JuliaLang/BinDeps.jl>
    * バイナリ依存を記述するツール
    * apt-getやhomebrewでライブラリのインストールが必要なときに使う

---

## 実践 - DBSCAN.jlの開発

クラスタリングアルゴリズムであるDBSCANの実装・パッケージングを通して実際の手順を学ぶ

* アルゴリズムには拘らない (動けば良い)
* Juliaのコードやパッケージングの作法には拘る
    * Juliaの良いコード・速いコードの書き方を確認する
    * 良いテストの書き方・パッケージングの方法を知る

<https://github.com/wacode5/DBSCAN.jl>

---

## 実践 - 開発開始の前に

* GitHubアカウントの用意
* gitの設定
    * `git config --global user.name <name>`
    * `git config --global user.email <email>`
    * `git config --global github.user <account>`
* ssh-agentの設定
    * `ssh-add ~/.ssh/id_rsa`
* PkgDev.jlをインストール
    * `julia -e 'Pkg.update(); PKg.add("PkgDev")'`

---

## 実践 - DBSCAN

Density-based spatial clustering of applications with noise

* 事前にクラスタ数の指定が要らない・正規分布など綺麗な分布でなくてもよい・ノイズに強い
* '96の元論文は、'14 SIGKDD Test of Time Award

<img src="images/DBSCAN-Density-data.svg" style="height: 250px;">

.note[By Chire - Own work, CC BY-SA 3.0, <https://commons.wikimedia.org/w/index.php?curid=17085332>]

---

## 実践 - パッケージの生成

`PkgDev.generate(name, license)` (v0.4では`Pkg.generate`) でパッケージの雛形を作成

```julia
~/D/t/W/summer (master|…) $ julia
               _
   _       _ _(_)_     |  A fresh approach to technical computing
  (_)     | (_) (_)    |  Documentation: http://docs.julialang.org
   _ _   _| |_  __ _   |  Type "?help" for help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 0.5.0-rc0+72 (2016-07-30 15:32 UTC)
 _/ |\__'_|_|_|\__'_|  |  Commit ca355ff* (1 day old master)
|__/                   |  x86_64-apple-darwin14.5.0
julia> using PkgDev
julia> PkgDev.generate("DBSCAN", "MIT")
INFO: Initializing DBSCAN repo: /Users/kenta/.julia/v0.5/DBSCAN
INFO: Origin: https://github.com/bicycle1885/DBSCAN.jl.git
INFO: Generating LICENSE.md
INFO: Generating README.md
```

---

## 実践 - 生成されたファイルの確認

* README.md: パッケージの説明
* LICENSE.md: ライセンス
* REQUIRE: 依存パッケージの記述
* src/: ソースコードのディレクトリ
    * DBSCAN.jl: パッケージのエントリーポイント
* test/: テストコードのディレクトリ
    * runtests.jl: テストコードのエントリーポイント

```
~/D/t/W/summer (master|…) $ cd ~/.julia/v0.5/DBSCAN/ ~/.j/v/DBSCAN (master|✔) $ find . -not -path "/." . ./appveyor.yml ./LICENSE.md ./README.md ./REQUIRE ./src ./src/DBSCAN.jl ./test ./test/runtests.jl
```

---

## 実践 - テストの実行

PkgDevが生成したデフォルトのテストを実行

```
~/.j/v/DBSCAN (master|✚1…) $ julia test/runtests.jl
Test Failed
  Expression: 1 == 2
   Evaluated: 1 == 2
ERROR: LoadError: There was an error during testing
 in record(::Base.Test.FallbackTestSet, ::Base.Test.Fail) at ./test.jl:397
 in do_test(::Base.Test.Returned, ::Expr) at ./test.jl:281
 in include_from_node1(::String) at ./loading.jl:426
 in process_options(::Base.JLOptions) at ./client.jl:262
 in _start() at ./client.jl:318
while loading /Users/kenta/.julia/v0.5/DBSCAN/test/runtests.jl, in expression starting on
line 5
```

---

## 実践 - テストの修正・再実行

PkgDevが生成したデフォルトのテストを修正し再実行

より詳しいテストの書き方は<http://julia.readthedocs.io/en/latest/stdlib/test/>を参照

---

## 実践 - Juliaの命名慣習

* 関数名は`lowercase`
    * アンダースコアはなるべく避ける (例: `isempty`, `haskey`)
    * 例外もある (例: `leading_ones`, `is_unix`)
    * 破壊的関数は`!`を付ける (例: `push!`, `sort!`)
* 型名・モジュール名は`CamelCase`
    * モジュール名とパッケージ名は一致させる
    * ある型を定義するパッケージはその複数形にする (例: `DataFrame` ↔ DataFrames.jl)
* 定数は`UPPERCASE`
    * アンダースコアも割りとOK (例: `C_NULL`, `CPU_CORES`)
    * 例外もある (例: `pi`, `e`)

---

## 実践 - 擬似コードから翻訳 (1/3)

WikipediaのDBSCANの擬似コードをJuliaへ翻訳する: <https://en.wikipedia.org/wiki/DBSCAN>

```
DBSCAN(D, eps, MinPts) {
   C = 0
   for each point P in dataset D {
      if P is visited
         continue next point
      mark P as visited
      NeighborPts = regionQuery(P, eps)
      if sizeof(NeighborPts) < MinPts
         mark P as NOISE
      else {
         C = next cluster
         expandCluster(P, NeighborPts, C, eps, MinPts)
      }
   }
}
```

---

## 実践 - 擬似コードから翻訳 (2/3)

WikipediaのDBSCANの擬似コードをJuliaへ翻訳する: <https://en.wikipedia.org/wiki/DBSCAN>

```
expandCluster(P, NeighborPts, C, eps, MinPts) {
   add P to cluster C
   for each point P' in NeighborPts { 
      if P' is not visited {
         mark P' as visited
         NeighborPts' = regionQuery(P', eps)
         if sizeof(NeighborPts') >= MinPts
            NeighborPts = NeighborPts joined with NeighborPts'
      }
      if P' is not yet member of any cluster
         add P' to cluster C
   }
}
```

---

## 実践 - 擬似コードから翻訳 (3/3)

WikipediaのDBSCANの擬似コードをJuliaへ翻訳する: <https://en.wikipedia.org/wiki/DBSCAN>

```
regionQuery(P, eps)
   return all points within P's eps-neighborhood (including P)
```

src/DBSCAN.jl

---

## 実践 - 擬似データの生成

gendata.jl:
```julia
n_cluster1 = 100
n_cluster2 = 100
n_noise = 10
n_total = n_cluster1 + n_cluster2 + n_noise

points = []
append!(points, [randn(2) + [-2.0, -2.0] for _ in 1:n_cluster1])
append!(points, [randn(2) + [+2.0, +2.0] for _ in 1:n_cluster2])
append!(points, [randn(2) * 3 for _ in 1:n_noise])
shuffle!(points)

D = Matrix{Float64}(n_total, n_total)
for p in 1:n_total, q in 1:n_total
    D[p,q] = norm(points[p] - points[q])
end
```

---

## 実践 - REPLでの実行

擬似データ生成のファイルを読み込む:

```
julia> include("gendata.jl")

julia> DBSCAN.dbscan(D, 1.0, 5)
2-element Array{Any,1}:
 Any[1,7,14,23,29,41,57,60,61,63  …  77,87,78,105,80,55,59,97,17,101]
 Any[4,9,18,19,21,25,28,30,40,50  …  89,26,69,52,13,106,47,82,15,10]
```

---

## 実践 - ドキュメント

パッケージが提供する関数にはドキュメントを付けるべき

```julia
"""
    dbscan(D, eps, minpts)

Find clusters from the distance matrix `D` using the DBSCAN algorithm.

`eps` is a parameter to detect ϵ-neighborhoods and `minpts` is a parameter of
the minimum number of points to form a dense region.
"""
function dbscan(D, eps, minpts)
    # ...
end
```

ガイドライン
<http://julia.readthedocs.io/en/latest/manual/documentation/>

---

## 実践 - 時間があればOPTICSの実装も

Ordering points to identify the clustering structure
* DBSCANの発展形
* クラスター毎に**密度が異なる**場合に強い
* 最近はHDBSCANの方が良いかも (詳しい方教えて下さい)

Wikipediaの擬似コードを参考に: <https://en.wikipedia.org/wiki/OPTICS_algorithm>

---

## 実践 - テストを書く

* `@test`: `true`を返すテスト
* `@testset`: テストをまとめる

```julia
using DBSCAN
using Base.Test
function distance(points) ... end
@testset "dbscan" begin
    D = distance(vcat(
        [rand(2) * 0.1 + [-10, -10] for _ in 1:10],
        [rand(2) * 0.1 + [+10, +10] for _ in 1:10]))
    clusters = dbscan(D, 1.0, 3)
    @test length(clusters) == 2
    @test Set(clusters[1]) == Set(1:10)
    @test Set(clusters[2]) == Set(11:20)
end
```

---

## 実践 - パフォーマンスの改善...の前に

> We should forget about small efficiencies, say about 97% of the time: **premature optimization is the root of all evil.**

* まずは**正しく**動作するコードを書くことに集中する
    * 正しくないコードはいくら速くても無価値
* Regressionを避けるため**テスト**を書く
    * コードの変更は常にregressionのリスクを伴う
* パフォーマンスのチューニングでは必ず**プロファイル**を取る
    * 「犯人」と決めつけるには証拠が必要

---

## 実践 - パフォーマンスの改善

1クラスターあたり1,000個のデータを生成して実験

```julia
julia> @time dbscan(D, 1.0, 10)
 12.505263 seconds (346.78 M allocations: 5.184 GB, 12.64% gc time)
2-element Array{Any,1}:
 Any[1,20,58,85,95,105,152,193,203,244  …  1210,1502,150,1808,640,1364,209,1185,470,483]
 Any[7,21,23,27,31,33,36,38,45,48  …  731,206,1037,1871,874,2001,491,896,1841,821]
```

---

## 実践 - パフォーマンスの改善

`@profile`でプロファイルを取る

```julia
julia> @profile dbscan(D, 1.0, 10);
julia> Profile.print()
9672 ./event.jl:46; (::Base.REPL.##3#4{Base.REPL.REPLBacken...
 9672 ./REPL.jl:95; macro expansion
  9672 ./REPL.jl:64; eval_user_input(::Any, ::Base.REPL.REP...
   9672 ./boot.jl:234; eval(::Module, ::Any)
    9672 ./<missing>:?; anonymous
     9672 ./profile.jl:16; macro expansion;
      1    ....5/DBSCAN/src/DBSCAN.jl:33; dbscan(::Array{Float64,2}, ::Float64...
       1 ...0.5/DBSCAN/src/DBSCAN.jl:84; region_query(::Array{Float64,2}, ::In...
      9671 ....5/DBSCAN/src/DBSCAN.jl:38; dbscan(::Array{Float64,2}, ::Float64...
       13   ....5/DBSCAN/src/DBSCAN.jl:62; expand_cluster(::Array{Float64,2}, ...
       39   ....5/DBSCAN/src/DBSCAN.jl:63; expand_cluster(::Array{Float64,2}, ...
       ...
```

---

## 実践 - パフォーマンスの改善

> Yet we should not pass up our opportunities in that critical 3%.

今回のコードの何処がcritical 3%か?

調べてみてください :)

---

## 実践 - バージョニング

* Julia本体もパッケージもすべて**Semantic Versioning**準拠
    * バージョン = `<MAJOR>.<MINOR>.<PATCH>`
        1. `MAJOR`: 互換性のないAPIの変更
        2. `MINOR`: 互換性のある機能追加
        3. `PATCH`: 互換性のあるバグ修正
    * 詳しくは: <http://semver.org/>
* バージョンもGitのタグで管理されている
    * `PkgDev.tag("DBSCAN", :patch|:minor|:major)`でタグ作成

---

## 実践 - 公式パッケージ化

* README.mdの記述・テスト・ドキュメントあたりは必須
* 登録申請はMETADATA.jlへプルリクをする
    * `PkgDev.register("DBSCAN")`でローカルのMETADATA.jlにメタ情報をコミット
    * `PkgDev.publish()`でプルリクを作成
    * 手作業でもできるがオススメしない
    * パッケージ名やスタイルなど突っ込まれたら直すか戦う
    * <https://github.com/JuliaLang/METADATA.jl/pulls>
* そんなに大変じゃないです(多分)

---

## 実践 - プロット

Juliaのプロットライブラリ:
* Gadfly.jl
* PyPlot.jl
* PlotlyJS.jl
* GR.jl
* Plots.jl

今日はPyPlot.jlとPlotlyJS.jlを簡単に紹介

---

## 実践 - PyPlot.jl

* PythonのMatplotlibのラッパー
* Matplotlibになれた人なら使いやすい

```julia
using PyCall
pygui(:qt)
using PyPlot
plot(randn(100), rand(100), "o")
```

---

## 実践 - PlotlyJS.jl

* Plotlyのラッパー
* インタラクティブなプロットが簡単

```julia
using PlotlyJS
plot(scatter(x=randn(100), y=randn(100), mode="markers"))
```

---

## 他の便利パッケージ

* <https://github.com/BioJulia/Bio.jl>
* <https://github.com/IntelLabs/HPAT.jl>
* <https://github.com/IntelLabs/ParallelAccelerator.jl>
* <https://github.com/JuliaDiff/ForwardDiff.jl>
* <https://github.com/JuliaOpt/JuMP.jl>
* <https://github.com/JuliaOpt/Optim.jl>
* <https://github.com/JuliaStats/DataFrames.jl>
* <https://github.com/JuliaStats/Distributions.jl>
* <https://github.com/JuliaStats/StatsBase.jl>
* <https://github.com/Keno/Cxx.jl>
* <https://github.com/stevengj/PyCall.jl>
* <https://github.com/JuliaStats/RCall.jl>

---

## まとめ

* Juliaは**高レベル**かつ**高パフォーマンス**
* Juliaのコミュニティは**アカデミック**寄り
* 様々な用途に使える**言語機能**や**データ構造**が付属している
* パッケージングには**標準的な方法**が用意されている
* パフォーマンスの改善には**テスト**と**プロファイリング**も
* プロットは**PyPlot.jl, PlotlyJS.jl, Gadfly.jl**あたりがオススメ
* まだv1.0以前で**不安定**な部分は確かにある

---
class: middle center

質問等どうぞ
