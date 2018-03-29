# WBCollectionViewLayout

It provides 4 different type of Custom layout for CollectionView. 


|             Two Cell Layout         |         Three Cell Left Layout          | Three Cell Right Layout | Mix Layout |
|---------------------------------|------------------------------|------------------------------|---------------------------------|
|![Demo](https://github.com/mwaqasbhati/WBCollectionViewLayout/blob/master/Screenshots/two.png)|![Demo](https://github.com/mwaqasbhati/WBCollectionViewLayout/blob/master/Screenshots/threeleft.png)|![Demo](https://github.com/mwaqasbhati/WBCollectionViewLayout/blob/master/Screenshots/threeright.png)|![Demo](https://github.com/mwaqasbhati/WBCollectionViewLayout/blob/master/Screenshots/mixture.png)
|![Demo](https://github.com/mwaqasbhati/WBCollectionViewLayout/blob/master/Screenshots/two_1.png)|![Demo](https://github.com/mwaqasbhati/WBCollectionViewLayout/blob/master/Screenshots/threeleft_1.png)|![Demo](https://github.com/mwaqasbhati/WBCollectionViewLayout/blob/master/Screenshots/threeright_1.png)|![Demo](https://github.com/mwaqasbhati/WBCollectionViewLayout/blob/master/Screenshots/mixture_1.png)

## Contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Example](#example)
- [Usage](#usage)
- [Tips](#tips)
- [Contact us](#contact-us)
- [License](#license)


## Requirements

- iOS 9.0+
- Swift 4.0

## Installation

### Manually

Download the Code and Copy the layout file -> `WBCollectionViewLayout.swift` into your project. That's it.

### CocoaPods

WBCollectionViewLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WBCollectionViewLayout'
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

- Just Create a WBGridViewLayout object and Confirm to it's Delegate
  
```swift
let mlayout = WBGridViewLayout()
mlayout.delegate = self
collectionView.setCollectionViewLayout(layout, animated: true)
```
Note: Delegates methods are optional and in default case Mixture layout will be drawn but if you want more customization then you need to implement it's delegates

### Two Cell Layout
```swift
func colectionView(_ collectionView: UICollectionView, numberOfItemsInRow row: Int) -> CellLayout {
   return .Two
}
```
### Three Cell Left Layout
```swift
func colectionView(_ collectionView: UICollectionView, numberOfItemsInRow row: Int) -> CellLayout {
   return .ThreeLeft
}
```
### Three Cell Right Layout
```swift
func colectionView(_ collectionView: UICollectionView, numberOfItemsInRow row: Int) -> CellLayout {
   return .ThreeRight
}
```
### Mixutre Cell Layout

This Layout is the default one and you don't have to implement `numberOfItemsInRow` delegate.

### Custom Cell Layout

- If you want more customization in drawing the layout then you can optionally implement it's delegate methods given below which provides `numberOfItemsInRow` for each Row and `size of each Row`.

```swift
func colectionView(_ collectionView: UICollectionView, numberOfItemsInRow row: Int) -> CellLayout
func colectionView(_ collectionView: UICollectionView, sizeOfItemInRow row: Int) -> CGSize?

```

## Tips

### When you load data from service 

In case you load data asynchronously please follow next steps:

> when data is loaded invalidate layout as well as reload data on collection view.
```swift
collectionView.collectionViewLayout.invalidateLayout()
collectionView.reloadData()
```

## Author

mwaqasbhati, m.waqas.bhati@hotmail.com

## License

WBCollectionViewLayout is available under the MIT license. See the LICENSE file for more info.
