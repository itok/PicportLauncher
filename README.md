PicportLauncher
===============

sample for launch Picport ( http://picport.cc/ )

## Usage

### Open Picport with NSData

call `jp.itok.picport://data/type?=<UTI>` with copy NSData to pasteboard

```objc
+(BOOL) openPicportWithData:(NSData*)data UTI:(NSString*)uti options:(NSDictionary*)options;
```

### Open Picport with UIImage

call `jp.itok.picport://image` with copy UIImage to pasteboard

```objc
+(BOOL) openPicportWithImage:(UIImage*)image options:(NSDictionary*)options;
```

### Open Picport with Assets' URLs

call `jp.itok.picport://assets/?assets=<Assets' URLs>` (URLs should be comma separated)

```objc
+(BOOL) openPicportWithAssetURLs:(NSArray *)urls options:(NSDictionary *)options;
```

### Open Picport with latest photo

call `jp.itok.picport://latest`

```objc
+(BOOL) openPicportWithLatestPhoto;
```

### Options dictionary

|key|val|
|---|---|
|appName|application name (NSString)|
|backURL|callback URL scheme (NSString)|
|hashTag|hash tag (NSString)|


```objc
+(NSDictionary*) optionsWithAppName:(NSString*)appName backURL:(NSString*)backURL hashTag:(NSString*)hashTag;

// Utility macro
#define PPPicportOptions(__appName__, __backURL__, __hashTag__)
```

### Open Picport by UIDocumentInteractionController

`options` dictionay can be setted to `annotation`

```objc
UIDocumentInteractionController* docCtl = [UIDocumentInteractionController interactionControllerWithURL:url];
docCtl.delegate = self;
docCtl.annotation = PPPicportOptions(<appName>, <backURL>, <hashTag>);
```

## Install

Use CocoaPods,

```ruby
pod 'PicportLauncher', :git => 'https://github.com/itok/PicportLauncher.git'
```

## License

MIT license