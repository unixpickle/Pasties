//
//  OnlineTextPoster.h
//  Pasties
//
//  Created by Alex Nichol on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OnlineTextPoster;

@protocol OnlineTextPosterDelegate<NSObject>

@optional
- (void)onlineTextPoster:(OnlineTextPoster *)poster postedToURL:(NSURL *)textURL;
- (void)onlineTextPoster:(OnlineTextPoster *)poster failedWithError:(NSError *)theError;

@end

/**
 * This is an abstract class for posting text to an online
 * website.
 */
@interface OnlineTextPoster : NSObject {
	id<OnlineTextPosterDelegate> delegate;
}

/**
 * The delegate of the online text poster.  This will be called back upon
 * when a post successfully finishes, or a post fails.
 * The delegate is retained because OnlineTextPosted will retain itself when a background
 * thread is started.  This means that even if the delegate releases the text poster,
 * it will still be called upon when a post finishes.
 */
@property (nonatomic, retain) id<OnlineTextPosterDelegate> delegate;

/**
 * Creates a new text poster with text and a language.
 * @param theText The text to post to the text poster.
 * @param language An object that carries information to the text poster
 * was to which programming/text language the posted text is written in.
 */
- (id)initWithText:(NSString *)theText language:(id)language;

/**
 * Begins an asynchronous post to the text poster site.
 * @return YES if the background post was initiated successfully.  NO on
 * any sort of failure or if a background thread is already running.
 */
- (BOOL)postInBackground;

@end
