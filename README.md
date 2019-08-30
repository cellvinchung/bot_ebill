# BotEbill

[台灣銀行電子化收款](https://www.bot.com.tw/Business/ITBusiness/Pages/ebill.aspx)Barcode內容產生器

>- 請先向台灣銀行申請電子化收款服務。
>-  不產出Barcode圖像，請搭配使用Barcode產生器，如[barby](https://github.com/toretore/barby)(ruby)、[JsBarcode](https://github.com/lindell/JsBarcode)(js)等，格式使用**code39**。

## Installation

Gemfile 加上:

```ruby
gem 'bot_ebill'
```

執行:

    $ bundle

或直接執行:

    $ gem install bot_ebill

## 使用方式

```ruby 
@barcode_text = BotEbill::BarcodeText.new(
	collection_no: "代收類別", 
	store_no: "超商代收項目", 
	order_no: "自訂編號", 
	price: "金額"
    )

#台銀條碼內容
@barcode_text.bot_text

#超商條碼內容
@barcode_text.store_text 

#郵局條碼內容
@barcode_text.post_office_text
```

## License

[MIT License](https://opensource.org/licenses/MIT).