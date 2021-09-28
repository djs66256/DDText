# DDText
More powerful label, attributed string builder and text parser.

# DDLabel

More powerful label than `UILabel`, using `TextKit`. It supports features below:

1. View attachment. You can add custom views.
2. User action. Support clicking and highlight through `GestureRecognize`. And you can custom gesture challenge.

It's free embeded in AutoLayout or Flexbox.

## Note

`DDLabel` only support attributed string. Because simple string can use `UILabel` instead. `UILabel` is more efficiently when simple string.

# TextBuilder

It is a builder easy for using. For example:

```swift
let text: NSAttributedString = AttributedTextBuilder()
    .systemFont(ofSize: 17)
    .append(string: "This is a string with ")
    .save()
    .DDUserAction({ [weak self] (text) -> Void in
        let alert = UIAlertController(title: "\(text.string) is pressed!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { [weak alert] (_) in
            alert?.dismiss(animated: true, completion: nil)
        }))
        self?.present(alert, animated: true, completion: nil)
    })
    .DDHighlightedBackgroundColor(.red)
    .textColor(.blue)
    .append(string: "USER ACTION")
    .restore()
    .append(string: ". Try to press the blue area.")
    .buildAttributedString()
```

# TextParser

It is a tool to parse string to attributed string. Now, it supports:

1. `@Username`
2. link, `https://github.com/djs66256/DDText/new`
3. topic, `#Topic#`
4. email, `djs66256@163.com`
5. emoj, `[Good]`

Welcome to add more text parser.
