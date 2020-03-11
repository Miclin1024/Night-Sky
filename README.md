<p align="center">
  <a href="" rel="noopener">
 <img src="https://me.miclin.cc/static/darkSky.load.gif" alt="Project logo" width=200px loop=false></a>
</p>
<h1 align="center">ᴅᴀʀᴋ sᴋʏ</h1>

<div align="center">

<div align="center">
  <img src="https://img.shields.io/badge/MDB-NewbieProject-informational.svg"> <img src="https://img.shields.io/badge/Project4-informational.svg"><br>
  <img src="https://img.shields.io/badge/Platform-iOS-success.svg">
  <img src="https://img.shields.io/badge/Swift-success.svg">
</div>

</div>

<hr style="margin: 20px; height: 2px">
<p align="center"> <strong>Mobile Developer @ Berkeley - MP4</strong>
    <br> 
</p>

## 🚀 About

This is the last one-week mini-project of the MDB training program. It is a lightweight APP built to present weather data from the [Dark Sky](https://darksky.net/) API. It automatically retrieves current location and allows the user to search for other locations and store them for convenient access.  

<img src="https://me.miclin.cc/static/darkSky.screen.jpg">

## 💡 Highlights

- A concise, responsive, dark themed UI
- GMS backed location search
- Vector animation powered by [lottie](http://airbnb.io/lottie/#/README)

## ⛓️ Dependencies

- Swift 5
- Cocoapod

## 🏁 Install

These instructions will get you a copy of the project up and running on your local machine for development.

### Prerequisites
Make sure that you have cocoapod installed
```
pod --version 
```
Swift 5.1 or higher
```
swift --version
```

### Installing

First clone the project

```
git clone https://github.com/Miclin1024/Dark-Sky.git Dark\ Sky && cd Dark\ Sky
```
Install all the cocoapod dependencies
```
pod install
```
Open the project with Xcode, but for it to run we will need to the secret key of [Dark Sky](https://darksky.net/dev) and [GMS Place](https://developers.google.com/places/web-service/intro) API. Once you have those, add the keys to `Dark Sky/Support Files/Secrets.plist`