//
//  FoodRecordViewController.m
//  jiuhaohealth3.0
//
//  Created by xjs on 15-1-17.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#import "FoodRecordViewController.h"
#import "SugarListViewController.h"
#import "AppDelegate.h"
#import "DBOperate.h"
#import "OneCategoryListViewController.h"
#import "SugarDetailViewController.h"
#import "EScrollerView.h"
#import "FoodRecordViewController.h"
#import "ImagePicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PerfectViewController.h"
#import "ShowConsultViewController.h"

@interface FoodRecordViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@end

@implementation FoodRecordViewController
{
    UIScrollView * scroll;
    NSMutableDictionary * imageDic;
    int  allowPickerImgeCount;
    BOOL m_isFrist;
}
- (void)dealloc
{
    [scroll release];
    [imageDic release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.log_pageID = 150;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageDic = [[NSMutableDictionary alloc]init];
    
    UIView * textView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kDeviceWidth, 40)];
    textView.backgroundColor = [UIColor whiteColor];
    
    UITextField * textF = [Common createTextField:@"请输入菜名或食材" setDelegate:self setFont:14];
    textF.tag = 119;

    textF.delegate = self;
    textF.frame = CGRectMake(10, 0, kDeviceWidth-20, 40);
    [textView addSubview:textF];
    [self.view addSubview:textView];
    [textView release];
    
    UIView * lineView;
    for (int i = 0; i<2; i++) {
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, (textF.origin.y-0.25)+textF.height*i, kDeviceWidth, 0.5)];
        lineView.backgroundColor = [CommonImage colorWithHexString:LINE_COLOR];
        [textView addSubview:lineView];
        [lineView release];
    }

    
    scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, textView.bottom, kDeviceWidth, kDeviceHeight - textView.bottom)];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.showsVerticalScrollIndicator = NO;
    scroll.delegate = self;
    [self.view addSubview:scroll];
    
    allowPickerImgeCount = 0;
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.tag = 1101;
    addBtn.frame = CGRectMake(10, 10, (kDeviceWidth-30)/2, 100*kDeviceWidth/320);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"common.bundle/diary/addImageButton.png"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:addBtn];

    UIButton * save = [UIButton buttonWithType:UIButtonTypeCustom];
    save.tag = 188;
    save.frame = CGRectMake(10, addBtn.bottom+addBtn.height+10, kDeviceWidth-20, 44);
    [save setTitle:@"问医生" forState:UIControlStateNormal];
    [save addTarget:self action:@selector(butEventSave) forControlEvents:UIControlEventTouchUpInside];
    save.layer.cornerRadius = 4;
    save.clipsToBounds = YES;
    UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
    [save setBackgroundImage:image forState:UIControlStateNormal];
    [scroll addSubview:save];
    scroll.contentSize = CGSizeMake(0, save.bottom+20);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!m_isFrist) {
        [self addImage];
        m_isFrist = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITextField * textF = (UITextField*)[self.view viewWithTag:119];
    [textF resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)butEventSave
{
    UITextField * textF = (UITextField*)[self.view viewWithTag:119];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if ([textF.text length]) {
        [dic setObject:textF.text forKey:@"text"];
    }
    if ([imageDic count]) {
        NSArray * imageArr = [imageDic allValues];
        [dic setObject:imageArr forKey:@"image"];
    }
//    FriendListViewController * show = [[FriendListViewController alloc]init];
//    if ([dic count]) {
//        show.FoodImageDic = dic;
//    }
//    [self.navigationController pushViewController:show animated:YES];
//    [show release];
}

- (void)addImage
{
    ImagePicker *imagePicker = [[ImagePicker alloc]initWithId:self];
    imagePicker.sendTitle = @"完成";
    imagePicker.selectHeadPhoto = NO;
    // 选择图片的最大数
    imagePicker.maxCount = 6-allowPickerImgeCount;
    [imagePicker setPickerViewBlock:^(id content) {
        if ([content isKindOfClass:[NSArray class]])
        {
            [self actionWithAsstes:content];
        }
        else if ([content isKindOfClass:[UIImage class]])
        {
            UIImage *image = content;
            
            //缩略图
//            UIImage *imageIcon = [Common zoomImage:image toScale:CGSizeMake(80, 80)];
//            NSData *data = UIImagePNGRepresentation(imageIcon);
//            NSString *strTest = [strCon stringByAppendingString:m_OperationQueue.pathSuffix];
//            strTest = [strTest stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//            NSString *strCon1 = [[Common getImagePath] stringByAppendingFormat:@"/%@", strTest];
//            [data writeToFile:strCon1 atomically:YES];
//            [self addMessage:dic isLishi:is];
            
            UIButton * btn = (UIButton*)[self.view viewWithTag:1101];
            UIImageView * pickerImage = [[UIImageView alloc] initWithFrame:btn.frame];
            pickerImage.contentMode = UIViewContentModeScaleAspectFill;
            pickerImage.image = image;
            pickerImage.clipsToBounds = YES;
            pickerImage.userInteractionEnabled = YES;
            [scroll addSubview:pickerImage];
            
            UIButton * Reduction  = [UIButton buttonWithType:UIButtonTypeCustom];
            Reduction.frame = CGRectMake(pickerImage.width-30, 0, 30, 30);
            [Reduction setImage:[UIImage imageNamed:@"common.bundle/diary/dairy_content_icon_delete.png"] forState:UIControlStateNormal];
            [Reduction addTarget:self action:@selector(Reduction:) forControlEvents:UIControlEventTouchUpInside];
            Reduction.tag = 300+allowPickerImgeCount;
            [imageDic setObject:image forKey:[NSString stringWithFormat:@"%d",(int)Reduction.tag]];
            
            pickerImage.tag = 400+allowPickerImgeCount;
            [pickerImage addSubview:Reduction];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizerHandle:)];
            tap.view.tag = pickerImage.tag+55;
            [pickerImage addGestureRecognizer:tap];
            [tap release];

            [pickerImage release];
            //
            CGRect rect = btn.frame;
            if (btn.frame.origin.x == 10) {
                rect.origin.x = pickerImage.width+20;
                rect.origin.y = pickerImage.origin.y;
                btn.frame = rect;
            }else{
                if (allowPickerImgeCount == 6-1) {
                    btn.hidden = YES;
                }else{
                    rect.origin.x = 10;
                    rect.origin.y = pickerImage.origin.y+pickerImage.height+10;
                    btn.frame = rect;
                    UIButton * save = (UIButton*)[self.view viewWithTag:188];
                    
                    save.frame = [Common rectWithOrigin:save.frame x:0 y:btn.bottom+btn.height+10];
                    scroll.contentSize = CGSizeMake(0, save.bottom+20);
                }
            }
            allowPickerImgeCount++;

        }
    }];
}

// 代理回调方法
- (void)actionWithAsstes:(NSArray *)assets{
    
    for (ALAsset *asset in assets)
    {
        if ([asset isKindOfClass:[ALAsset class]]) {
            //           UIImage * image = [UIImage imageWithCGImage:[asset thumbnail]];
            CGImageRef ref = [[asset  defaultRepresentation] fullScreenImage];
            UIImage *image = [UIImage imageWithCGImage:ref];
            UIButton * btn = (UIButton*)[self.view viewWithTag:1101];
            UIImageView * pickerImage = [[UIImageView alloc]initWithFrame:btn.frame];
            pickerImage.contentMode = UIViewContentModeScaleAspectFill;
            pickerImage.clipsToBounds = YES;
            pickerImage.image = image;
            pickerImage.userInteractionEnabled = YES;
            [scroll addSubview:pickerImage];
            UIButton * Reduction  = [UIButton buttonWithType:UIButtonTypeCustom];
            Reduction.frame = CGRectMake(pickerImage.width-30, 0, 30, 30);
            [Reduction setImage:[UIImage imageNamed:@"common.bundle/diary/dairy_content_icon_delete.png"] forState:UIControlStateNormal];
            [Reduction addTarget:self action:@selector(Reduction:) forControlEvents:UIControlEventTouchUpInside];
            Reduction.tag = 300+allowPickerImgeCount;
            [imageDic setObject:asset forKey:[NSString stringWithFormat:@"%ld",(long)Reduction.tag]];
            
            pickerImage.tag = 400+allowPickerImgeCount;
            [pickerImage addSubview:Reduction];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognizerHandle:)];
            tap.view.tag = pickerImage.tag+55;
            [pickerImage addGestureRecognizer:tap];
            [tap release];

            [pickerImage release];
            //
            CGRect rect = btn.frame;
            if (btn.frame.origin.x == 10) {
                rect.origin.x = pickerImage.width+20;
                rect.origin.y = pickerImage.origin.y;
                btn.frame = rect;
            }else{
                if (allowPickerImgeCount == 6-1) {
                    btn.hidden = YES;
                }else{
                    rect.origin.x = 10;
                    rect.origin.y = pickerImage.origin.y+pickerImage.height+10;
                    btn.frame = rect;
                    UIButton * save = (UIButton*)[self.view viewWithTag:188];
                    save.frame = [Common rectWithOrigin:save.frame x:0 y:btn.bottom+btn.height-30];
                    scroll.contentSize = CGSizeMake(0, save.bottom+20);
                }
            }
            allowPickerImgeCount++;
        }
    }
}

//删除图片
- (void)Reduction:(UIButton*)btn
{
    [imageDic removeObjectForKey:[NSString stringWithFormat:@"%d",(int)btn.tag]];
    
    UIImageView*image = (UIImageView*)[self.view viewWithTag:btn.tag+100];
    [btn removeFromSuperview];
    [image removeFromSuperview];
    
    UIButton * remoBtn;
    for (int i=btn.tag+100;i<btn.tag+allowPickerImgeCount+100; i++) {
        image = (UIImageView*)[self.view viewWithTag:i+1];
        if (image) {
            remoBtn = (UIButton*)[image viewWithTag:image.tag-100];
            CGRect rect = image.frame;
            if (image.origin.x==10) {
                rect.origin.x = image.size.width+20;
                rect.origin.y = image.origin.y - image.height - 10;
                image.frame = rect;
            }else{
                rect.origin.x = 10;
                image.frame = rect;
            }
            image.tag = i;
            remoBtn.tag = i - 100;
        }else{
            break;
        }
    }
    [self setMoveAddButton];
}

//移动添加按钮
- (void)setMoveAddButton
{
    UIButton * add = (UIButton*)[self.view viewWithTag:1101];
    if (add.hidden) {
        add.hidden = NO;
    }else{
        CGRect rect = add.frame;
        if (add.origin.x==10) {
            rect.origin.x = add.size.width+20;
            rect.origin.y = add.origin.y - add.height - 10;
            add.frame = rect;
        }else{
            rect.origin.x = 10;
            add.frame = rect;
            UIButton * save = (UIButton*)[self.view viewWithTag:188];
            save.frame = [Common rectWithOrigin:save.frame x:0 y:add.bottom+add.height-30];
            scroll.contentSize = CGSizeMake(0, save.bottom+20);
        }
    }
    allowPickerImgeCount--;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    UITextField * textF = (UITextField*)[self.view viewWithTag:119];
    [textF resignFirstResponder];
}

//- (void)gestureRecognizerHandle:(UITapGestureRecognizer*)image
//{
//    NSLog(@"%d", image.view.tag);
//    UIImageView * imageV = (UIImageView*)[self.view viewWithTag:image.view.tag];
//    [self showImage:imageV];
//}
//
//- (void)showImage:(UIImageView*)avatarImageView
//{
//    UIImage* image = avatarImageView.image;
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
//    backgroundView.backgroundColor = [UIColor blackColor];
//    backgroundView.alpha = 0;
//    UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:oldframe];
//    imageView1.image = image;
//    imageView1.tag = 1;
//    [backgroundView addSubview:imageView1];
//    [window addSubview:backgroundView];
//    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
//    [backgroundView addGestureRecognizer:tap];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView1.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
//        backgroundView.alpha=1;
//    } completion:^(BOOL finished) {}];
//    [backgroundView release];
//    [imageView1 release];
//    [tap release];
//}
//
//- (void)hideImage:(UITapGestureRecognizer*)tap
//{
//    UIView* backgroundView = tap.view;
//    UIImageView* imageView1 = (UIImageView*)[tap.view viewWithTag:1];
//    [UIView animateWithDuration:0.3 animations:^{
//        imageView1.frame=oldframe;
//        backgroundView.alpha=0;
//    } completion:^(BOOL finished) {
//        [backgroundView removeFromSuperview];
//    }];
//}

#pragma mark 切换动画

- (void)gestureRecognizerHandle:(UITapGestureRecognizer*)image
{
//    NSLog(@"%d", image.view.tag);
    int index;
    // 1.封装图片数据
    NSMutableArray *photos = [[NSMutableArray alloc]init];
    index =  400;
    for (int i= 0;i<allowPickerImgeCount;i++)
    {
        NSMutableDictionary *dicPhoto = [[NSMutableDictionary alloc] init];
//        [dicPhoto setObject:dicItem[@"reportUrl"] forKey:@"url"];
        UIImageView *imgeView = (UIImageView*)[self.view viewWithTag:index+i];
        [dicPhoto setObject:imgeView forKey:@"srcImageView"];
        [photos addObject:dicPhoto];
        [dicPhoto release];
        
//        MJPhoto *photo;
//        // 替换为中等尺寸图片
//        photo = [[MJPhoto alloc] init];
////        photo.firstShow = YES;
        UIImageView *imgeView2 = (UIImageView*)[self.view viewWithTag:index+i];
//        photo.srcImageView = imgeView2; // 来源于哪个UIImageView
//        [photos addObject:photo];
//        [photo release];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.url = [NSURL URLWithString:imagePath]; // 图片路径
        photo.srcView = imgeView2; // 来源于哪个UIImageView
        [photos addObject:photo];
        [photo release];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.delegate = self;
    browser.currentPhotoIndex = image.view.tag-400; // 弹出相册时显示的第一张图片是？
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
