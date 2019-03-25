//
//  GithubWeatherViewController.h
//  iTalker
//
//  Created by 鑫 on 2019/1/18.
//  Copyright © 2019 ihtc.cc @iHTCboy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <SmileWeather/SmileWeatherDemoVC.h>
#import <SmileWeather/SmileWeatherDownLoader.h>
NS_ASSUME_NONNULL_BEGIN

@interface GithubWeatherViewController : UIViewController
@property (nonatomic,strong) CLLocation *loaction;
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lng;
@end

NS_ASSUME_NONNULL_END
