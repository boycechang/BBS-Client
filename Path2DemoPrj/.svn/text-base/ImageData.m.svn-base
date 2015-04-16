//  SingleImageWithScrollViewController.h
//  虎踞龙盘BBS
//
//  Created by 张晓波 on 1/5/13.
//  Copyright (c) 2012 SEU. All rights reserved.
//

#import "ImageData.h"

@implementation ImageData
@synthesize title;
@synthesize url;
@synthesize image;
@synthesize waitImage;
- (id)init
{
    self = [super init];
    if (self) {
        self.waitImage = [UIImage imageNamed:@"waitimage"];
    }
    return self;
}
-(void)dealloc
{
    
    
    imageData = nil;
    waitImageData = nil;
}

#pragma -
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder*)decoder  
{
    if (self = [super init]) {
        title = [decoder decodeObjectForKey:@"title"];
        url = [decoder decodeObjectForKey:@"url"];
        imageData = [decoder decodeObjectForKey:@"imageData"];
        waitImageData = [decoder decodeObjectForKey:@"waitImageData"];
        
        image = [UIImage imageWithData:imageData];
        waitImage = [UIImage imageWithData:waitImageData];
    }
    return  self;
}
- (void)encodeWithCoder:(NSCoder*)coder  
{
    [coder encodeObject:title forKey:@"title"];
    [coder encodeObject:url forKey:@"url"];
    imageData = UIImagePNGRepresentation(image);
    [coder encodeObject:imageData forKey:@"imageData"];
    waitImageData = UIImagePNGRepresentation(waitImage);
    [coder encodeObject:waitImageData forKey:@"waitImageData"];    
}
@end
