# SKpacManLoader

![packmanloader2](https://user-images.githubusercontent.com/5552822/28139593-291b7f0a-6755-11e7-9563-120a4eabe01b.gif)

SKpacManLoader is a custom loader view which have the famous pac-man character eating food back and fourth till the loading is finished 



## Requirements

- iOS 7.0+
- Swift 3.0
- ARC

## Installation

### Manual
- Simply add the `SKpacManLoader` folder to your project.
- When you want the loader to start call the startLoadingIn(_ ViewController:UIViewController, withBackGround:Bool  ,withPacManColor:UIColor , withDotsColor:UIColor ) function.
- When you want to dissmiss it call finishLoadingFrom(_ ViewController:UIViewController) function.


### code

```swift
        startLoadingIn(self, withBackGround: true, withPacManColor: UIColor.brown, withDotsColor: UIColor.brown)
        finishLoadingFrom(self)
```

## Customizable Properties

- Pacman Color

  The color of the pacman object
- Dots Color

  The color of the dots that the pacman eats while loading
 
- withBackGround

  if you want the loader show with a overlayview or not 

 
