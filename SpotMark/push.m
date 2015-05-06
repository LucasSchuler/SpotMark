//
// Copyright (c) 2015 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import "User.h"

#import "push.h"

void ParsePushUserAssign(NSString *userid){
	PFInstallation *installation = [PFInstallation currentInstallation];
    [installation addUniqueObject:[@"user" stringByAppendingString:userid] forKey:@"channels"];
	installation[@"user"] = [PFUser currentUser];
	[installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error != nil)
		{
			NSLog(@"ParsePushUserAssign save error.");
		}
	}];
}


void pushEvent(NSString *eventId, NSString *eventName, NSInteger cod, NSString *text){
    User *user1 = [User sharedUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"objectId" equalTo:eventId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            PFObject *a = [[query findObjects] objectAtIndex:0];
            NSArray *ids = a[@"members"];
            
            PFQuery *userQuery = [PFUser query];
            [userQuery whereKey:@"username" containedIn:ids];
            [userQuery whereKey:@"username" notEqualTo:user1.objectId];
            
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"user" matchesKey:@"objectId" inQuery:userQuery];
            
            PFPush *push = [[PFPush alloc] init];
            
            NSString *message = @"";
            if(cod==0)
                 message = [[[user1.name stringByAppendingString:@" posted in \""] stringByAppendingString:eventName] stringByAppendingString:@"\""];
            else
                 message = [[[[user1.name stringByAppendingString:@" in "] stringByAppendingString:eventName] stringByAppendingString:@": "] stringByAppendingString:text];
            
            [push setQuery:pushQuery]; // Set our Installation query
            [push setMessage:message];
            [push sendPushInBackground];
        }
    }];
}

