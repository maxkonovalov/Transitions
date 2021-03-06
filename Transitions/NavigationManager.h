//
//  NavigationManager.h
//  Transitions
//
//  Created by Max Konovalov on 4.01.14.
//  Copyright (c) 2014 max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationManager : NSObject <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@end
