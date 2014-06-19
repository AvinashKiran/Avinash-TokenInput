//
//  TokenViewController.m
//  TokenApp
//
//  Created by FMIT on 5/20/14.
//  Copyright (c) 2014 AvaniTech. All rights reserved.
//

#import "TokenViewController.h"

@interface TokenViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL didHold;
}
@property(nonatomic,weak)IBOutlet UITextView *txtAddress;
@property(nonatomic,weak)IBOutlet UIScrollView *scrView;
@property(nonatomic,weak)IBOutlet UIScrollView *innerScrView;
@property(nonatomic,strong)IBOutlet UIView *dataView;
@property(nonatomic,weak)IBOutlet UITableView *tblView;
@property(nonatomic,strong)NSArray *arrayData;
@property(nonatomic,assign)CGFloat yCor;
@property(nonatomic,assign)CGFloat xCor;
@property(nonatomic,assign)CGFloat yPos;
@property(nonatomic,strong)NSMutableArray *arrayMatches;
@property(nonatomic,strong)NSMutableArray *arrayTextField;
@property(nonatomic,strong)NSTimer *itemHoldTimer;
@property(nonatomic,assign)CGFloat txtViewPosition;



@end

@implementation TokenViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.xCor=5;
    self.yPos=5;
    self.txtViewPosition=5;
    [super viewDidLoad];
    self.innerScrView.contentSize=CGSizeMake(self.innerScrView.frame.size.width, 110);
    self.arrayData=[[NSArray alloc]initWithObjects:@"avinash",@"samba",@"ganesh",@"venkatesh",@"faraz",@"santosh",@"sasi",@"rajesh",@"pavan",@"kiran",@"kumar",@"prasad",@"ravi", nil];
    self.arrayMatches=[[NSMutableArray alloc]init];
    self.arrayTextField=[[NSMutableArray alloc]init];
    self.yCor=0;
    self.txtAddress.scrollEnabled=NO;
    [self.tblView reloadData];
    self.tblView.layer.borderColor=[UIColor darkGrayColor].CGColor;
    self.tblView.layer.borderWidth=1;
    self.tblView.layer.cornerRadius=5.0f;
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    gesture.numberOfTouchesRequired=1;
    [self.innerScrView addGestureRecognizer:gesture];
}

-(void)handleTap:(UITapGestureRecognizer *)gesture{
    [self.txtAddress becomeFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.scrView.contentOffset=CGPointMake(0, self.innerScrView.center.y-220);
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGSize maximumSize = CGSizeMake(300, 9999);
    UIFont *myFont = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    CGSize myStringSize = [textView.text sizeWithFont:myFont
                           constrainedToSize:maximumSize
                               lineBreakMode:NSLineBreakByTruncatingTail];
    if (self.txtAddress.frame.origin.x+myStringSize.width>self.innerScrView.frame.size.width-10) {
        self.txtAddress.frame=CGRectMake(5, self.txtAddress.frame.origin.y+35, self.txtAddress.frame.size.width, self.txtAddress.frame.size.height);
        if (self.txtAddress.frame.origin.y>=self.innerScrView.frame.size.height)
        {
            self.innerScrView.contentOffset=CGPointMake(0,self.txtAddress.center.y-90);
        }
    }
    NSString *search=[[textView.text lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    bool done=false;
    if ([search isEqualToString:@""]) {
        [self.dataView removeFromSuperview];
        [self removeDataView];
    }
    else{
        
        if ([[search substringFromIndex:[search length]-1] isEqualToString:@","]) {
            [self removeDataView];
            search=[search substringWithRange:NSMakeRange(0, [search length]-1)];
            if (search.length!=0) {
                done=true;
            }
        }
        if (done) {
            [self sendData:search];
            [self removeDataView];
            [self.innerScrView addSubview:[self.arrayTextField lastObject]];
            self.txtAddress.text=@"";
        }
        else{
            if (self.arrayMatches.count!=0) {
                [self removeDataView];
            }
            for (int i=0; i<self.arrayData.count; i++) {
                NSString *data=[[self.arrayData objectAtIndex:i] lowercaseString];
                if ([data rangeOfString:search].location!=NSNotFound) {
                    [self.arrayMatches addObject:data];
                }
            }
            if (self.arrayMatches.count!=0) {
                [self.tblView reloadData];
                if (self.arrayMatches.count*25>75) {
                    self.dataView.frame=CGRectMake(20,self.innerScrView.frame.origin.y+self.innerScrView.frame.size.height, 280, 75);
                }
                else{
                    self.dataView.frame=CGRectMake(20,self.innerScrView.frame.origin.y+self.innerScrView.frame.size.height, 280, self.arrayMatches.count*25);
                }
                [self.scrView addSubview:self.dataView];
            }
        }
    }
}

-(void)removeDataView{
    self.scrView.contentOffset=CGPointMake(0, self.innerScrView.center.y-220);
    [self.arrayMatches removeAllObjects];
    [self.dataView removeFromSuperview];
    self.yCor=0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayMatches.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell)
        cell= [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];
    cell.textLabel.text=[self.arrayMatches objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [self sendData:cell.textLabel.text];
    [self.innerScrView addSubview:[self.arrayTextField lastObject]];
    self.txtAddress.text=@"";
    [self removeDataView];
}

-(void)sendData:(NSString *)data{
    self.txtAddress.text=@"";
    CGSize maximumSize = CGSizeMake(300, 9999);
    UIFont *myFont = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    CGSize myStringSize = [data sizeWithFont:myFont
                               constrainedToSize:maximumSize
                                   lineBreakMode:NSLineBreakByTruncatingTail];
    UIButton *token=[UIButton buttonWithType:UIButtonTypeCustom];
    token.frame=CGRectMake(self.xCor, self.yPos, myStringSize.width+10,30);
    [token setTitle:data forState:UIControlStateNormal];
    [token.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [token setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [token setBackgroundColor:[UIColor colorWithRed:0.000 green:0.562 blue:1.000 alpha:0.7]];
    token.layer.cornerRadius=7.0f;
    [token addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    if (self.txtViewPosition+token.frame.size.width>self.innerScrView.frame.size.width) {
        self.xCor=5;
        self.yPos=self.yPos+token.frame.size.height+5;
        self.txtViewPosition=5;
        token.frame=CGRectMake(self.xCor, self.yPos, myStringSize.width+10,30);
        self.txtViewPosition=self.txtViewPosition+token.frame.size.width+5;
        self.xCor=self.txtViewPosition;
    }
    else{
        self.xCor=self.xCor+token.frame.size.width+5;
        self.txtViewPosition=self.txtViewPosition+token.frame.size.width+5;
    }
    if (self.txtViewPosition>self.innerScrView.frame.size.width-10) {
        self.txtAddress.frame=CGRectMake(5, token.frame.origin.y+token.frame.size.height+5, self.txtAddress.frame.size.width, self.txtAddress.frame.size.height);
    }
    else{
        self.txtAddress.frame=CGRectMake(self.txtViewPosition, token.frame.origin.y, self.txtAddress.frame.size.width, self.txtAddress.frame.size.height);
    }
    self.innerScrView.contentSize=CGSizeMake(self.innerScrView.frame.size.width, token.frame.origin.y+token.frame.size.height+5);
    if (token.frame.origin.y>=self.innerScrView.frame.size.height)
    {
        self.innerScrView.contentOffset=CGPointMake(0,self.txtAddress.center.y-90);
    }

    [self.arrayTextField addObject:token];
}


-(void)buttonTouchDown:(UIButton *)sender{
    [self.arrayTextField removeObject:sender];
    sender.selected=YES;
    sender.backgroundColor=[UIColor grayColor];
    [self.arrayTextField addObject:sender];
}

-(void)deleteButton:(UIButton *)sender{
    [sender removeFromSuperview];
    [self.arrayTextField removeObject:sender];
    NSArray * arraySubviews=[self.innerScrView subviews];
    [[self.innerScrView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (arraySubviews.count!=0) {
        UITextView *txtView;
        for (id object in arraySubviews) {
            if ([object isKindOfClass:[UIImageView class]]) {
                [self.innerScrView addSubview:object];
            }
            else if ([object isKindOfClass:[UITextView class]]){
                txtView=(UITextView *)object;
            }
        }
        BOOL isFirst=YES;
        CGRect rect;
        for (int i=0; i<self.arrayTextField.count; i++) {
            UIButton *btnToken=[self.arrayTextField objectAtIndex:i];
            if (((btnToken.frame.origin.x>sender.frame.origin.x)&&(btnToken.frame.origin.y>=sender.frame.origin.y))||((btnToken.frame.origin.x<=sender.frame.origin.x)&&(btnToken.frame.origin.y>sender.frame.origin.y))) {
                if (sender.frame.origin.x+btnToken.frame.size.width-sender.frame.size.width<self.innerScrView.frame.size.width-10) {
                    if (isFirst) {
                        if (self.innerScrView.frame.size.width-sender.frame.size.width+5<=self.innerScrView.frame.size.width-btnToken.frame.size.width+5) {
                            rect=CGRectMake(sender.frame.origin.x, sender.frame.origin.y, btnToken.frame.size.width, btnToken.frame.size.height);
                        }
                        else{
                            rect=btnToken.frame;
                        }
                        isFirst=NO;
                    }
                    else{
                        if (sender.frame.size.width+sender.frame.origin.x+5<=self.innerScrView.frame.size.width-btnToken.frame.size.width) {
                            rect=CGRectMake(sender.frame.origin.x+sender.frame.size.width+5, sender.frame.origin.y, btnToken.frame.size.width, btnToken.frame.size.height);
                        }
                        else{
                            rect=CGRectMake(5, sender.frame.origin.y+35, btnToken.frame.size.width, btnToken.frame.size.height);
                        }
                    }
                }
                else{
                    rect=CGRectMake(5, sender.frame.origin.y+35, btnToken.frame.size.width, btnToken.frame.size.height);
                }
                sender=btnToken;
                btnToken.frame=rect;
                [self.innerScrView addSubview:btnToken];
            }
            else{
                [self.innerScrView addSubview:btnToken];
            }
        }
        if (self.arrayTextField.count==0) {
            txtView.frame=CGRectMake(5, 5, 310, 30);
            self.innerScrView.contentSize=CGSizeMake(self.innerScrView.contentSize.width, 110);
            self.innerScrView.contentOffset=CGPointMake(0,0);
        }
        else{
            UIButton *lastButton=[self.arrayTextField lastObject];
            txtView.frame=CGRectMake(lastButton.frame.origin.x+lastButton.frame.size.width+5, lastButton.frame.origin.y, 310, 30);
            self.innerScrView.contentSize=CGSizeMake(self.innerScrView.contentSize.width, lastButton.frame.origin.y+lastButton.frame.size.height+10);
        }
        self.txtViewPosition=self.xCor=txtView.frame.origin.x;
        self.yPos=txtView.frame.origin.y;
        [self.innerScrView addSubview:txtView];
        [txtView becomeFirstResponder];
        
    }
}

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound )
	{
        const char * _char = [text cStringUsingEncoding:NSUTF8StringEncoding];
        int isBackSpace = strcmp(_char, "\b");
        
        if (isBackSpace == -8) {
            // is backspace
//            NSLog(@"Back Sapace Calling");
            if ([txtView.text isEqualToString:@""]) {
                if(self.arrayTextField.count!=0)
                {
                    UIButton *btnRemove=[self.arrayTextField lastObject];
                    if (btnRemove.selected==YES) {
                        [self deleteButton:btnRemove];
                    }
                    else{
                        [self.arrayTextField removeObject:btnRemove];
                        btnRemove.selected=YES;
                        btnRemove.backgroundColor=[UIColor grayColor];
                        [self.arrayTextField addObject:btnRemove];
                    }
                }
            }
        }

        return YES;
    }
    [txtView resignFirstResponder];
    [self.txtAddress setDelegate:self];
    self.innerScrView.contentSize=CGSizeMake(self.innerScrView.contentSize.width, self.arrayTextField.count * 35);
    self.scrView.contentOffset=CGPointMake(0, 0);
    return NO;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.scrView.contentOffset=CGPointMake(0, 0);
    if (self.txtAddress.text.length>0) {
        NSString *lastChar=[self.txtAddress.text substringFromIndex:[self.txtAddress.text length]-1];
        if ([lastChar isEqualToString:@","]) {
            self.txtAddress.text=[self.txtAddress.text substringToIndex:[self.txtAddress.text length]-1];
        }
    }
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
