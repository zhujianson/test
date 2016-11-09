//
//  SugarDetailViewController.m
//  jiuhaohealth2.1
//
//  Created by wangmin on 14-8-15.
//  Copyright (c) 2014年 xuGuohong. All rights reserved.
//

#import "SugarDetailViewController.h"
#import "ImageTableViewCell.h"
#import "ListTableViewCell.h"
#import "TextTableViewCell.h"
#import "RecommendTableViewCell.h"
#import "DBOperate.h"
#import "FoodRestraintTableViewCell.h"


@interface SugarDetailViewController ()
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *detailTableView;
    NSArray *sectionArray;
    NSMutableArray *detailArray;
    DBOperate *myDataBase;
    BOOL hasFoodRestraintFlag;
    __block UIView *tipsView;//解释view
}
@end

@implementation SugarDetailViewController

-(void)dealloc
{
    self.key = nil;
    [detailTableView release];
    [detailArray release];
    [super dealloc];

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.log_pageID = 13;

        sectionArray = @[@"评价",@"营养成分(每100克)",@"菜谱用料",@"制作步骤"];//不用了
        detailArray = [[NSMutableArray alloc] initWithCapacity:0];
        myDataBase = [DBOperate shareInstance];
        hasFoodRestraintFlag = YES;
        
//        UIBarButtonItem *rightButtonItem = [Common createNavBarButton:self setEvent:@selector(goToShare) withNormalImge:@"common.bundle/nav/top_share_icon_nor.png" andHighlightImge:@"common.bundle/nav/top_share_icon_pre.png"];
//        self.navigationItem.rightBarButtonItem = rightButtonItem;
        
    }
    return self;
}

-(BOOL)closeNowView
{
    [tipsView removeFromSuperview];
    return [super closeNowView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT-44)];
    detailTableView.dataSource = self;
    detailTableView.delegate = self;
    detailTableView.backgroundColor = [CommonImage colorWithHexString:VERSION_BACKGROUD_COLOR];
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:detailTableView];
    [detailTableView release];
    
    [self createTips];
    [self getDataArray];
    
//    NSDictionary *imageDic = @{@"title":@"  评价",@"imageName": @"food.png",@"value1":@"80",@"value2":@"20",@"value3":@"-0.2"};
//    [detailArray addObject:imageDic];
//    NSDictionary *listDic1 = @{@"title":@"营养成分(每100克)",@"维生素A": @"2.5克",@"热量":@"52千卡",@"蛋白质":@"5克"};
//    [detailArray addObject:listDic1];
//  
//    NSArray *keyArray2 = @[@"title",@"西红柿",@"鸡蛋"];
//    NSArray *valueArray2 = @[@"菜谱用料",@"200g/2个",@"600g/3个"];
//    NSArray *array2 = @[keyArray2,valueArray2];
//    [detailArray addObject:array2];
//    
////    self.ismenu = YES;
//    if(self.ismenu){
//        
//        NSDictionary *one = @{@"title": @"推荐菜谱"};
//        NSDictionary *two = @{@"image": @"food.png",@"name":@"西红柿炒鸡蛋"};
//        NSDictionary *three = @{@"image": @"food.png",@"name":@"西红柿牛腩"};
//        NSArray *array3 = @[one,two,three];
//        [detailArray addObject:array3];
//        
//    }else{
//        NSArray *keyArray3 = @[@"制作步骤",@"A.双手支撑身体，双臂垂直于地面，两腿向身体后方伸展，依靠双手和两个脚的脚尖保持平衡，保持头、脖子、后背、臀部以及双腿在一条直线上动作重点：全身挺直，平起平落。",@"B.两个肘部向身体外侧弯曲，身体降低到基本靠近地板。收紧腹部，保持身体在一条直线上，持续一秒钟，然后恢复原状。"];
//    [detailArray addObject:keyArray3];
//    }
//    [detailTableView reloadData];
//    [self setExtraCellLineHidden:detailTableView];

  
    
}

- (void)createTips
{
    tipsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    tipsView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [APP_DELEGATE addSubview:tipsView];
    [tipsView release];
    tipsView.alpha = 0;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [tipsView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(24, (tipsView.size.height-375)/2, kDeviceWidth-24*2, 375)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 8.0f;
    [tipsView addSubview:whiteView];
    [whiteView release];
    
    UIImage *image = [UIImage imageNamed:@"common.bundle/common/search_close_icon_nor.png"];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(kDeviceWidth-24*2-40, 5, 40, 40);
    [closeBtn setImage:image forState:UIControlStateNormal];
    [closeBtn setImage:[UIImage imageNamed:@"common.bundle/common/search_close_icon_pre.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeBtn];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(24+25, whiteView.origin.y+30, kDeviceWidth-24*2-25*2, tipsView.size.height-2*whiteView.origin.y-60)];
    scrollView.backgroundColor = [UIColor clearColor];
    [tipsView addSubview:scrollView];
    [scrollView release];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.size.width, 17)];
    titleLabel.text = @"什么是血糖风险指数?";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [scrollView addSubview:titleLabel];
    [titleLabel release];
    
    NSString *strings = @"    老张和老王是小学同学，20年后再次相遇，他们激动万分，决定一起去就近的餐馆吃一顿，聊聊这几年的经历。\n    老张高中毕业后开始白手起家弄起了餐饮业，身为老板兼厨师的他，钱包和腰围都一天天增加，直到现在身高170，体重100kg，腰围达到了100cm，5年前被确诊了糖尿病和脂肪肝；\n    老王考入了体校，毕业后顺利成为了一名游泳运动员，一直保持着较健康的身体，现在身高176，体重70kg，腰围75cm，各项体检指标均在正常范围。\n    聊到这几年的经历，正好老张身上带有一个便携式血糖仪，两人决定做一个实验：老张半小时前服用过降糖药，测了空腹血糖5.0，老王测了空腹血糖也是5.0，两人点了XXXX,XXXX两个菜（升糖风险指数均为XXX），且食量相当，餐后两小时再次测量血糖，老张血糖达到了10.3，但老王血糖只达到7.5。\n    这是为什么呢？糖查查血糖小管家提示您：升糖风险指数仅代表了不同食物之间短时间升高血糖的相对评估值，真实升高血糖值因人的年龄、性别、体重指数、血糖值和糖尿病病史、服用药物等因素而异。";
    CGSize stringSize = [self getSizeWithString:strings font:[UIFont systemFontOfSize:15.0f] constrainSize:CGSizeMake(scrollView.size.width, 1000)];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, scrollView.size.width, stringSize.height)];
    contentLabel.text = strings;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15.0f];
    [scrollView addSubview:contentLabel];
    [contentLabel release];
    scrollView.contentSize = CGSizeMake(scrollView.size.width, stringSize.height+20);
    
}


- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font constrainSize:(CGSize)constrsize
{
    CGSize size = [string sizeWithFont:font constrainedToSize:constrsize lineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail];
    return size;
}

- (void)closeView:(id)sender
{
    tipsView.alpha = 0;
}


/**
 *  获得数据源
 */
- (void)getDataArray {
    //异步中同步获取，主线程回调刷新---待完善
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *sql = nil;
        NSArray *resultArray = nil;
        
        if(self.ismenu){
            sql = [NSString stringWithFormat:@"SELECT TCC_DISHES.img,\
                   TCC_DISHES.GI,\
                   TCC_DISHES.GL_100G,\
                   TCC_DISHES.PRACTICE,\
                   TCC_DISHES.kilocalorie,\
                   TCC_DISHES.protein,\
                   TCC_DISHES.fat,\
                   TCC_DISHES.carbohydrate,\
                    group_concat(TCC_D2I.INGREDIENTS,'|')  ingredients,\
                   group_concat(TCC_D2I.GRAM,'|') gram\
                FROM TCC_DISHES LEFT JOIN TCC_D2I ON TCC_DISHES.ID = TCC_D2I.DISHES_ID\
                   WHERE TCC_DISHES.ID = '%@'",self.key];
            resultArray = [myDataBase getDataForSQL:sql getParam:@[@"img",@"kilocalorie",@"protein",@"fat",@"carbohydrate",@"GI",@"GL_100G", @"PRACTICE",@"ingredients",@"gram"]];
        }else{
            sql = [NSString stringWithFormat:@"SELECT TCC_INGREDIENTS.img,\
                TCC_INGREDIENTS.kilocalorie,\
                TCC_INGREDIENTS.protein,\
                TCC_INGREDIENTS.fat,\
                TCC_INGREDIENTS.carbohydrate,\
                TCC_INGREDIENTS.GI,\
                TCC_INGREDIENTS.GL_100G,\
                group_concat(TCC_IR.restriction,'|') restrictions,\
                group_concat(TCC_IR.REASON,'|') reasons,\
                group_concat(TCC_RE.DISHES_ID,'|') dishesId,\
                group_concat(TCC_RE.DISHES,'|') dish,\
                group_concat(TCC_DISHES.img,'|') dishimg\
                FROM ((TCC_INGREDIENTS LEFT JOIN TCC_IR ON TCC_INGREDIENTS.id = TCC_IR.INGREDIENTS_ID) LEFT JOIN TCC_RE ON TCC_INGREDIENTS.id = TCC_RE.INGREDIENTS_ID) LEFT JOIN TCC_DISHES ON TCC_RE.DISHES_ID = TCC_DISHES.ID\
                   WHERE TCC_INGREDIENTS.id = '%@'",self.key];
            resultArray = [myDataBase getDataForSQL:sql getParam:@[@"img",@"kilocalorie",@"protein",@"fat",@"carbohydrate",@"GI",@"GL_100G",@"restrictions",@"reasons",@"dishesId",@"dish",@"dishimg"]];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{

            NSDictionary *resultDic = resultArray.count ? resultArray[0]:nil;
            
            //营养成分字典
//            NSMutableDictionary *nutritionalDic = [NSMutableDictionary dictionaryWithCapacity:0];
//            [nutritionalDic setObject:@"title" forKey:@"营养成分(每100克)"];
            NSMutableArray *keyArray1 = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *valueArray1 = [NSMutableArray arrayWithCapacity:0];

            
            //菜谱--食物
            NSMutableArray *keyArray2 = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *valueArray2 = [NSMutableArray arrayWithCapacity:0];
            
            NSString *hotValueString = @"";
            NSString *riseSugarString = resultDic[@"GI"];
            riseSugarString = riseSugarString.length ? riseSugarString : @"0.0";
            NSString *bloodSugarIndic = [NSString stringWithFormat:@"%.1f",[resultDic[@"GL_100G"] floatValue]];
            
            if(self.ismenu){
            //食谱
                [keyArray1 addObject:@"title"];
                [valueArray1 addObject:@"营养成分(每100克)"];
                //由于库中无营养元素 添加假数据
                //热量
                if([resultDic[@"kilocalorie"] length]){
                    [keyArray1 addObject:@"热量"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%d千卡",[resultDic[@"kilocalorie"] intValue]]];
                    hotValueString = [NSString stringWithFormat:@"%d",[resultDic[@"kilocalorie"] intValue]];
                }
                
                //蛋白质
                if([resultDic[@"protein"] length]){
                    [keyArray1 addObject:@"蛋白质"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%@克",resultDic[@"protein"]]];
                }
                
                //脂肪
                if([resultDic[@"fat"] length]){
                    [keyArray1 addObject:@"脂肪"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%@克",resultDic[@"fat"]]];
                }
                
                //碳水化合物
                if([resultDic[@"carbohydrate"] length]){
                    [keyArray1 addObject:@"碳水化合物"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%@克",resultDic[@"carbohydrate"]]];
                }else{
                    [keyArray1 addObject:@"碳水化合物"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%@克",@"0.0"]];
                }
                
                //添加标题
                [keyArray2 addObject:@"title"];
                [valueArray2 addObject:@"菜谱用料"];
                
            }else{
           
                //食材添加营养成分
                [keyArray1 addObject:@"title"];
                [valueArray1 addObject:@"营养成分(每100克)"];
//                //营养元素
//                [keyArray1 addObject:@"营养元素"];
//                [valueArray1 addObject:@"单位:100克"];
                //热量
                if([resultDic[@"kilocalorie"] length]){
                    [keyArray1 addObject:@"热量"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%d千卡",[resultDic[@"kilocalorie"] intValue]]];
                     hotValueString = [NSString stringWithFormat:@"%d",[resultDic[@"kilocalorie"] intValue]];
                }

                //蛋白质
                if([resultDic[@"protein"] length]){
                    [keyArray1 addObject:@"蛋白质"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%@克",resultDic[@"protein"]]];
                }

                //脂肪
                if([resultDic[@"fat"] length]){
                    [keyArray1 addObject:@"脂肪"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%@克",resultDic[@"fat"]]];
                }

                //碳水化合物
                if([resultDic[@"carbohydrate"] length]){
                    [keyArray1 addObject:@"碳水化合物"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%@克",resultDic[@"carbohydrate"]]];
                }else{
                    [keyArray1 addObject:@"碳水化合物"];
                    [valueArray1 addObject:[NSString stringWithFormat:@"%@克",@"0.0"]];
                }

                //相克食物名
                NSString *restrictionsString = resultDic[@"restrictions"];
                //相克食物原因
                NSString *reasonsString = resultDic[@"reasons"];
//                NSString *reasonsString =  [myDataBase decryptionWithStr:resultDic[@"reasons"]];
                
                [keyArray2 addObject:@"title"];
                [valueArray2 addObject:@"食物相克"];
                
                NSArray *restrictionsArray = [restrictionsString componentsSeparatedByString:@"|"];
                NSArray *resonsArray = [reasonsString componentsSeparatedByString:@"|"];
                
                if(restrictionsString.length){
                    hasFoodRestraintFlag = YES;
//                    [keyArray2 addObjectsFromArray:restrictionsArray];
//                    [valueArray2 addObjectsFromArray:resonsArray];
                    for(int i = 0; i < restrictionsArray.count; i++){
                        NSString *key = restrictionsArray[i];
                        if(![keyArray2 containsObject:key]){
                            [keyArray2 addObject:key];
                            [valueArray2 addObject:[myDataBase decryptionWithStr:resonsArray[i]]];
                        }
                    }
                
                }else{
                
                    hasFoodRestraintFlag = NO;
                }
                
//                
//                
//                [keyArray2 addObject:@"西红柿"];
//                [valueArray2 addObject:@"数据有问题"];
//                hasFoodRestraintFlag = NO;
                
            }
            
            NSString *dishesIdString = nil;//菜谱id
            NSString *dishNameString = nil;//菜谱名字
            NSString *dishImgString = nil;//菜谱图片
            
            
            NSString *ingredientsString = nil;//菜谱用料
            NSString *ingredientsGramString = nil;//菜谱用料克数
            NSString *PRACTICEString = nil;//制作方法
            
            if(self.ismenu){
                //食谱
                for(NSString *key in resultDic.allKeys){
                 if ([key isEqualToString:@"ingredients"]){
                        //食材
                        NSString *value = resultDic[key];
                        if(value.length){
                            ingredientsString = value;
                        }
                 }else if ([key isEqualToString:@"gram"]){
                         //克数
                         NSString *value = resultDic[key];
                         if(value.length){
                             ingredientsGramString = value;
                         }
                 
                 }else if ([key isEqualToString:@"PRACTICE"]){
                        //制作方法
                        NSString *value = resultDic[key];
                        if(value.length){
                            PRACTICEString = value;
                        }
                    }else if([key isEqualToString:@"GI"]){
                        //升糖指数
                        
                    }else{
//                        //营养成分
//                        NSString *value = resultDic[key];
//                        if(value.length){
//                            //有值
//                            [keyArray1 addObject:NSLocalizedString(key, @"")];
//                            [valueArray1 addObject:value];
//                        }
                    }
                }
            }else{
            //食材
                for(NSString *key in resultDic.allKeys){
                    if ([key isEqualToString:@"dishesId"]){
                        //菜id
                        NSString *value = resultDic[key];
                        if(value.length){
                            dishesIdString = value;
                        }
                    }else if ([key isEqualToString:@"dish"]){
                        //菜名
                        NSString *value = resultDic[key];
                        if(value.length){
                            dishNameString = value;
                        }
                    }else if([key isEqualToString:@"GI"]){
                        //升糖指数
                        
                    }else if ([key isEqualToString:@"dishimg"]){
                        //菜图片
                        NSString *value = resultDic[key];
                        if(value.length){
                            dishImgString = value;
                        }
                    }else{
//                        //营养成分
//                        NSString *value = resultDic[key];
//                        if(value.length){
//                            //有值
//                            [keyArray1 addObject:NSLocalizedString(key, @"")];
//                            [valueArray1 addObject:value];
//                        }
                    }
                }
            }
           
            NSLog(@"----9.3<10:%d",(9.3<10));
            
            NSString *levelString = nil;
            if([bloodSugarIndic floatValue] <= 10){
                levelString = NSLocalizedString(@"宜食", @"");
            }else if([bloodSugarIndic floatValue] >10 && [bloodSugarIndic floatValue] < 20){
                levelString = NSLocalizedString(@"不宜食", @"");
            }else {
                levelString = NSLocalizedString(@"少食", @"");
            }

            
            
            //评价栏
            NSDictionary *imageDic = @{@"title":[NSString stringWithFormat:@"  %@",levelString],@"imageName": resultDic[@"img"],@"value1":hotValueString,@"value2":riseSugarString,@"value3":bloodSugarIndic};
            [detailArray addObject:imageDic];
            //营养成分
            NSArray *array1 = @[keyArray1,valueArray1];
            [detailArray addObject:array1];

            
            if(self.ismenu){
                //食材
                
                //菜谱用料
                //            NSArray *keyArray2 = @[@"title",@"西红柿",@"鸡蛋"];
                //            NSArray *valueArray2 = @[@"菜谱用料",@"200g/2个",@"600g/3个"];
                NSArray *ingredientsArray = [ingredientsString componentsSeparatedByString:@"|"];
                NSArray *ingredientsGramArray = [ingredientsGramString componentsSeparatedByString:@"|"];
                [keyArray2 addObjectsFromArray:ingredientsArray];
//                [valueArray2 addObjectsFromArray:ingredientsGramArray];
                for(NSString *gram in ingredientsGramArray){
                    [valueArray2 addObject:[NSString stringWithFormat:@"%@克",gram]];
                }
                NSArray *array2 = @[keyArray2,valueArray2];
                [detailArray addObject:array2];
                
                //制作步骤 --- 菜谱有
                NSArray *keyArray3 = @[@"制作步骤",PRACTICEString];
                [detailArray addObject:keyArray3];
                
            }else{
                //食物相克
                //            NSArray *keyArray2 = @[@"title",@"西红柿",@"鸡蛋"];
                //            NSArray *valueArray2 = @[@"菜谱用料",@"200g/2个",@"600g/3个"];
                NSArray *array2 = @[keyArray2,valueArray2];
                [detailArray addObject:array2];
                //推荐菜谱 ----食物有
                NSDictionary *one = @{@"title": @"推荐菜谱"};
                NSMutableArray *array3 = [NSMutableArray arrayWithCapacity:0];
                [array3 addObject:one];
                NSArray *dishNameArray = [dishNameString componentsSeparatedByString:@"|"];
                NSArray *dishIdArray = [dishesIdString componentsSeparatedByString:@"|"];
                NSArray *dishImgArray = [dishImgString componentsSeparatedByString:@"|"];
                
         
                
                NSMutableArray *savedNameArray = [NSMutableArray arrayWithCapacity:0];
                
                for(int i = 0; i < dishNameArray.count;i++){
                    
                    NSString *name = dishNameArray[i];
                    if(![savedNameArray containsObject:name]){
                        [savedNameArray addObject:name];
                        NSDictionary *dishDic = @{@"image": dishImgArray[i],@"name":name,@"dishId":dishIdArray[i]};
                        [array3 addObject:dishDic];
                    }
                    
                }
                
//                NSDictionary *two = @{@"image": @"food.png",@"name":@"西红柿炒鸡蛋"};
//                NSDictionary *three = @{@"image": @"food.png",@"name":@"西红柿牛腩"};
//                NSArray *array3 = @[one,two,three];
                [detailArray addObject:array3];
            }
            [detailTableView reloadData];
            
            [self stopLoadingActiView];//隐藏view
            
        });
        
    });
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(detailArray.count){
        return 4;
    }
    return detailArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    if(section == 2 || section == 1){
        
        if(section == 2 && !self.ismenu && hasFoodRestraintFlag == NO){
            //控制食物相克有无
            return 0;
        }
        
        NSArray *keyValueArray = detailArray[section];
        NSArray *keyArray = keyValueArray[0];
        return keyArray.count;
        
    }
        if(section == 3){
    
        NSArray *keyArray = detailArray[section];
            if(keyArray.count == 1){
                return 0;
            }
            
        return keyArray.count;
    }
    
    return 0;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        static NSString *imageCellId = @"imageCell";
        ImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:imageCellId];
        if(!imageCell){
            imageCell = [[[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellId] autorelease];
            imageCell.backgroundColor = [UIColor clearColor];
            imageCell.contentView.backgroundColor = [UIColor clearColor];
            imageCell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        imageCell.showDetailBlock = ^(void){
            
            [UIView animateWithDuration:0.35 animations:^{
                tipsView.alpha = 1;

            }];
           
        
        };
        NSDictionary *dic = detailArray[indexPath.section];
        [imageCell setImageInfoDic:dic];
        
        return imageCell;
        
    }else if(indexPath.section == 1 || indexPath.section == 2){
    
        if(!self.ismenu && indexPath.section == 2){
            //食物相克
            static NSString *foodCellId = @"FoodRestrCell";
            FoodRestraintTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:foodCellId];
            if(!listCell){
                listCell = [[[FoodRestraintTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:foodCellId] autorelease];
                listCell.backgroundColor = [UIColor clearColor];
                listCell.contentView.backgroundColor = [UIColor clearColor];
                listCell.selectionStyle = UITableViewCellSeparatorStyleNone;
            }
            NSString *key = nil;
            NSString *value = nil;
            BOOL last = NO;
            NSArray *keyAndValue = detailArray[indexPath.section];
            NSArray *keyArray = keyAndValue[0];
            NSArray *valueArray = keyAndValue[1];
            key = keyArray[indexPath.row];
            value = valueArray[indexPath.row];
            last = indexPath.row == keyArray.count -1;

            if(indexPath.section == 2 && indexPath.row == 0){
                [listCell setDataKey:value Value:@"" Index:(int)indexPath.row lastRow:NO hasSmall:NO specialKey:@""];
            }else{
                [listCell setDataKey:key Value:value Index:(int)indexPath.row lastRow:last hasSmall:NO specialKey:@""];
            }

            
            return listCell;
        }
        
        
        
        
        static NSString *listCellId = @"ListCell";
        ListTableViewCell *listCell = [tableView dequeueReusableCellWithIdentifier:listCellId];
        if(!listCell){
            listCell = [[[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:listCellId] autorelease];
            listCell.backgroundColor = [UIColor clearColor];
            listCell.contentView.backgroundColor = [UIColor clearColor];
            listCell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
        NSString *key = nil;
        NSString *value = nil;
        BOOL last = NO;
        
        if(indexPath.section == 1){
            NSArray *keyAndValue = detailArray[indexPath.section];
            NSArray *keyArray = keyAndValue[0];
            NSArray *valueArray = keyAndValue[1];
            key = keyArray[indexPath.row];
            value = valueArray[indexPath.row];
            last = indexPath.row == keyArray.count -1;

        }else if(indexPath.section == 2){
            
            NSArray *keyAndValue = detailArray[indexPath.section];
            NSArray *keyArray = keyAndValue[0];
            NSArray *valueArray = keyAndValue[1];
            key = keyArray[indexPath.row];
            value = valueArray[indexPath.row];
            last = indexPath.row == keyArray.count -1;
        }
        
        if(indexPath.section == 1 && indexPath.row == 0){
            [listCell setDataKey:value Value:@"" Index:(int)indexPath.row lastRow:NO hasSmall:YES specialKey:@"(每100克)"];
        }else if(indexPath.section == 2 && indexPath.row == 0){
            [listCell setDataKey:value Value:@"" Index:(int)indexPath.row lastRow:NO hasSmall:NO specialKey:@""];
        }else{
            [listCell setDataKey:key Value:value Index:(int)indexPath.row lastRow:last hasSmall:NO specialKey:@""];
        }
        
        return listCell;
        
    }else if(indexPath.section == 3){
        if(!self.ismenu){
            static NSString *recommendCellId = @"recommendCell";
            RecommendTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:recommendCellId];
            if(!textCell){
                textCell = [[[RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recommendCellId] autorelease];
                textCell.backgroundColor = [UIColor clearColor];
                textCell.contentView.backgroundColor = [UIColor clearColor];
                textCell.selectionStyle = UITableViewCellSeparatorStyleNone;
            }
            NSArray *keyArray = detailArray[indexPath.section];
    
            NSString *text = nil;
            NSString *imageName = nil;
            BOOL last = indexPath.row == keyArray.count - 1;
            BOOL hasImage = YES;
            NSDictionary *dic = keyArray[indexPath.row];
            if(indexPath.row == 0){
                text = dic[@"title"];
                hasImage = YES;
            }else{
                text = dic[@"name"];
                imageName = dic[@"image"];
            }
            
            [textCell setValue:text hasImageView:hasImage imageName:imageName row:(int)indexPath.row last:last];
            
            return textCell;
        
        }else{
            static NSString *textCellId = @"textCell";
            TextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:textCellId];
            if(!textCell){
                textCell = [[[TextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:   textCellId] autorelease];
                textCell.backgroundColor = [UIColor clearColor];
                textCell.contentView.backgroundColor = [UIColor clearColor];
                textCell.selectionStyle = UITableViewCellSeparatorStyleNone;
            }
            NSArray *keyArray = detailArray[indexPath.section];
            NSString *key = keyArray[indexPath.row];
            BOOL last = indexPath.row == keyArray.count - 1;
            [textCell setvalue:key row:(int)indexPath.row last:last];
        
            return textCell;
        }
    }
    
    return nil;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        
        return   10+157+10;//210+44+15;
    }else if(indexPath.section == 3){
        if(indexPath.row == 0){
            return 44;
        }else{

            if(!self.ismenu){
                return 60;
            }else{
                NSArray *keyArray = detailArray[indexPath.section];
                NSString *key = keyArray[indexPath.row];
                CGFloat height = [Common heightForString:key Width:kDeviceWidth-20-15*2 Font:[UIFont systemFontOfSize:14.0f]].height;
                return height + 20 ;
            }
        }
    }else if(!self.ismenu && indexPath.section == 2){
        //食物相克
        if(indexPath.row == 0){
            return 44;
        }else{
            NSArray *keyAndValue = detailArray[indexPath.section];
            NSArray *valueArray = keyAndValue[1];
            NSString *value = valueArray[indexPath.row];

            CGSize valueSize = [Common heightForString:value Width:kDeviceWidth-20-32 Font:[UIFont systemFontOfSize:15]];
            CGFloat height = valueSize.height < 35 ? 35 : valueSize.height;
            return 35 + height+20;
        
        }
        
    }
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(self.ismenu == NO && section == 2 && hasFoodRestraintFlag == NO){
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if(self.ismenu == NO && section == 2 && hasFoodRestraintFlag == NO){
        return 0;
    }
    if (section == detailArray.count - 1) {
        return 10;
    } else {
        return .1f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return [view autorelease];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return [view autorelease];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FoodRestraintTableViewCell *cell = (FoodRestraintTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell description];
    
    
    if(!self.ismenu && indexPath.section == 3){
    //推荐菜谱
        NSArray *keyArray = detailArray[indexPath.section];
        
        NSString *name = nil;
        NSString *keyID = nil;
        NSDictionary *dic = keyArray[indexPath.row];
        if(indexPath.row == 0){
            return;
        }else{
            name = dic[@"name"];
            keyID  = dic[@"dishId"];
        }
        
        
        SugarDetailViewController *sugarDetailVC = [[SugarDetailViewController alloc] init];
        sugarDetailVC.ismenu = YES;
        sugarDetailVC.title = name;
        sugarDetailVC.key = keyID;
        [self.navigationController pushViewController:sugarDetailVC animated:YES];
        [sugarDetailVC release];

    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
