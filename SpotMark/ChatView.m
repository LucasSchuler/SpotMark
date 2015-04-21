#import <Parse/Parse.h>
#import "push.h"
#import "ChatView.h"

@interface ChatView()
{
	NSTimer *timer;
	BOOL isLoading;
	BOOL initialized;
	NSString *groupId;
	NSMutableArray *messages;
	JSQMessagesBubbleImage *bubbleImageOutgoing;
	JSQMessagesBubbleImage *bubbleImageIncoming;
}
@end

@implementation ChatView

- (id)initWith:(NSString *)groupId_{
	self = [super init];
	groupId = groupId_;
	return self;
}

- (void)viewDidLoad{
	[super viewDidLoad];
	self.title = _name;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	messages = [[NSMutableArray alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFUser *user = [PFUser currentUser];
	self.senderId = user.objectId;
	self.senderDisplayName = @"aqui";
	//---------------------------------------------------------------------------------------------------------------------------------------------
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    
	JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor: [UIColor colorWithRed:0 green:0.478 blue:1 alpha:1]];
	bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor colorWithRed:0.902 green:0.898 blue:0.918 alpha:1]];

	isLoading = NO;
	initialized = NO;
	[self loadMessages];
}


- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	self.collectionView.collectionViewLayout.springinessEnabled = YES;
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[timer invalidate];
}

#pragma mark - Backend methods

- (void)loadMessages{
	if (isLoading == NO)
	{
		isLoading = YES;
        JSQMessage *message_last = [messages lastObject];
        PFQuery *query = [PFQuery queryWithClassName:@"Message"];
        [query whereKey:@"eventId" equalTo:groupId];
        if (message_last != nil)
            [query whereKey:@"createdAt" greaterThan:message_last.date];
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];

		[query setLimit:50];
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
		{
			if (error == nil)
			{
				BOOL incoming = NO;
				self.automaticallyScrollsToMostRecentMessage = NO;
				for (PFObject *object in [objects reverseObjectEnumerator])
				{
					JSQMessage *message = [self addMessage:object];
					if ([self incoming:message]) incoming = YES;
				}
				if ([objects count] != 0)
				{
					if (initialized && incoming)
						[JSQSystemSoundPlayer jsq_playMessageReceivedSound];
					[self finishReceivingMessage];
					[self scrollToBottomAnimated:NO];
				}
				self.automaticallyScrollsToMostRecentMessage = YES;
				initialized = YES;
			}
			isLoading = NO;
		}];
	}
}


- (JSQMessage *)addMessage:(PFObject *)object{
	JSQMessage *message;
	PFUser *user = object[@"user"];
	NSString *name = user[@"name"];
    //if([object[@"text"] isEqualToString:@"texto"])
    message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:name date:object.createdAt text:object[@"text"]];
 //   else
   //     message = [[JSQMessage alloc] initWithSenderId:@"userid" senderDisplayName:@"alguem" date:object.createdAt text:object[@"text"]];
	[messages addObject:message];
	return message;
}


- (void)sendMessage:(NSString *)text Video:(NSURL *)video Picture:(UIImage *)picture{
        PFObject *object = [PFObject objectWithClassName:@"Message"];
        object[@"user"] = [PFUser currentUser];
        object[@"eventId"] = groupId;
        object[@"text"] = text;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error == nil)
             {
                  [self loadMessages];
             }
         }];
    [self finishSendingMessage];

}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
	[self sendMessage:text Video:nil Picture:nil];
}

#pragma mark - JSQMessages CollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return messages[indexPath.item];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
			 messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([self outgoing:messages[indexPath.item]])
	{
		return bubbleImageOutgoing;
	}
	else return bubbleImageIncoming;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item % 3 == 0)
	{
		JSQMessage *message = messages[indexPath.item];
		return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
	}
	else return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	if ([self incoming:message])
	{
		if (indexPath.item > 0)
		{
			JSQMessage *previous = messages[indexPath.item-1];
			if ([previous.senderId isEqualToString:message.senderId])
			{
				return nil;
			}
		}
		return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
	}
	else return nil;
}

#pragma mark - UICollectionView DataSource

//QUANTIDADE DE MENSAGENS
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return [messages count];
}


//COR DOS TEXTO DAS BUBBLES
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];

	if ([self outgoing:messages[indexPath.item]])
	{
		cell.textView.textColor = [UIColor whiteColor];
	}
	else
	{
		cell.textView.textColor = [UIColor blackColor];
	}
	return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item % 3 == 0)
	{
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	else return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = messages[indexPath.item];
	if ([self incoming:message])
	{
		if (indexPath.item > 0)
		{
			JSQMessage *previous = messages[indexPath.item-1];
			if ([previous.senderId isEqualToString:message.senderId])
			{
				return 0;
			}
		}
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	else return 0;
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)incoming:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return ([message.senderId isEqualToString:self.senderId] == NO);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)outgoing:(JSQMessage *)message
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return ([message.senderId isEqualToString:self.senderId] == YES);
}

@end
