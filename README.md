# Spritesheet To SpriteFrames Importer

Godot Engine v3.3

It is Godot Importer addons.

Convert multiple sprite sheets to SpriteFrames.

It's hard to manually create SpriteFrames by spritesheet images in the Godot editor.

so let's do it automatically.

---

複数のスプライトシートをSpriteFramesに変換して読み込むインポーターのアドオンです。

Godotエディタでスプライトシート画像をSpriteFramesを手動で作成するのは大変なので、自動でやりましょう。

日本語での説明は下の方に書いています。

## Getting Started

This is the same as setting up a general add-on.

1. Copy `spritesheet_to_spriteframes_importer` directory into your project's `addons` directory.
2. Load your project in the Godot editor.
3. Project → Project Settings → Plugin　enable Spritesheet To SpriteFrames Importer.

## Usage

### Make Import file

Create a text `.sheet` file in the same directory anyspritesheet.png.

```toml
[any_file_name]
rows=2
cols=1
frame_counts=2
animation_names=[ "blue_up", "blue_down" ]

[other_file_name]
rows=2
cols=1
frame_counts=4
animation_names=[ "green_mouse", "green_eye" ]
```

TOML format.

#### section

例）xxx_sprite_sheet.png　→ [xxx_sprite_sheet]

#### rows

#### cols

#### frame_counts

`rows`, `cols`, `frame_counts` are same sprite sheet, same thing.

If you want to keep them separate, use multiple spritesheets and separate sections.

#### animation_names

ex）3 rows * 4 cols 12 patterns spritesheets

[(row1 col1), (row1 col2), (row1 col3), (row2 col1), (row2 col2), (row2 col3), (row3 col3), (row4 col2), (row4 col3), (row4 col3)] the names in this order.

If empty string, the pattern isn't added animation.

### Error

- No spritesheet image file in the section name, or not in png format
- Duplicate `animation_names` or the number of `animation_names` does not match.

- `rows`, `columns`, and `frame_counts` do not match.

## Updates

* 2021/10/16 created.

## Author

folta / ふぉる太 [@Faultun](https://twitter.com/faultun)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details



---



## 初期設定

一般的なアドオンの設定と同じです。

1. `spritesheet_to_spriteframes_importer` ディレクトリをGodotプロジェクト直下の `addons` ディレクトリに入れます。
2. Godotエディタでプロジェクトを読み込み、プロジェクト→プロジェクト設定→プラグイン Spritesheet To SpriteFrames Importer を有効にします。

## 使い方

### Importファイル作成

スプライトシート.pngと同じディレクトリに拡張子が `.sheet` のテキストファイルを作成します。

```toml
[any_file_name]
rows=2
cols=1
frame_counts=2
animation_names=[ "blue_up", "blue_down" ]

[other_file_name]
rows=2
cols=1
frame_counts=4
animation_names=[ "green_mouse", "green_eye" ]
```

TOML形式で記述します。

#### セクション名（上の例ファイルの`any_file_name`, `other_file_name`にあたる箇所）

セクション名はスプライトシート.pngの名前にします。

例）xxx_sprite_sheet.png　→ [xxx_sprite_sheet]

#### 行数 `rows`

#### 列数 `cols`

#### フレーム数 `frame_counts`

行数、列数、フレーム数は同スプライトシートで同じになります。

別にしたい場合は別のスプライトシートにして、設定を分けてください。

#### アニメーション名 `animation_names`

例）3行 * 4列の12パターンのスプライトシートの場合は、

[1列目1行目、1列目2行目、1列目3行目、2列目1行目、2列目2行目、2列目3行目、3列目3行目、4列目2行目、4列目3行目、4列目3行目]の順番となるため、この順番で名前を指定します。

空文字を指定した場合は、そのパターンをアニメーションとして追加しません。

### エラーについて

こういった場合はエラーになります。

- セクション名に指定した画像がない、png形式でない
- 重複したアニメーション名や、アニメーション名の数が一致しない

- 行数、列数、フレーム数が一致しない

## 更新履歴

* 2021/10/16 作った

## 作成者

folta / ふぉる太　[@Faultun](https://twitter.com/faultun)

## ライセンス

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
