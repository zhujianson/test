//
//  FeedbackViewController.m
//  bulkBuy1.0
//
//  Created by 徐国洪 on 13-10-22.
//  Copyright (c) 2013年 徐国洪. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CommonHttpRequest.h"
#import "Global.h"
#import "Global_Url.h"

#import "SSCheckBoxView.h"
#import "GetToken.h"
#import "LoadingAnimation.h"

@implementation FeedbackViewController
{
    BOOL _isRising;
    NSInteger sele_tag;
    int imageCount;
    UIView * imageBackView;
    //    UIScrollView * m_scroll;
    NSMutableArray * imageArr;
    CGFloat originY;
    BOOL  m_isLoading;;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"意见反馈", nil);
        _isRising = NO;
        self.log_pageID = 14;

    }
    return self;
}

//点击返回按钮返回主界面
- (void)LeftBarButtonItemPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if (_isRising == YES)
    {
        self.view.frame = CGRectMake(0, 64, kDeviceWidth, self.view.bounds.size.height);
        _isRising = NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    sele_tag = 100;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * typeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 45)];
    typeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:typeView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(15, typeView.bottom-0.25, kDeviceWidth-30, 0.5)];
    line.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
    [self.view addSubview:line];
    
    NSArray * arr = [NSArray arrayWithObjects:@"产品建议",@"设备使用问题",@"APP使用问题", nil];
    UIButton * btn;
    for (int i = 0; i<3; i++) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kDeviceWidth/3*i, 0, kDeviceWidth/3, typeView.height);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:[CommonImage colorWithHexString:@"666666"] forState:UIControlStateNormal];
        [typeView addSubview:btn];
        [btn setImage:[UIImage imageNamed:@"common.bundle/personnal/white_round.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"common.bundle/personnal/redcolor_round.png"] forState:UIControlStateSelected];
        if (i==1) {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0,-20,0.0,0.0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-13,0.0,0.0)];
        }else{
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0,-15,0.0,0.0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-8,0.0,0.0)];
        }
        [btn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchDown];
        if (!i) {
            btn.selected = YES;
        }
        btn.tag = 100+i;
    }
    
    
    [typeView release];
    
    m_textView = [[KXTextView alloc] initWithFrame:CGRectMake(15, typeView.bottom+5, kDeviceWidth-15*2, 230/2-5)];
    m_textView.backgroundColor = [UIColor clearColor];
    [m_textView setEditable:YES];
    m_textView.delegate = self;
    m_textView.returnKeyType = UIReturnKeyDone;
    m_textView.textColor = [CommonImage colorWithHexString:@"#333333"];
    m_textView.font = [UIFont systemFontOfSize:16];
    m_textView.placeholder = NSLocalizedString(@"在此输入您的意见", nil);
    m_textView.placeholderColor = [CommonImage colorWithHexString:@"#cccccc"];
    m_textView.placeHolderLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:m_textView];
    
    [m_textView becomeFirstResponder];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    m_butSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    m_butSubmit.frame = CGRectMake(15, 540/2, kDeviceWidth-15*2, 45);
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:The_ThemeColor]];
    [m_butSubmit setBackgroundImage:image forState:UIControlStateNormal];
    m_butSubmit.layer.cornerRadius = m_butSubmit.height/2;
    m_butSubmit.clipsToBounds = YES;
    [m_butSubmit setTitleColor:[CommonImage colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [m_butSubmit setTitle:NSLocalizedString(@"提交", nil) forState:UIControlStateNormal];
    m_butSubmit.titleLabel.font = [UIFont systemFontOfSize:18];
    //	m_butSubmit.enabled = NO;
    [m_butSubmit addTarget:self action:@selector(butSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_butSubmit];
    
    imageArr = [[NSMutableArray alloc]init];
    [self setImageWithDate:nil];
    
}

- (void)choose:(UIButton*)btn
{
    
    if (sele_tag == btn.tag && btn.selected) {
        return;
    }
    sele_tag = btn.tag;
    btn.selected = !btn.selected;
    UIButton*bon;
    for (int i = 0; i<3; i++) {
        if (i != btn.tag-100) {
            bon = (UIButton*)[self.view viewWithTag:100+i];
            bon.selected = NO;
        }
    }
    
}

- (void)butSubmit
{
    NSLog(@"%ld",(long)sele_tag);
    
    
    NSString *text = [m_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(text.length == 0){
        [Common TipDialog:@"请输入您的宝贵意见!"];
        return;
    }
    
    
    if([Common stringContainsEmoji:m_textView.text]){
        
        [Common TipDialog:NSLocalizedString(@"暂不支持表情信息", nil)];
        return;
    }
    
    NSString *titleString = [m_textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!titleString.length)
    {
        [Common TipDialog:NSLocalizedString(@"请输入您的意见!", nil)];
        return;
    }
    NSMutableArray * arr = [[[NSMutableArray alloc]init]autorelease];
    if (imageArr.count == 0) {
        [self setLoadingWithDic:nil Nsarry:arr Url:nil];
        return;
    }
    
    __block LoadingAnimation*loadViews = [[LoadingAnimation alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
    loadViews.center = CGPointMake(self.view.width/2, (self.view.height-40)/2);
    [self.view addSubview:loadViews];
    __block  NSMutableArray * arr2 = [[NSMutableArray alloc]init];
    for (int i = 0; i<imageArr.count; i++){
        UIImage * image = imageArr[i];
        if (!image) {
            break;
        }
        NSData *data = UIImageJPEGRepresentation(image, Define_picScale);
        [GetToken submitData:data withBlock:^(BOOL isOK,NSString*st) {
            NSLog(@"+++++++++++++++++++++++++++++++%@",st);
            [arr addObject:st];
            if (!isOK) {
                if (arr.count==imageArr.count) {
                    [loadViews stopAnimating];
                    [loadViews removeFromSuperview];
                    [loadViews release];
                    loadViews = nil;
                    [Common TipDialog2:@"图片上传失败，请检查网络是否正常!"];
                }else{
                    [arr2 addObject:st];
                }
            }else
                if (arr.count==imageArr.count) {
                    [loadViews stopAnimating];
                    [loadViews removeFromSuperview];
                    [loadViews release];
                    loadViews = nil;
                    
                    if (!arr2.count) {
                        [self setLoadingWithDic:nil Nsarry:arr Url:nil];
                    }else{
                        [Common TipDialog2:@"图片上传失败，请检查网络是否正常!"];
                    }
                    [arr2 release];
                }
        } withName:nil];
    }
    
}

- (void)setLoadingWithDic:(NSMutableDictionary*)posTData Nsarry:(NSArray*)arr Url:(NSString*)url
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:m_textView.text forKey:@"contents"];
    [dic setObject:arr forKey:@"picList"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)sele_tag-99] forKey:@"type"];
    [[CommonHttpRequest defaultInstance] sendNewPostRequest:FEEDBACK_BY_USERID values:dic requestKey:FEEDBACK_BY_USERID delegate:self controller:self actiViewFlag:1 title:NSLocalizedString(@"提交中", nil)];
    
}

#pragma mark -
#pragma mark UITextView Delegate Function
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( [text isEqualToString:@"\n"] )
        [textView resignFirstResponder];
    
    //    NSMutableString *changeString = [NSMutableString stringWithString:textView.text];
    //    [changeString replaceCharactersInRange:range withString:text];
    
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    }
    else {
        
        if (textView.text.length > 0) {
            m_butSubmit.enabled = YES;
            if (textView.text.length > 100)
                return NO;
        } else {
            m_butSubmit.enabled = NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
    }
    NSLog(@"%@", textView.text);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_isRising == NO && IS_4_INCH_SCREEN == NO)
    {
        if (kDeviceHeight<600) {
            self.view.frame = CGRectMake(0, -10, kDeviceWidth, self.view.bounds.size.height);
        }
        _isRising =YES;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self LeftBarButtonItemPressed];
}

- (void)didFinishFail:(ASIHTTPRequest *)loader
{
    
}


- (void)didFinishSuccess:(ASIHTTPRequest *)loader
{
    if ([loader.username isEqualToString:FEEDBACK_BY_USERID]) {
        
        NSString *responseString = [loader responseString];
        NSDictionary * dic = [responseString KXjSONValueObject];
        NSLog(@"%@",dic);
        NSDictionary * dict = dic[@"head"];
        if ([[dict objectForKey:@"state"] intValue])
        {
            [Common TipDialog:[dict objectForKey:@"msg"]];
            return;
        } else {
            
            MBProgressHUD *progress_ = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, self.view.frame.size.height)];
            progress_.labelText = @"谢谢您的宝贵意见！";
            progress_.mode = MBProgressHUDModeText;
            progress_.userInteractionEnabled = NO;
            [[[UIApplication sharedApplication].windows lastObject] addSubview:progress_];
            [progress_ show:YES];
            [progress_ showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [progress_ release];
                [progress_ removeFromSuperview];
            }];
            [self.navigationController popViewControllerAnimated:YES];
            
            //			UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"谢谢您的宝贵意见！", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
            //			[av show];
            //			[av release];
        }
    }
}

- (void)photo
{
    if (imageCount==MORE_PIICKER) {
        [Common TipDialog2:[NSString stringWithFormat:@"最多选择%d张图片",MORE_PIICKER]];
        return;
    }
    [m_textView resignFirstResponder];
    //    [self touchesBegan:nil withEvent:nil];
    
    ImagePicker *imagePicker = [[ImagePicker alloc]initWithId:self];
    imagePicker.sendTitle =  @"完成";
    imagePicker.selectHeadPhoto = NO;
    // 选择图片的最大数
    imagePicker.maxCount =MORE_PIICKER-imageCount;
    [imagePicker setPickerViewBlock:^(id content) {
        if ([content isKindOfClass:[NSArray class]])
        {
            [self actionWithAsstes:content];
            
        }else if ([content isKindOfClass:[UIImage class]])
        {
            UIImage * image = content;
            imageCount++;
            [self setImageWithDate:image];
        }
    }];
}

// 代理回调方法
- (void)actionWithAsstes:(NSArray *)assets{
    
    for (ALAsset * asset in assets)
    {
        if ([asset isKindOfClass:[ALAsset class]]) {
            imageCount++;
            //           UIImage * image = [UIImage imageWithCGImage:[asset thumbnail]];
            CGImageRef ref = [[asset  defaultRepresentation] fullScreenImage];
            UIImage *image = [UIImage imageWithCGImage:ref];
            [self setImageWithDate:image];
        }
    }
}

- (void)initImageCount
{
    imageCount = 1;
}

- (void)setImageWithDate:(UIImage*)imageData
{
    UILabel * lab = (UILabel*)[self.view viewWithTag:33];
    
    if (!imageBackView) {
        imageBackView = [[UIView alloc]initWithFrame:CGRectMake(15,m_textView.bottom, kDeviceWidth-30, 110)];
        imageBackView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:imageBackView];
        lab = [Common createLabel:CGRectMake(0, imageBackView.height-40, imageBackView.width, 40) TextColor:@"2fcd58" Font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentRight labTitle:@"1/4张"];
        [imageBackView addSubview:lab];
        lab.tag = 33;
    }else{
        imageBackView.hidden = NO;
    }
    //    lab.text = [NSString stringWithFormat:@"%d/4张",imageCount];
    lab.attributedText =[Common replaceRedColorWithNSString:[NSString stringWithFormat:@"%d/4张",imageCount] andUseKeyWord:@"/4张" andWithFontSize:15 TextColor:@"cccccc"];
    
    UIButton * addBtn = (UIButton*)[self.view viewWithTag:1100];
    if (!addBtn) {
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.tag = 1100;
        addBtn.frame = CGRectMake(0, 10, 60, 60);
        //        addBtn.backgroundColor = [CommonImage colorWithHexString:@"f2f2f2"];
        [addBtn setImage:[UIImage imageNamed:@"common.bundle/diary/diaryAdd.png"] forState:UIControlStateNormal];
        
        [addBtn addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
        [imageBackView addSubview:addBtn];
    }
    if (!imageData) {
        return;
    }
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:addBtn.frame];
    imageView.image = imageData;
    imageView.userInteractionEnabled = YES;
    imageView.tag = 400+imageCount;
    [imageBackView addSubview:imageView];
    [imageView release];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizerHandle:)];
    tap.view.tag = imageView.tag+55;
    [imageView addGestureRecognizer:tap];
    [tap release];
    
    
    [imageArr addObject:imageView.image];
    
    //删除图片
    UIButton * Reduction  = [UIButton buttonWithType:UIButtonTypeCustom];
    Reduction.frame = CGRectMake(imageView.right-10, imageView.top-10, 20, 20);
    [Reduction setImage:[UIImage imageNamed:@"common.bundle/diary/dairy_content_icon_delete.png"] forState:UIControlStateNormal];
    [Reduction addTarget:self action:@selector(Reduction:) forControlEvents:UIControlEventTouchUpInside];
    Reduction.tag = 300+imageCount;
    [imageBackView addSubview:Reduction];
    
    //    if (imageCount==4) {
    //        addBtn.frame = [Common rectWithOrigin:addBtn.frame x:WEIGHT_CLEARANCE y:40+WEIGHT_CLEARANCE+60];
    //    }else if(imageCount==8){
    //        addBtn.frame = [Common rectWithOrigin:addBtn.frame x:WEIGHT_CLEARANCE y:40+(WEIGHT_CLEARANCE+60)*2];
    //    }else
    if (imageCount==MORE_PIICKER) {
        addBtn.hidden = YES;
    }
    addBtn.frame = [Common rectWithOrigin:addBtn.frame x:imageView.right+WEIGHT_CLEARANCE y:0];
    
}

- (void)Reduction:(UIButton*)btn
{
    UIImageView*image = (UIImageView*)[self.view viewWithTag:btn.tag+100];
    [btn removeFromSuperview];
    [imageArr removeObject:image.image];
    [image removeFromSuperview];
    
    CGFloat x,y,z;
    UIButton * remoBtn;
    for (int i=(int)btn.tag+100;i<btn.tag+imageCount+100; i++) {
        image = (UIImageView*)[self.view viewWithTag:i+1];
        if (image) {
            remoBtn = (UIButton*)[self.view viewWithTag:image.tag-100];
            x = kDeviceWidth-image.size.width-WEIGHT_CLEARANCE;
            y = image.origin.y-image.size.width-WEIGHT_CLEARANCE;
            z = image.origin.x-image.size.width-WEIGHT_CLEARANCE;
            if (image.origin.x==WEIGHT_CLEARANCE) {
                image.frame = [Common rectWithOrigin:image.frame x:x+0.01 y:y];
            }else{
                image.frame = [Common rectWithOrigin:image.frame x:z+0.01 y:0];
            }
            remoBtn.frame = [Common rectWithOrigin:remoBtn.frame x:image.right-10 y:image.top-10];
            image.tag = i;
            remoBtn.tag = i - 100;
        }else{
            break;
        }
    }
    
    imageCount--;
    UILabel * lab = (UILabel*)[self.view viewWithTag:33];
    lab.attributedText =[Common replaceRedColorWithNSString:[NSString stringWithFormat:@"%d/4张",imageCount] andUseKeyWord:@"/4张" andWithFontSize:15 TextColor:COLOR_999999];
    UIButton * addBtn = (UIButton*)[self.view viewWithTag:1100];
    x = kDeviceWidth-addBtn.size.width-WEIGHT_CLEARANCE;
    y = addBtn.origin.y-addBtn.size.width-WEIGHT_CLEARANCE;
    z = addBtn.origin.x-addBtn.size.width-WEIGHT_CLEARANCE;
    addBtn.hidden = NO;
    
    CGFloat time = 0.3f;
    if (imageCount == 3) {
        time = 0;
    }
    [UIView animateWithDuration:time animations:^{
        addBtn.frame = [Common rectWithOrigin:addBtn.frame x:z+0.01 y:0];
    }];
    
}

#pragma mark 切换动画

- (void)gestureRecognizerHandle:(UITapGestureRecognizer*)image
{
    NSLog(@"%ld",(long)image.view.tag);
    // 1.封装图片数据
    NSMutableArray *photos = [[NSMutableArray alloc]init];
    for (int i= 0;i<imageCount;i++)
    {
        UIImageView *imgeView = (UIImageView*)[self.view viewWithTag:401+i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.srcView = imgeView; // 来源于哪个UIImageView
        [photos addObject:photo];
        [photo release];
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.delegate = self;
    browser.currentPhotoIndex = image.view.tag-401; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    [browser release];
    [photos release];
}

- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index;
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [m_textView release];
    [imageBackView release];
    [imageArr release];
    [super dealloc];
}

@end