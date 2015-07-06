[![Build Status](https://travis-ci.org/mmmpa/rough_swal.svg)](https://travis-ci.org/mmmpa/rough_swal)
[![Coverage Status](https://coveralls.io/repos/mmmpa/rough_swal/badge.svg?branch=master)](https://coveralls.io/r/mmmpa/rough_swal?branch=master)
[![Code Climate](https://codeclimate.com/github/mmmpa/rough_swal/badges/gpa.svg)](https://codeclimate.com/github/mmmpa/rough_swal)

# RoughSwal

RoughSwalはRailsのControllerからアラート代わりに[SweetAlert](http://t4t5.github.io/sweetalert/)を簡単に呼び出すために書かれました。

```ruby
def create
  User.create!(user_params)
rescue ActiveRecord::RecordInvalid => e
  swal{ error '不正な値が含まれています', '項目を確認の上、再度送信してください' }
  @user = e.record
end
```

するとHTML下部に

```html
<script>swal({"type":"error","不正な値が含まれています":"Error","text":"項目を確認の上、再度送信してください"});</script>
```

と挿入される。

# Instration
```
gem 'rough_swal'
```

```
$ bundle install
```

[SweetAlert](http://t4t5.github.io/sweetalert/)のインストールは各自でやっていく。

# Usage

## ショートカット

パラメーターは手動で設定可能ですが、まず単純な起動のショートカットとして以下の呼び出しがあります。

```ruby
swal { success 'Success', 'success text' }
# <script>swal({"type":"success","title":"Success","text":"success text"});</script>

swal { info 'Info', 'info text' }
# <script>swal({"type":"info","title":"Info","text":"info text"});</script>

swal { warning 'Warning', 'warning text' }
# <script>swal({"type":"warning","title":"Warning","text":"warning text"});</script>

swal { error 'Error', 'error text' }
# <script>swal({"type":"error","title":"Error","text":"error text"});</script>
```

## パラメータを設定して起動

こんな感じで。

```ruby
swal{
  title 'タイトル'
  text 'テキスト'
  type :info
  confirm_button_color '#000'
  function 'function(){ alert("raw alert") }'
}
```

パラメーター名はこんな感じで。
```ruby
PARAMETERS = [
    :title,
    :text,
    :type,
    :allow_escape_key,
    :custom_class,
    :allow_outside_click,
    :show_cancel_button,
    :show_confirm_button,
    :confirm_button_text,
    :confirm_button_color,
    :cancel_button_text,
    :close_on_confirm,
    :close_on_cancel,
    :image_url,
    :image_size,
    :timer,
    :html,
    :animation,
    :input_type,
    :input_placeholder,
    :input_value,
    :function,
]
```

## プリセット

よく使うアラートはプリセットとして登録可能です。

```ruby
RoughSwal.configure do
  preset(:timer_alert) {
    type 'error'
    timer 2000
    allow_outside_click true
  }
end
```

```ruby
swal { timer_alert '失敗', '失敗したみたいです' }
# <script>swal({"type":"error","timer":2000,"allowOutsideClick":true,"title":"失敗","text":"失敗したみたいです"});</script>
```

## デフォルト値

サイトには共通のカラーなどがあるでしょうから、それを前もって設定することもできます。

```ruby
RoughSwal.configure do
  default {
    confirm_button_text '良し'
    confirm_button_color '#04c'
    cancel_button_text '悪し'
  }
end
```

```ruby
swal {
  warning 'いいですか？', 'この構えでいいですか？'
  show_confirm_button true
}
# <script>swal({"confirmButtonText":"良し","confirmButtonColor":"#04c","cancelButtonText":"悪し","type":"warning","title":"いいですか？","text":"この構えでいいですか？","showCancelButton":true});</script>
```
