//
//  HealthImageViewController.m
//  jiuhaoHealth2.0
//
//  Created by wangmin on 14-4-9.
//  Copyright (c) 2014年 徐国洪. All rights reserved.
//

#import "HealthImageViewController.h"
#import "CheckDiseaseListViewController.h"
#import "CommonHttpRequest.h"
#import "DiseaseInfoViewController.h"
#import "SymptomsDiseaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DBOperate.h"
#import "SOSDetailViewController.h"

@interface HealthImageViewController () {
  UIImageView *bodyImageView;           //展示图
  UIImageView *selectedPointImageView;  //选中点的view
  BOOL manORWoman;                      //男女选择 0-男 1-女
  BOOL normalORColor;                   //颜色 0-正面 1-反面

  int currentBodyID;  //当前请求的id

  BOOL requestFlag;  //请求标识为 防止乱点

  UIButton *toCheckButton;  //诊断按钮
  UISearchDisplayController *searchC;

  BOOL currentSearchType;  //当前搜索的类型 0：症状 1疾病

  BOOL isSearching;   //是否正在搜索
  UIButton *wordBtn;  //文字btn
  DBOperate *myDBOperation;
}

@property(nonatomic, retain) NSArray *picArray;
@property(nonatomic, retain) NSArray *colorPicArray;

@property(nonatomic, retain) NSMutableDictionary *partIdDic;

@property(nonatomic, retain) NSArray *generalSymDataArray;  //相关部位数组

@property(nonatomic, retain) NSMutableArray *searchResultArray;  //搜索结果数组

@property(nonatomic, retain) NSMutableArray *selectedArray;  //选中的数组

@property(nonatomic, retain) NSString *nextPageTitle;  //下一页面标题

@property(nonatomic, retain) NSMutableArray *diseaseArray;  //疾病数组

@end

//{"state":0,"msg":"success","rs":[{"id":"1146a888d27c4db9b9c2512b0d802e75","partId":"0005","partName":"颈部","parentId":"","level":1,"priority":5},{"id":"1e5650200e194f20a758d4fef1f318d9","partId":"0007","partName":"背部","parentId":"","level":1,"priority":7},{"id":"2b07458321e74c2589f1762aedc8c863","partId":"0013","partName":"毛发","parentId":"","level":1,"priority":13},{"id":"3e9872a1678c4ec9a48023465e810660","partId":"0001","partName":"头部","parentId":"","level":1,"priority":1},{"id":"5aae1041b9ec427584c1789d480e9c18","partId":"0006","partName":"腰部","parentId":"","level":1,"priority":6},{"id":"5c4dfe35a9c0411a99b131f2c116c790","partId":"0011","partName":"生殖部位","parentId":"","level":1,"priority":11},{"id":"61af80c74ba64e188a25354c90218a10","partId":"0002","partName":"胸部","parentId":"","level":1,"priority":2},{"id":"7a72ab1e9ec84dd289cf2646c8fd3bc8","partId":"0010","partName":"全身","parentId":"","level":1,"priority":10},{"id":"855a476bae174ce08816def47c066352","partId":"0009","partName":"皮肤","parentId":"","level":1,"priority":9},{"id":"85c7ac748e4a4f809a2daa8e83be9989","partId":"0014","partName":"其他","parentId":"","level":1,"priority":14},{"id":"9c95eeb852d2410c8ae86685b4218d0c","partId":"0008","partName":"臀部","parentId":"","level":1,"priority":8},{"id":"aedbaa8669134f3796a2db247f69dac5","partId":"0004","partName":"四肢","parentId":"","level":1,"priority":4},{"id":"c7355823fb424aa893cc8ac7cdb4002f","partId":"0003","partName":"腹部","parentId":"","level":1,"priority":3},{"id":"fe59fc6e4db34eed8858fea77791222f","partId":"0012","partName":"盆腔","parentId":"","level":1,"priority":12}]}

/**
 *  得到人体部位编号 --男
 *
 *  @return Dic
 */
static NSDictionary *manColorTobodyDic() {
  //    NSDictionary *dic = @{@"#ccffff": @"头部",@"#99cccc":
  //    @"颈部",@"#669999": @"胸部",@"#336666": @"腹部",@"#003333":
  //    @"男部",@"#339999": @"上肢",@"#006666":
  //    @"下肢",@"#66cccc":@"背部",@"#00cccc":@"腰部",@"#009999":@"臀部"};

  NSDictionary *dic = @{
    @"#ccffff" : @"0001",
    @"#99cccc" : @"0005",
    @"#669999" : @"0002",
    @"#336666" : @"0003",
    @"#003333" : @"0011",
    @"#339999" : @"000401",
    @"#006666" : @"000402",
    @"#66cccc" : @"0007",
    @"#00cccc" : @"0006",
    @"#009999" : @"0008"
  };
  return dic;
};

/**
 *  得到人体部位编号 --女
 *
 *  @return Dic
 */
static NSDictionary *womanColorTobodyDic() {
  NSDictionary *dic = @{
    @"#ffcccc" : @"0001",
    @"#cc9999" : @"0005",
    @"#cc6666" : @"0002",
    @"#996666" : @"0003",
    @"#663333" : @"0011",
    @"#ff9999" : @"000401",
    @"#330000" : @"000402",
    @"#660000" : @"0007",
    @"#ff6666" : @"0006",
    @"#993333" : @"0008"
  };
  return dic;
};

@implementation HealthImageViewController

- (void)dealloc {
  [g_winDic
      removeObjectForKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
  self.searchResultArray = nil;
  [bodyImageView release];
  [selectedPointImageView release];
  self.picArray = nil;
  self.colorPicArray = nil;
  self.partIdDic = nil;
  self.generalSymDataArray = nil;
  [searchC release];
  self.nextPageTitle = nil;
  self.diseaseArray = nil;
  [super dealloc];
}
/**
 *  初始化变量
 *
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.title = NSLocalizedString(@"我的自查", nil);

//    UIBarButtonItem *backBar =
//        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil)
//                                         style:UIBarButtonItemStylePlain
//                                        target:nil
//                                        action:nil];
//    self.navigationItem.backBarButtonItem = backBar;
//    [backBar release];

    self.picArray = @[
      @[ @"man_Positive_nor@2x.png", @"man_Back_nor@2x.png" ],
      @[ @"woman_Positive_nor@2x.png", @"woman_Back_nor@2x.png" ]
    ];
    self.colorPicArray = @[
      @[ @"man_Positive_pre@2x.png", @"man_Back_pre@2x.png" ],
      @[ @"woman_Positive_pre@2x.png", @"woman_Back_pre@2x.png" ]
    ];
    manORWoman = 0;
    normalORColor = 0;

    self.partIdDic =
        [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    self.selectedArray =
        [[[NSMutableArray alloc] initWithCapacity:0] autorelease];

    [g_winDic setObject:@"1"
                 forKey:[NSString stringWithFormat:@"%x", (unsigned int)self]];
      myDBOperation = [DBOperate shareInstance];
  }

  return self;
}

#pragma NetWorkReleated Function

/**
 *  根据类型查询一级身体部位接口
 */
- (void)getAllSymptomBodyPartByType {
//  [[CommonHttpRequest defaultInstance]
//      sendHttpRequest:[GetAllSymptoBodyPartByType stringByAppendingFormat:@"1"]
//           encryptStr:GetAllSymptoBodyPartByType
//             delegate:self
//           controller:self
//         actiViewFlag:NO
//                title:nil];
}

/**
 *  根据类型查询二级身体部位接口
 */
- (void)getAllSymptoSecondBodyPartByType {
  NSLog(@"manorWoman:%d", manORWoman);
    
    
  NSArray *resultArray =  [myDBOperation getAllSymptomBodyPart];

    
    
    
    
    CheckDiseaseListViewController *checkListVC =
    [[CheckDiseaseListViewController alloc] init];
    checkListVC.selectedManORWoman = manORWoman;
    NSLog(@"manorWoman:%d,manORWoman == YES:%d", manORWoman,
          manORWoman == NO);
    
    checkListVC.hasDiffenerntSource = YES;
    
    NSMutableArray *bodyArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray *womanArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *manArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *dic in resultArray) {
        NSString *parentID = dic[@"parentId"];
        if ([parentID isEqualToString:@"0011"]) {
            //区别男女
            NSString *currentId = dic[@"partId"];
            if ([currentId isEqualToString:@"001102"]) {
                //女
                [womanArray addObject:dic];
                
            } else if ([currentId isEqualToString:@"001101"]) {
                //男
                [manArray addObject:dic];
            }
            
        } else {
            //直接添加
            
            [bodyArray addObject:dic];
        }
    }
    //男
    NSMutableArray *manDataArray =
    [[NSMutableArray alloc] initWithCapacity:0];
    [manDataArray addObjectsFromArray:bodyArray];
    [manDataArray addObjectsFromArray:manArray];
    [manArray release];
    //女
    NSMutableArray *womanDataArray =
    [[NSMutableArray alloc] initWithCapacity:0];
    [womanDataArray addObjectsFromArray:bodyArray];
    [womanDataArray addObjectsFromArray:womanArray];
    [womanArray release];
    
    //男
    checkListVC.manSymDataArray = manDataArray;
    [manDataArray release];
    //女
    checkListVC.womanSymDataArray = womanDataArray;
    [womanDataArray release];
    
    if (manORWoman == 0) {
        checkListVC.generalSymDataArray = checkListVC.manSymDataArray;
    } else {
        checkListVC.generalSymDataArray = checkListVC.womanSymDataArray;
    }
    //            checkListVC.generalSymDataArray = bodyArray;
    [bodyArray release];
    
    //            HealthCheckViewController *healthCheckVC =
    //            (HealthCheckViewController *)self.healthImageVCDelegate;
    [self.navigationController pushViewController:checkListVC animated:YES];
    //            [self.navigationController pushViewController:checkListVC
    //            animated:YES];
    [checkListVC release];
    
    requestFlag = NO;
    
    
    return;
    
//  [[CommonHttpRequest defaultInstance]
//      sendHttpRequest:[GetAllSymptoSecondBodyPartByType
//                          stringByAppendingFormat:@"-3"]
//           encryptStr:@"GetSecondBodyPart"
//             delegate:self
//           controller:self
//         actiViewFlag:YES
//                title:nil];
}

/**
 *  根据一级身体部位编号查询二级身体部位列表
 *
 *  @param parentPartId 部位id
 */
- (void)getAllSymptomBodyPartParentPartWithParentPartId:
            (NSString *)parentPartId {
    
    //---得到结果
   NSArray *resultArray = [myDBOperation getAllSymptomBodyPartWithParentPartId:parentPartId];
    
    NSLog(@"resultArray:%@", resultArray);
    self.generalSymDataArray = [resultArray
                                sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                    NSDictionary *dic1 = (NSDictionary *)obj1;
                                    NSDictionary *dic2 = (NSDictionary *)obj2;
                                    int priority1 = (int)[dic1[@"priority"] integerValue];
                                    int priority2 = (int)[dic2[@"priority"] integerValue];
                                    
                                    if (priority1 < priority2) {
                                        return NSOrderedAscending;
                                    }
                                    if (priority1 == priority2) {
                                        return NSOrderedSame;
                                    } else {
                                        return NSOrderedDescending;
                                    }
                                }];
    
    CheckDiseaseListViewController *checkListVC =
    [[CheckDiseaseListViewController alloc] init];
    checkListVC.selectedManORWoman = manORWoman;
    if (currentBodyID == 11 && self.generalSymDataArray.count == 2) {
        checkListVC.hasDiffenerntSource = YES;
        //女
        checkListVC.womanSymDataArray =
        [NSMutableArray arrayWithObjects:self.generalSymDataArray[1], nil];
        //男
        checkListVC.manSymDataArray =
        [NSMutableArray arrayWithObjects:self.generalSymDataArray[0], nil];
        
        if (manORWoman == 0) {
            checkListVC.generalSymDataArray = checkListVC.manSymDataArray;
        } else {
            checkListVC.generalSymDataArray = checkListVC.womanSymDataArray;
        }
        
    } else {
        checkListVC.generalSymDataArray =
        [NSMutableArray arrayWithArray:self.generalSymDataArray];
    }
    [self.navigationController pushViewController:checkListVC animated:YES];
    [checkListVC release];
    
    requestFlag = NO;

    return;
//  [[CommonHttpRequest defaultInstance]
//      sendHttpRequest:[GetAllSymptomBodyPartParentPart
//                          stringByAppendingFormat:@"%@", parentPartId]
//           encryptStr:GetAllSymptomBodyPartParentPart
//             delegate:self
//           controller:self
//         actiViewFlag:YES
//                title:nil];
}

/**
 *  //获取症状的相关疾病列表
 *  //多个用分号分开
 *
 *  @param ids 多个id
 */
- (void)getSymptomsDiseaseBysymptomids:(NSString *)ids {
  NSMutableDictionary *requestDic =
      [NSMutableDictionary dictionaryWithCapacity:0];
  [requestDic setValue:ids forKey:@"ids"];

    
    NSArray *resultArray = [myDBOperation getDiseaseListBySymptomIds:ids];
    //跳转到另外一个页面中--疾病列表
    NSLog(@"resultArray:%@", resultArray);
    //            self.diseaseArray = [[NSMutableArray alloc]
    //            initWithArray:resultArray];
    SymptomsDiseaseViewController *symptomsDiseaseVC =
    [[SymptomsDiseaseViewController alloc] init];
    symptomsDiseaseVC.diseaseArray = resultArray;
    [self.navigationController pushViewController:symptomsDiseaseVC  animated:YES];
    [symptomsDiseaseVC release];

    return;
    
  [[CommonHttpRequest defaultInstance]
      sendNewPostRequest:GetSymptomsDiseaseBysymptomids
               values:requestDic
           requestKey:GetSymptomsDiseaseBysymptomids
             delegate:self
           controller:self
         actiViewFlag:YES
                title:nil];
}

#pragma mark - ASIHttpRequest Response  Delegate
/**
 *  请求回调处理函数
 *
 *  @param loader
 */

- (void)didFinishSuccess:(ASIHTTPRequest *)loader {
  NSString *responseString = [loader responseString];
  NSDictionary *dic = [responseString KXjSONValueObject];
  NSArray *resultArray = dic[@"rs"];
  if (![[dic objectForKey:@"state"] intValue]) {
    if ([loader.username isEqualToString:GetAllSymptoBodyPartByType]) {
        //废弃--
      NSLog(@"resultArray:%@", resultArray);
      for (NSDictionary *dic in resultArray) {
        [self.partIdDic setObject:dic[@"partId"] forKey:dic[@"partName"]];
      }

    } else if ([loader.username
                   isEqualToString:GetAllSymptomBodyPartParentPart]) {
      NSLog(@"resultArray:%@", resultArray);
      self.generalSymDataArray = [resultArray
          sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
              NSDictionary *dic1 = (NSDictionary *)obj1;
              NSDictionary *dic2 = (NSDictionary *)obj2;
              int priority1 = (int)[dic1[@"priority"] integerValue];
              int priority2 = (int)[dic2[@"priority"] integerValue];

              if (priority1 < priority2) {
                return NSOrderedAscending;
              }
              if (priority1 == priority2) {
                return NSOrderedSame;
              } else {
                return NSOrderedDescending;
              }
          }];

      CheckDiseaseListViewController *checkListVC =
          [[CheckDiseaseListViewController alloc] init];
      checkListVC.selectedManORWoman = manORWoman;
      if (currentBodyID == 11 && self.generalSymDataArray.count == 2) {
        checkListVC.hasDiffenerntSource = YES;
        //女
        checkListVC.womanSymDataArray =
            [NSMutableArray arrayWithObjects:self.generalSymDataArray[1], nil];
        //男
        checkListVC.manSymDataArray =
            [NSMutableArray arrayWithObjects:self.generalSymDataArray[0], nil];

        if (manORWoman == 0) {
          checkListVC.generalSymDataArray = checkListVC.manSymDataArray;
        } else {
          checkListVC.generalSymDataArray = checkListVC.womanSymDataArray;
        }

      } else {
        checkListVC.generalSymDataArray =
            [NSMutableArray arrayWithArray:self.generalSymDataArray];
      }
      [self.navigationController pushViewController:checkListVC animated:YES];
      [checkListVC release];

      requestFlag = NO;

    } else if ([loader.username isEqualToString:@"GetSecondBodyPart"]) {
      NSLog(@"resultArray:%@", resultArray);

      CheckDiseaseListViewController *checkListVC =
          [[CheckDiseaseListViewController alloc] init];
      checkListVC.selectedManORWoman = manORWoman;
      NSLog(@"manorWoman:%d,manORWoman == YES:%d", manORWoman,
            manORWoman == NO);

      checkListVC.hasDiffenerntSource = YES;

      NSMutableArray *bodyArray = [[NSMutableArray alloc] initWithCapacity:0];

      NSMutableArray *womanArray = [[NSMutableArray alloc] initWithCapacity:0];
      NSMutableArray *manArray = [[NSMutableArray alloc] initWithCapacity:0];

      for (NSDictionary *dic in resultArray) {
        NSString *parentID = dic[@"parentId"];
        if ([parentID isEqualToString:@"0011"]) {
          //区别男女
          NSString *currentId = dic[@"partId"];
          if ([currentId isEqualToString:@"001102"]) {
            //女
            [womanArray addObject:dic];

          } else if ([currentId isEqualToString:@"001101"]) {
            //男
            [manArray addObject:dic];
          }

        } else {
          //直接添加

          [bodyArray addObject:dic];
        }
      }
      //男
      NSMutableArray *manDataArray =
          [[NSMutableArray alloc] initWithCapacity:0];
      [manDataArray addObjectsFromArray:bodyArray];
      [manDataArray addObjectsFromArray:manArray];
      [manArray release];
      //女
      NSMutableArray *womanDataArray =
          [[NSMutableArray alloc] initWithCapacity:0];
      [womanDataArray addObjectsFromArray:bodyArray];
      [womanDataArray addObjectsFromArray:womanArray];
      [womanArray release];

      //男
      checkListVC.manSymDataArray = manDataArray;
      [manDataArray release];
      //女
      checkListVC.womanSymDataArray = womanDataArray;
      [womanDataArray release];

      if (manORWoman == 0) {
        checkListVC.generalSymDataArray = checkListVC.manSymDataArray;
      } else {
        checkListVC.generalSymDataArray = checkListVC.womanSymDataArray;
      }
      //            checkListVC.generalSymDataArray = bodyArray;
      [bodyArray release];

      //            HealthCheckViewController *healthCheckVC =
      //            (HealthCheckViewController *)self.healthImageVCDelegate;
      [self.navigationController pushViewController:checkListVC animated:YES];
      //            [self.navigationController pushViewController:checkListVC
      //            animated:YES];
      [checkListVC release];

      requestFlag = NO;

    } else if ([loader.username isEqualToString:GetSymptomsinfoByName]) {
      //模糊搜索结果

      NSLog(@"resultArray:%@", resultArray);
      self.selectedArray = [[NSMutableArray alloc] initWithCapacity:0];
      self.searchResultArray = [NSMutableArray arrayWithArray:resultArray];
      [searchC.searchResultsTableView reloadData];

    } else if ([loader.username isEqualToString:GetDiseaseListByName]) {
      //模糊搜索结果

      NSLog(@"resultArray:%@", resultArray);
      self.searchResultArray = [NSMutableArray arrayWithArray:resultArray];
      [searchC.searchResultsTableView reloadData];
    } else if ([loader.username isEqualToString:GetSymptomDiseaseByid]) {
      //根据疾病id查看疾病详细

      NSDictionary *resultDic = dic[@"rs"];
      NSLog(@"resultArray:%@", resultDic);

      DiseaseInfoViewController *diseaseInfoVC =
          [[DiseaseInfoViewController alloc] init];
      diseaseInfoVC.thirdName = NSLocalizedString(@"症状", nil);
      NSString *diseaseInfo = resultDic[@"diseaseInfo"];    //简介
      NSString *diseaseCause = resultDic[@"diseaseCause"];  //病因
      NSString *symptom = resultDic[@"symptom"];            //症状
      NSString *diagnose = resultDic[@"diagnose"];          //诊断
      diseaseInfoVC.title = self.nextPageTitle;
      diseaseInfoVC.diseaseArray = [NSMutableArray
          arrayWithObjects:diseaseInfo.length > 0 ? diseaseInfo : @"",
                           diseaseCause.length > 0 ? diseaseCause : @"",
                           symptom.length > 0 ? symptom : @"",
                           diagnose.length > 0 ? diagnose : @"", nil];

      [self.navigationController pushViewController:diseaseInfoVC animated:YES];
      [diseaseInfoVC release];

    } else if ([loader.username  isEqualToString:GetSymptomsDiseaseBysymptomids]) {
      //根据症状查找疾病返回，适用于男女 数据源为

      //跳转到另外一个页面中--疾病列表
      NSLog(@"resultArray:%@", resultArray);
      //            self.diseaseArray = [[NSMutableArray alloc]
      //            initWithArray:resultArray];
      SymptomsDiseaseViewController *symptomsDiseaseVC =
          [[SymptomsDiseaseViewController alloc] init];
      symptomsDiseaseVC.diseaseArray = resultArray;
      [self.navigationController pushViewController:symptomsDiseaseVC  animated:YES];
      [symptomsDiseaseVC release];
    }

  } else {
    requestFlag = NO;  //关掉
    [Common TipDialog:[dic objectForKey:@"msg"]];
    return;
  }
}
/**
 *  请求失败处理
 *
 *  @param loader
 */
- (void)didFinishFail:(ASIHTTPRequest *)loader {
  requestFlag = NO;  //关掉
  [Common TipDialog:NSLocalizedString(@"请求失败，请稍后重试", nil)];
  NSLog(@"fail");
}
/**
 *  隐藏按钮
 */
- (void)hiddenCheckBtn {
  toCheckButton.hidden = YES;
}

#pragma mark - UISearBarDelegae
/**
 *  搜索代理函数
 *
 *  @param searchBar
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
  //    wordBtn.hidden = YES;
  [UIView animateWithDuration:0.2 animations:^{ wordBtn.alpha = 0; }];

  if (_healthImageVCDelegate &&
      [_healthImageVCDelegate respondsToSelector:@selector(searchStatues:)]) {
    [_healthImageVCDelegate searchStatues:YES];
  }

  if (IOS_7) {
    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleDefault];
  }
  searchBar.layer.borderColor = [UIColor clearColor].CGColor;

  UIView *choiceView = [self.view viewWithTag:99];
  [self.view bringSubviewToFront:choiceView];

  if (isSearching == NO) {
    choiceView.alpha = 0;
    UIButton *showBtn =
        (UIButton *)[searchC.searchBar viewWithTag:77];  //显示button
    UIImageView *arrowImv = (UIImageView *)[showBtn viewWithTag:78];  //箭头
    arrowImv.image = [UIImage imageNamed:@"common.bundle/check/drop_on.png"];
  }

  [self.searchResultArray removeAllObjects];
  [searchC.searchResultsTableView reloadData];

  self.selectedArray =
      [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
  if (!searchBar.text.length) {
    [self searchBarCancelButtonClicked:searchBar];
    searchBar.layer.borderColor = [CommonImage colorWithHexString:@"e3e3d9"].CGColor;
    //        wordBtn.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{ wordBtn.alpha = 1; }];
    if (_healthImageVCDelegate &&
        [_healthImageVCDelegate respondsToSelector:@selector(searchStatues:)]) {
      [_healthImageVCDelegate searchStatues:NO];
    }
  }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    return;
  UIView *choiceView = [self.view viewWithTag:99];
  choiceView.alpha = 0;

  [self.searchResultArray removeAllObjects];
  [searchC.searchResultsTableView reloadData];

  if (currentSearchType == 1) {  //区分症状和疾病
    toCheckButton.hidden = YES;
    [self getDiseaseinfoByName:searchBar.text];
  } else if (currentSearchType == 0) {
    toCheckButton.hidden = NO;
    [APP_DELEGATE bringSubviewToFront:toCheckButton];
    [self getSymptomsinfoByName:searchBar.text];
  }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{

    UIView *choiceView = [self.view viewWithTag:99];
    choiceView.alpha = 0;
    
    [self.searchResultArray removeAllObjects];
    [searchC.searchResultsTableView reloadData];
    
    if (currentSearchType == 1) {  //区分症状和疾病
        toCheckButton.hidden = YES;
        [self getDiseaseinfoByName:searchBar.text];
    } else if (currentSearchType == 0) {
        toCheckButton.hidden = NO;
        [APP_DELEGATE bringSubviewToFront:toCheckButton];
        [self getSymptomsinfoByName:searchBar.text];
    }


}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  //    wordBtn.hidden = NO;
  [UIView animateWithDuration:0.5 animations:^{ wordBtn.alpha = 1; }];
  if (IOS_7) {
    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleDefault];
  }
  isSearching = NO;
  toCheckButton.hidden = YES;
  UIButton *showBtn = (UIButton *)[searchC.searchBar viewWithTag:77];
  showBtn.enabled = YES;
  //取消按钮 下移view位置  并消失
  //    UIView *choiceView = [[[[UIApplication sharedApplication] delegate]
  //    window] viewWithTag:99];
  //    choiceView.frame = CGRectMake(7,37+64, 52, 30);
  //    choiceView.alpha = 0;
  if (_healthImageVCDelegate &&
      [_healthImageVCDelegate respondsToSelector:@selector(searchStatues:)]) {
    [_healthImageVCDelegate searchStatues:NO];
  }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
    didLoadSearchResultsTableView:(UITableView *)tableView {
  UIView *choiceView = [self.view viewWithTag:99];
  [self.view bringSubviewToFront:choiceView];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
    didShowSearchResultsTableView:(UITableView *)tableView {
  if (currentSearchType == 0) {
    toCheckButton.hidden = NO;
    if (IOS_7) {
      tableView.frame = CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT - 44);
    } else {
      tableView.frame =
          CGRectMake(0, 44, kDeviceWidth, SCREEN_HEIGHT - 44 - 44);
    }
  } else {
    toCheckButton.hidden = YES;

    if (IOS_7) {
      tableView.frame = CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT);
    } else {
      tableView.frame = CGRectMake(0, 44, kDeviceWidth, SCREEN_HEIGHT - 44);
    }
  }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
    willShowSearchResultsTableView:(UITableView *)tableView {
  isSearching = YES;
  if (currentSearchType == 0) {
    toCheckButton.hidden = NO;

  } else {
    toCheckButton.hidden = YES;
  }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
    willHideSearchResultsTableView:(UITableView *)tableView {
  toCheckButton.hidden = YES;
  UIButton *showBtn = (UIButton *)[searchC.searchBar viewWithTag:77];
  showBtn.enabled = YES;
  isSearching = NO;

}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (currentSearchType == 0) {
    toCheckButton.hidden = NO;
    [APP_DELEGATE bringSubviewToFront:toCheckButton];
  } else {
    toCheckButton.hidden = YES;
  }
}

/**
 *  对症状进行诊断
 *
 *  @param btn
 */
- (void)sendToDiagnosis:(UIButton *)btn {
  NSLog(@"self.selected:%@", self.selectedArray);

  if (self.selectedArray.count == 0) {
    [Common TipDialog:NSLocalizedString(@"请"
                                        @"至少选择一个病症进行诊断", nil)];
    return;
  }
  //疾病列表数据源
  self.diseaseArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
  NSString *ids = @"";
  for (NSDictionary *oneDic in self.selectedArray) {
    ids = [NSString stringWithFormat:@"%@;%@", ids, oneDic[@"id"]];
  }

  if (self.selectedArray.count == 1) {
    [self getSymptomsDiseaseBysymptomids:[ids substringFromIndex:1]];

  } else {
    [self getSymptomsDiseaseBysymptomids:[ids substringFromIndex:1]];
  }
}

/**
 *  //根据疾病名搜索疾病
 *
 *  @param nameString
 */
- (void)getDiseaseinfoByName:(NSString *)nameString {
  NSString *crowid = @"0001";  //男
  if (manORWoman) {
    //女
    crowid = @"0002";  //女
  }

   NSArray *resultArray = [myDBOperation getDiseaseInfoByName:nameString];
    
    NSLog(@"resultArray:%@", resultArray);
    self.searchResultArray = [NSMutableArray arrayWithArray:resultArray];
    [searchC.searchResultsTableView reloadData];
    
    return;

   NSMutableDictionary *requestDic =
      [NSMutableDictionary dictionaryWithCapacity:0];
  [requestDic setValue:nameString forKey:@"name"];
  [requestDic setValue:@"0" forKey:@"limitStart"];
  [requestDic setValue:@"1000" forKey:@"limitEnd"];
  [requestDic setValue:crowid forKey:@"crowid"];
  [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetDiseaseListByName
                                                values:requestDic
                                            requestKey:GetDiseaseListByName
                                              delegate:self
                                            controller:self
                                          actiViewFlag:1
                                                 title:nil];
}


/**
 *  //根据症状名搜索症状
 *
 *  @param nameString
 */
- (void)getSymptomsinfoByName:(NSString *)nameString {
  NSString *crowid = @"0001";  //男
  if (manORWoman) {
    //女
    crowid = @"0002";  //女
  }

    
    NSArray *resultArray = [myDBOperation getSymptomListByName:nameString];

    NSLog(@"resultArray:%@", resultArray);
    self.selectedArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.searchResultArray = [NSMutableArray arrayWithArray:resultArray];
    [searchC.searchResultsTableView reloadData];
    
    return;
    
  NSMutableDictionary *requestDic =
      [NSMutableDictionary dictionaryWithCapacity:0];
  [requestDic setValue:nameString forKey:@"name"];
  [requestDic setValue:@"0" forKey:@"limitStart"];
  [requestDic setValue:@"9999" forKey:@"limitEnd"];
  [requestDic setValue:crowid forKey:@"crowid"];


  [[CommonHttpRequest defaultInstance] sendNewPostRequest:GetSymptomsinfoByName
                                                values:requestDic
                                            requestKey:GetSymptomsinfoByName
                                              delegate:self
                                            controller:self
                                          actiViewFlag:1
                                                 title:nil];
}


/**
 *  //根据ID获取疾病信息
 *
 *  @param diseaseId
 */
- (void)getSymptomDiseaseByid:(NSString *)diseaseId {
    
    NSDictionary *resultDic = [myDBOperation getDiseaseInfoById:diseaseId];

    //修改跳转页面
    
    
    NSMutableArray *detailArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *keyArray = @[@"introduction"];
    for(NSString *key in keyArray){
        NSString *value = resultDic[key];
        if(value.length){
            NSDictionary *dic = @{@"title": @"简述",@"content":value};
            [detailArray addObject:dic];
        }
    }
    //    NSArray *detailArray = @[ methodDic, moreDic ];
    SOSDetailViewController *sosDetailVC =
    [[SOSDetailViewController alloc] init];
    sosDetailVC.title = resultDic[@"disease"];
    [sosDetailVC.dataArray addObjectsFromArray:detailArray];
    [self.navigationController pushViewController:sosDetailVC animated:YES];
    [sosDetailVC release];
 
    
    
    
//    NSLog(@"resultArray:%@", resultDic);
//    DiseaseInfoViewController *diseaseInfoVC =
//    [[DiseaseInfoViewController alloc] init];
//    diseaseInfoVC.thirdName = NSLocalizedString(@"症状", nil);
//    NSString *diseaseInfo = resultDic[@"diseaseInfo"];    //简介
//    NSString *diseaseCause = resultDic[@"diseaseCause"];  //病因
//    NSString *symptom = resultDic[@"symptom"];            //症状
//    NSString *diagnose = resultDic[@"diagnose"];          //诊断
//    diseaseInfoVC.title = self.nextPageTitle;
//    diseaseInfoVC.diseaseArray = [NSMutableArray
//                                  arrayWithObjects:diseaseInfo.length > 0 ? diseaseInfo : @"",
//                                  diseaseCause.length > 0 ? diseaseCause : @"",
//                                  symptom.length > 0 ? symptom : @"",
//                                  diagnose.length > 0 ? diagnose : @"", nil];
//    
//    [self.navigationController pushViewController:diseaseInfoVC animated:YES];
//    [diseaseInfoVC release];
    
    
    
    return;
//  [[CommonHttpRequest defaultInstance]
//      sendHttpRequest:[GetSymptomDiseaseByid
//                          stringByAppendingFormat:@"%@", diseaseId]
//           encryptStr:GetSymptomDiseaseByid
//             delegate:self
//           controller:self
//         actiViewFlag:YES
//                title:NSLocalizedString(@"正在获取疾病详细", nil)];
}

- (void)viewWillAppear:(BOOL)animated {
  if (isSearching) {
    if (IOS_7) {
      [[UIApplication sharedApplication]
          setStatusBarStyle:UIStatusBarStyleDefault];
    }
    if (currentSearchType == 0) {
      toCheckButton.hidden = NO;

    } else {
      toCheckButton.hidden = YES;
    }
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  if (IOS_7) {
    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleDefault];
  }  //    if(isSearching){
     //    if(currentSearchType == 0){
     //        toCheckButton.hidden = NO;
     //
     //    }else{
     //        toCheckButton.hidden = YES;
     //    }
     //    }

  toCheckButton.hidden = YES;

  UIView *choiceView = [self.view viewWithTag:99];
  choiceView.alpha = 0;
  //    [choiceView removeFromSuperview];
}
/**
 *  类型选择控制
 *
 *  @param button
 */
- (void)selectType:(UIButton *)button {
  NSLog(@"self.view.frame:%@", NSStringFromCGRect(self.view.frame));

  UIView *choiceView = [self.view viewWithTag:99];  //下拉view

  [self.view bringSubviewToFront:choiceView];

  UIButton *selectBtn = (UIButton *)[choiceView viewWithTag:88];  //下拉里button

  UIButton *showBtn =
      (UIButton *)[searchC.searchBar viewWithTag:77];  //显示button

  UIImageView *arrowImv = (UIImageView *)[showBtn viewWithTag:78];  //箭头

  if (button.tag == 77) {  //开关显示选择框
    [UIView
        animateWithDuration:0.5
                 animations:^{
                     choiceView.alpha = !choiceView.alpha;
                     if (choiceView.alpha == 0) {
                       arrowImv.image = [UIImage
                           imageNamed:@"common.bundle/check/drop_on.png"];
                     } else {
                       arrowImv.image = [UIImage
                           imageNamed:@"common.bundle/check/drop_off.png"];
                       NSString *name = nil;
                       if (currentSearchType == 0) {
                         name = NSLocalizedString(@"疾病", nil);
                       } else {
                         name = NSLocalizedString(@"症状", nil);
                       }

                       [selectBtn setTitle:name forState:UIControlStateNormal];
                     }
                 }];
  } else if (button.tag == 88) {
    //症状

    NSString *name = nil;
    if (currentSearchType == 0) {
      name = NSLocalizedString(@"疾病", nil);
    } else {
      name = NSLocalizedString(@"症状", nil);
    }
    [showBtn setTitle:name forState:UIControlStateNormal];  //修改显示名称
    currentSearchType = !currentSearchType;

    searchC.searchBar.text = @"";

    [UIView animateWithDuration:0.5
                     animations:^{  //消失
                         choiceView.alpha = 0;
                         if (choiceView.alpha == 0) {
                           arrowImv.image = [UIImage
                               imageNamed:@"common.bundle/check/drop_on.png"];
                         }
                     }];
  }

  //    if(isSearching){//处于搜索状态，
  //    if(currentSearchType == 0){
  //        toCheckButton.hidden = NO;
  //
  //    }else{
  //        toCheckButton.hidden = YES;
  //    }
  //    }

  if (isSearching) {
    [searchC.searchBar becomeFirstResponder];
  }

  self.selectedArray =
      [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
  if (isSearching) {
    if (currentSearchType == 0) {
      toCheckButton.hidden = NO;
      //            if(IOS_7){
      //                searchC.searchResultsTableView.frame = CGRectMake(0, 0,
      //                kDeviceWidth, SCREEN_HEIGHT-44);
      //            }else{
      //                searchC.searchResultsTableView.frame = CGRectMake(0, 44,
      //                kDeviceWidth, SCREEN_HEIGHT-44-44);
      //            }
    } else {
      toCheckButton.hidden = YES;

      //            if(IOS_7){
      //                searchC.searchResultsTableView.frame = CGRectMake(0, 0,
      //                kDeviceWidth, SCREEN_HEIGHT);
      //            }else{
      //                searchC.searchResultsTableView.frame = CGRectMake(0, 44,
      //                kDeviceWidth, SCREEN_HEIGHT-44);
      //            }
    }
  }

  //
  //    [self.searchResultArray removeAllObjects];
  //    [searchC.searchResultsTableView reloadData];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [CommonImage colorWithHexString:@"fafafa"];

  currentSearchType = 0;  //症状
  manORWoman = NO;
  normalORColor = NO;

  UISearchBar *searchBar =
      [[UISearchBar alloc] initWithFrame:CGRectMake(0, 54, kDeviceWidth, 40)];
  searchBar.delegate = self;
  searchBar.layer.borderWidth = 0.5f;
  searchBar.layer.borderColor = [CommonImage colorWithHexString:@"e5e5e5"].CGColor;
  //    searchBar.barStyle = uisearchb
  if (IOS_7) {
    searchBar.barTintColor = [CommonImage colorWithHexString:@"e5e5e5"];
  } else {
    searchBar.tintColor = [CommonImage colorWithHexString:@"e5e5e5"];
  }
  //    [searchBar sizeToFit];
  [searchBar setPositionAdjustment:UIOffsetMake(50, 0)
                  forSearchBarIcon:UISearchBarIconSearch];

  UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(58, 7, 1, 30)];
  if (IOS_7) {
  } else {
    showView.frame = CGRectMake(58, 6.5, 1, 29);
  }
  showView.backgroundColor = [CommonImage colorWithHexString:@"e3e3d9"];
  [searchBar addSubview:showView];
  [showView release];

  UIButton *currentSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  currentSearchBtn.frame = CGRectMake(10, 0, 40, 44);
  currentSearchBtn.tag = 77;
  [currentSearchBtn setTitle:NSLocalizedString(@"症状", nil)
                    forState:UIControlStateNormal];
  currentSearchBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
  [currentSearchBtn addTarget:self
                       action:@selector(selectType:)
             forControlEvents:UIControlEventTouchUpInside];
  [currentSearchBtn setTitleColor:[CommonImage colorWithHexString:@"#666666"]
                         forState:UIControlStateNormal];
  [searchBar addSubview:currentSearchBtn];

  UIImageView *triAngleImv = [[UIImageView alloc]
      initWithImage:[UIImage imageNamed:@"common.bundle/check/drop_on.png"]];
  triAngleImv.frame = CGRectMake(35, 17, 8, 8);
  triAngleImv.tag = 78;
  [currentSearchBtn addSubview:triAngleImv];
  [triAngleImv release];

  //    UIImageView *choiceView = [[UIImageView alloc]
  //    initWithFrame:CGRectMake(7,37+64, 52, 30)];
  //   UIImageView *choiceView = [[UIImageView alloc]
  //   initWithFrame:CGRectMake(7,43, 52, 30)];
  //    choiceView.image = [UIImage
  //    imageNamed:@"common.bundle/check/drop_view.png"];

  UIView *choiceView = [[UIView alloc] initWithFrame:CGRectMake(7, 43, 52, 30)];
  choiceView.backgroundColor = [CommonImage colorWithHexString:@"f4f4f4"];
  choiceView.layer.cornerRadius = 2.0f;

  choiceView.tag = 99;
  choiceView.userInteractionEnabled = YES;

  if (IOS_7) {
  } else {
    choiceView.frame = CGRectMake(7, 38, 52, 30);
  }

  //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(8, 30, 34,
  //    1)];
  //    lineView.backgroundColor = [UIColor lightGrayColor];
  //    [choiceView addSubview:lineView];
  //    [lineView release];

  UIButton *choice1 = [UIButton buttonWithType:UIButtonTypeCustom];
  choice1.frame = CGRectMake(5, 0, 40, 30);
  choice1.tag = 88;
  [choice1 setTitle:NSLocalizedString(@"疾病", nil)
           forState:UIControlStateNormal];
  choice1.titleLabel.font = [UIFont systemFontOfSize:12.0f];
  [choice1 addTarget:self
                action:@selector(selectType:)
      forControlEvents:UIControlEventTouchUpInside];
  [choice1 setTitleColor:[CommonImage colorWithHexString:@"#666666"]
                forState:UIControlStateNormal];
  [choiceView addSubview:choice1];
  //    UIButton *choice2 = [UIButton buttonWithType:UIButtonTypeCustom];
  //    choice2.frame = CGRectMake(5, 30, 40, 30);
  //    choice2.tag = 66;
  //    [choice2 setTitle:@"疾病" forState:UIControlStateNormal];
  //    choice2.titleLabel.font = [UIFont systemFontOfSize:12.0f];
  //    [choice2 addTarget:self action:@selector(selectType:)
  //    forControlEvents:UIControlEventTouchUpInside];
  //    [choice2 setTitleColor:[CommonImage colorWithHexString:@"#666666"]
  //    forState:UIControlStateNormal];
  //    [choiceView addSubview:choice2];

  choiceView.alpha = 0;
  [self.view addSubview:choiceView];
  //    [[[[UIApplication sharedApplication] delegate] window]
  //    addSubview:choiceView];
  [choiceView release];

  searchC = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                              contentsController:self];
  searchC.delegate = self;
  searchC.searchResultsDelegate = self;
  searchC.searchResultsDataSource = self;
  //    searchC.searchResultsTableView.backgroundColor = [UIColor clearColor];
  searchC.searchResultsTableView.frame =
      CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT - 100);
  //    searchBar.placeholder = @"请输入您要查询的病症 例如：头痛";
    [Common setExtraCellLineHidden:searchC.searchResultsTableView];
  searchBar.backgroundColor = [UIColor clearColor];

  UITableView *allTableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, kDeviceWidth, SCREEN_HEIGHT)];
  allTableView.tableHeaderView = searchBar;
  allTableView.scrollEnabled = NO;
  allTableView.bounces = NO;
  allTableView.backgroundColor = [CommonImage colorWithHexString:@"fafafa"];
  allTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:allTableView];
  [allTableView release];
  [self.view bringSubviewToFront:choiceView];

  //诊断按钮
  toCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
  toCheckButton.frame = CGRectMake(20, SCREEN_HEIGHT + 20 - 40, 280, 33);
  toCheckButton.layer.cornerRadius = 4.0f;
  [[UIApplication sharedApplication].delegate.window addSubview:toCheckButton];
  [APP_DELEGATE bringSubviewToFront:toCheckButton];

  UIImage* image =  [CommonImage createImageWithColor:[CommonImage colorWithHexString:COLOR_FF5351]];
  [toCheckButton setBackgroundImage:image forState:UIControlStateNormal];
  [toCheckButton addTarget:self
                    action:@selector(sendToDiagnosis:)
          forControlEvents:UIControlEventTouchUpInside];
  [toCheckButton setTitle:NSLocalizedString(@"诊断", nil)
                 forState:UIControlStateNormal];

  toCheckButton.hidden = YES;

  //    (88, 21, 169, 375) oldsize
  //    CGFloat width = 335;
  //    CGFloat width = (169 * heitht) / 375;

  UIView *view = nil;
  CGFloat bodyImageY = 61;
  CGFloat btnOffsetY = 0;
  if (!IS_4_INCH_SCREEN) {
    // 3.5寸

    UIScrollView *bodyScrollView = [[UIScrollView alloc]
        initWithFrame:CGRectMake(0, 50, kDeviceWidth,
                                 SCREEN_HEIGHT - 44 - 50)];

    bodyScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bodyScrollView];
    [bodyScrollView release];
    bodyScrollView.userInteractionEnabled = YES;
    bodyScrollView.contentSize =
        CGSizeMake(kDeviceWidth, SCREEN_HEIGHT - 44 - 50 - 10);
    bodyImageY = 3;
    btnOffsetY = 40;
    view = bodyScrollView;

    UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tapFunc:)];
    [bodyScrollView addGestureRecognizer:tapGesture];
    [tapGesture release];

  } else {
    view = self.view;
  }

  bodyImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(120, bodyImageY, 160, 336)];
  bodyImageView.image =
      [UIImage imageNamed:@"common.bundle/check/man_Positive_nor@2x.png"];
  //    [self.view addSubview:bodyImageView];
  [view addSubview:bodyImageView];
  bodyImageView.userInteractionEnabled = YES;

  //选中点
  //    NSString *imageName = nil;
  //    if(VERSION_INFO){
  //        imageName = @"img.bundle/check/tip_p.png";
  //    }else{
  //        imageName =  @"common.bundle/check/gs/tip_p.png";
  //    }
  //    selectedPointImageView = [[UIImageView alloc] initWithImage:[UIImage
  //    imageNamed:imageName]];
  selectedPointImageView =
      [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
  selectedPointImageView.layer.cornerRadius = 6;
  selectedPointImageView.backgroundColor =
      [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
  //    [self.view addSubview:selectedPointImageView];
  [view addSubview:selectedPointImageView];
  [selectedPointImageView setAlpha:0.0f];

  //男女转换
  UIButton *manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  manBtn.frame = CGRectMake(18, 285 - btnOffsetY, 75, 30);
  [manBtn
      setImage:[UIImage imageNamed:@"common.bundle/check/btn_man_nor@2x.png"]
      forState:UIControlStateNormal];
  [manBtn
      setImage:[UIImage imageNamed:@"common.bundle/check/btn_man_nor@2x.png"]
      forState:UIControlStateHighlighted];
  manBtn.layer.cornerRadius = 8.0f;
  [manBtn addTarget:self
                action:@selector(changeMan:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:manBtn];

  //正反转换
  UIButton *posBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  posBackBtn.frame = CGRectMake(18, 323 - btnOffsetY, 75, 30);
  posBackBtn.backgroundColor = [CommonImage colorWithHexString:@"#5cadff"];
  posBackBtn.layer.cornerRadius = 4;
  [posBackBtn setTitle:NSLocalizedString(@"正面", nil)
              forState:UIControlStateNormal];
    posBackBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 20);
  posBackBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
  [posBackBtn addTarget:self
                 action:@selector(changePosOrBack:)
       forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:posBackBtn];
    
    UIImageView *exchangeImv = [[UIImageView alloc] initWithFrame:CGRectMake(55, 7, 10, 14)];
    exchangeImv.image = [UIImage imageNamed:@"common.bundle/check/exchange.png"];
    [posBackBtn addSubview:exchangeImv];
    [exchangeImv release];
    
    

  //文字
  wordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  wordBtn.frame = CGRectMake(18, 331 + 30 - btnOffsetY, 75, 30);
  wordBtn.backgroundColor = [UIColor colorWithRed:204 / 255.f
                                            green:204 / 255.f
                                             blue:204 / 255.f
                                            alpha:1];
  [wordBtn setTitle:NSLocalizedString(@"文字", nil)
           forState:UIControlStateNormal];
    wordBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
  wordBtn.layer.cornerRadius = 4.0f;
  wordBtn.alpha = 1;
  [wordBtn addTarget:self
                action:@selector(getAllSymptoSecondBodyPartByType)
      forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:wordBtn];

  //    [self getAllSymptomBodyPartByType];
    
    bodyImageView.hidden = YES;
    wordBtn.hidden = YES;
    posBackBtn.hidden = YES;
    manBtn.hidden = YES;
    
    
    
}

#pragma mark - UITableViewDelegate And DataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"checkCell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        if(currentSearchType == 0){
    UIImageView *selectedImageView = [[UIImageView alloc]
        initWithImage:[UIImage
                          imageNamed:@"common.bundle/check/selected_off.png"]];
    selectedImageView.frame = CGRectMake(0, 0, 18, 18);
    selectedImageView.tag = 33;
    selectedImageView.hidden = NO;
    [cell addSubview:selectedImageView];
    [selectedImageView release];
    UIProgressView *progressView =
        [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
    progressView.progressViewStyle = UIProgressViewStyleBar;
    progressView.tag = 34;
    progressView.layer.borderColor =
        [[CommonImage colorWithHexString:VERSION_TEXT_COLOR] CGColor];
    progressView.layer.borderWidth = 0.5;
    progressView.layer.cornerRadius = 5;
    progressView.hidden = NO;
    progressView.progressTintColor =
        [CommonImage colorWithHexString:VERSION_TEXT_COLOR];
    progressView.trackTintColor = [UIColor whiteColor];
    [cell addSubview:progressView];
    [progressView release];
    cell.accessoryView = progressView;
    cell.accessoryView.hidden = YES;
  }

  //搜索
  NSDictionary *symptomDic = self.searchResultArray[indexPath.row];

  UIImageView *selectedImageView = (UIImageView *)[cell viewWithTag:33];
  UIProgressView *progressView = (UIProgressView *)[cell viewWithTag:34];
    progressView.hidden = YES;

  CGRect frame = cell.textLabel.frame;
  frame.size.width = 200;
  cell.textLabel.frame = frame;
  cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
  cell.textLabel.textColor = [CommonImage colorWithHexString:@"#333333"];

  if (currentSearchType == 0) {
    selectedImageView.hidden = NO;
    progressView.hidden = YES;
    //        progressView.center = cell.accessoryView.center;
    //        cell.accessoryView = [selectedImageView retain];
    selectedImageView.center = CGPointMake(290, 22);
    cell.textLabel.text = symptomDic[@"symptomName"];
    if ([self.selectedArray containsObject:symptomDic]) {
      //将颜色置为绿色
      NSString *imageName = nil;
      //            if(VERSION_INFO){
      imageName = @"img.bundle/answer/selected_on.png";
      //            }else{
      //                imageName = @"img.bundle/answer/selected_blue_on.png";
      //            }

      selectedImageView.image = [UIImage imageNamed:imageName];
    } else {
      selectedImageView.image =
          [UIImage imageNamed:@"common.bundle/check/selected_off.png"];
    }
  } else {
    selectedImageView.hidden = YES;
//    progressView.hidden = NO;
      progressView.hidden = YES;//2.1数据库中无该字段
    progressView.center = CGPointMake(280, 22);
    cell.textLabel.text = symptomDic[@"diseaseName"];
    progressView.progress = [symptomDic[@"radio"] floatValue] / 100;
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

  UIImageView *selectedImageView = (UIImageView *)[cell viewWithTag:33];

  NSDictionary *selectedDic = self.searchResultArray[indexPath.row];

  if (currentSearchType == 0) {
    if ([self.selectedArray containsObject:selectedDic]) {
      //已经有了，移除掉，并将颜色置为灰色
      [self.selectedArray removeObject:selectedDic];
      //        UIImageView *accessView = (UIImageView *)cell.accessoryView;
      selectedImageView.image =
          [UIImage imageNamed:@"common.bundle/check/selected_off.png"];
    } else {
      [self.selectedArray addObject:selectedDic];
      //        UIImageView *accessView = (UIImageView *)cell.accessoryView;

      NSString *imageName = nil;
      imageName = @"img.bundle/answer/selected_on.png";
      selectedImageView.image = [UIImage imageNamed:imageName];
    }
  } else {
    //调到疾病详情
    self.nextPageTitle = selectedDic[@"diseaseName"];

    [self getSymptomDiseaseByid:selectedDic[@"id"]];
  }
}
/**
 *  人体图切换处理函数
 *
 *  @param positiveBackBtn
 */
- (void)changePosOrBack:(UIButton *)positiveBackBtn {
  normalORColor = !normalORColor;
  if (normalORColor) {  //反面

    [positiveBackBtn setTitle:NSLocalizedString(@"背面", nil)
                     forState:UIControlStateNormal];
    if (!manORWoman) {
      //男
      bodyImageView.image =
          [UIImage imageNamed:@"common.bundle/check/man_Back_nor@2x.png"];

    } else {
      //女
      bodyImageView.image =
          [UIImage imageNamed:@"common.bundle/check/woman_Back_nor@2x.png"];
    }

  } else {
    //正面
    [positiveBackBtn setTitle:NSLocalizedString(@"正面", nil)
                     forState:UIControlStateNormal];
    if (!manORWoman) {
      //男
      bodyImageView.image =
          [UIImage imageNamed:@"common.bundle/check/man_Positive_nor@2x.png"];

    } else {
      //女
      bodyImageView.image =
          [UIImage imageNamed:@"common.bundle/check/woman_Positive_nor@2x.png"];
    }
  }
}
//男女变换
- (void)changeMan:(UIButton *)manBtn {
  manORWoman = !manORWoman;

  if (manORWoman) {
    //女的
    if (!normalORColor)  //正面---0
      bodyImageView.image =
          [UIImage imageNamed:@"common.bundle/check/woman_Positive_nor@2x.png"];
    else  //反面
      bodyImageView.image =
          [UIImage imageNamed:@"common.bundle/check/woman_Back_nor@2x.png"];

    [manBtn setImage:[UIImage
                         imageNamed:@"common.bundle/check/btn_woman_nor@2x.png"]
            forState:UIControlStateNormal];
    [manBtn setImage:[UIImage
                         imageNamed:@"common.bundle/check/btn_woman_nor@2x.png"]
            forState:UIControlStateHighlighted];

  } else {
    //男的
    if (!normalORColor)  //正面--0
      bodyImageView.image =
          [UIImage imageNamed:@"common.bundle/check/man_Positive_nor@2x.png"];
    else  //反面
      bodyImageView.image =
          [UIImage imageNamed:@"common.bundle/check/man_Back_nor@2x.png"];

    [manBtn
        setImage:[UIImage imageNamed:@"common.bundle/check/btn_man_nor@2x.png"]
        forState:UIControlStateNormal];
    [manBtn
        setImage:[UIImage imageNamed:@"common.bundle/check/btn_man_nor@2x.png"]
        forState:UIControlStateHighlighted];
  }
}

#pragma mark - 推出下一页面  + 颜色值
- (void)pushNextPageWithbodyId:(NSString *)bodyId {
  //部位翻译在此
  //    bodyId = @"0003";
  //根据一级身体部位编号查询二级身体部位列表

  [self getAllSymptomBodyPartParentPartWithParentPartId:bodyId];
}

#pragma mark - 点击

- (void)tapFunc:(UITapGestureRecognizer *)tapGesture {
  if (isSearching) {
    return;
  }

  if (requestFlag) {
    return;  //正在请求则返回
  }
  //关闭选择view
  UIView *choiceView = [self.view viewWithTag:99];
  if (choiceView.alpha == 1) {
    choiceView.alpha = 0;
    UIButton *showBtn =
        (UIButton *)[searchC.searchBar viewWithTag:77];  //显示button
    UIImageView *arrowImv = (UIImageView *)[showBtn viewWithTag:78];  //箭头
    arrowImv.image = [UIImage imageNamed:@"common.bundle/check/drop_on.png"];
  }

  //    CGPoint viewPoint = [[touches anyObject]locationInView:self.view];
  //	CGPoint point = [[touches anyObject] locationInView:bodyImageView];

  CGPoint viewPoint = [tapGesture locationInView:tapGesture.view];
  CGPoint point = [tapGesture locationInView:bodyImageView];

  NSString *imageName = nil;

  NSDictionary *currentDic = nil;
  if (manORWoman) {
    //女
    currentDic = womanColorTobodyDic();
    if (normalORColor) {
      //反
      imageName = @"common.bundle/check/woman_Back_pre.png";

    } else {
      //正
      imageName = @"common.bundle/check/woman_Positive_pre.png";
    }

  } else {
    //男
    currentDic = manColorTobodyDic();
    if (normalORColor) {
      //反
      imageName = @"common.bundle/check/man_Back_pre.png";

    } else {
      //正
      imageName = @"common.bundle/check/man_Positive_pre.png";
    }
  }

  UIImage *image = [UIImage imageNamed:imageName];  //这个名字需要根据具体获得

  //    CGColorRef pixelColor = [[image colorAtPixel:point] CGColor];

  CGSize size = image.size;

  if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, size.width, size.height),
                           point)) {
    return;
  }

  //	int width=CGImageGetWidth(imageref);
  //    int height=CGImageGetHeight(imageref);

  NSInteger pointX = trunc(point.x);
  NSInteger pointY = trunc(point.y);
  CGImageRef cgImage = image.CGImage;
  NSUInteger width = size.width;
  NSUInteger height = size.height;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  int bytesPerPixel = 4;
  int bytesPerRow = bytesPerPixel * 1;
  NSUInteger bitsPerComponent = 8;
  unsigned char pixelData[4] = {0, 0, 0, 0};
  CGContextRef context = CGBitmapContextCreate(
      pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace,
      kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(colorSpace);
  CGContextSetBlendMode(context, kCGBlendModeCopy);

  // Draw the pixel we are interested in onto the bitmap context
  CGContextTranslateCTM(context, -pointX, pointY - (CGFloat)height);
  CGContextDrawImage(context,
                     CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height),
                     cgImage);
  CGContextRelease(context);

  NSLog(@"%f", (CGFloat)pixelData[0]);
  NSLog(@"%f", (CGFloat)pixelData[1]);
  NSLog(@"%f", (CGFloat)pixelData[2]);

  NSString *hexString = [self transfromToHexStringWithR:(CGFloat)pixelData[0]
                                               andWithG:(CGFloat)pixelData[1]
                                               andWithB:(CGFloat)pixelData[2]];
  NSLog(@"hexstring%@", hexString);
  if ([hexString isEqualToString:@"#000000"]) {
    return;
  }
  if (currentDic[hexString] == nil) {
    //在对应表中得不到转码，做不识别处理
    return;
  }

  requestFlag = YES;  //开启请求开关

  //添加动画
  selectedPointImageView.center = viewPoint;

  [UIView animateWithDuration:0.6
      animations:^{ selectedPointImageView.alpha = 1; }
      completion:^(BOOL finished) {

          NSString *bodyID = currentDic[hexString];
          currentBodyID = (int)[bodyID integerValue];  //目前只用来过滤男女某些不同
          [self pushNextPageWithbodyId:bodyID];
          selectedPointImageView.alpha = 0;
      }];
}

/**
 *  点击响应函数，获得具体部位
 *
 *  @param touches
 *  @param event
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if (isSearching) {
    return;
  }

  if (requestFlag) {
    return;  //正在请求则返回
  }
  //关闭选择view
  UIView *choiceView = [self.view viewWithTag:99];
  if (choiceView.alpha == 1) {
    choiceView.alpha = 0;
    UIButton *showBtn =
        (UIButton *)[searchC.searchBar viewWithTag:77];  //显示button
    UIImageView *arrowImv = (UIImageView *)[showBtn viewWithTag:78];  //箭头
    arrowImv.image = [UIImage imageNamed:@"common.bundle/check/drop_on.png"];
  }

  CGPoint viewPoint = [[touches anyObject] locationInView:self.view];
  CGPoint point = [[touches anyObject] locationInView:bodyImageView];
  NSString *imageName = nil;

  NSDictionary *currentDic = nil;
  if (manORWoman) {
    //女
    currentDic = womanColorTobodyDic();
    if (normalORColor) {
      //反
      imageName = @"common.bundle/check/woman_Back_pre.png";

    } else {
      //正
      imageName = @"common.bundle/check/woman_Positive_pre.png";
    }

  } else {
    //男
    currentDic = manColorTobodyDic();
    if (normalORColor) {
      //反
      imageName = @"common.bundle/check/man_Back_pre.png";

    } else {
      //正
      imageName = @"common.bundle/check/man_Positive_pre.png";
    }
  }

  UIImage *image = [UIImage imageNamed:imageName];  //这个名字需要根据具体获得

  //    CGColorRef pixelColor = [[image colorAtPixel:point] CGColor];

  CGSize size = image.size;

  if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, size.width, size.height),
                           point)) {
    return;
  }

  //	int width=CGImageGetWidth(imageref);
  //    int height=CGImageGetHeight(imageref);

  NSInteger pointX = trunc(point.x);
  NSInteger pointY = trunc(point.y);
  CGImageRef cgImage = image.CGImage;
  NSUInteger width = size.width;
  NSUInteger height = size.height;
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  int bytesPerPixel = 4;
  int bytesPerRow = bytesPerPixel * 1;
  NSUInteger bitsPerComponent = 8;
  unsigned char pixelData[4] = {0, 0, 0, 0};
  CGContextRef context = CGBitmapContextCreate(
      pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace,
      kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(colorSpace);
  CGContextSetBlendMode(context, kCGBlendModeCopy);

  // Draw the pixel we are interested in onto the bitmap context
  CGContextTranslateCTM(context, -pointX, pointY - (CGFloat)height);
  CGContextDrawImage(context,
                     CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height),
                     cgImage);
  CGContextRelease(context);

  NSLog(@"%f", (CGFloat)pixelData[0]);
  NSLog(@"%f", (CGFloat)pixelData[1]);
  NSLog(@"%f", (CGFloat)pixelData[2]);

  NSString *hexString = [self transfromToHexStringWithR:(CGFloat)pixelData[0]
                                               andWithG:(CGFloat)pixelData[1]
                                               andWithB:(CGFloat)pixelData[2]];
  NSLog(@"hexstring%@", hexString);
  if ([hexString isEqualToString:@"#000000"]) {
    return;
  }
  if (currentDic[hexString] == nil) {
    //在对应表中得不到转码，做不识别处理
    return;
  }

  requestFlag = YES;  //开启请求开关

  //添加动画
  selectedPointImageView.center = viewPoint;

  CGRect pathFrame = CGRectMake(-CGRectGetMidX(selectedPointImageView.bounds),
                                -CGRectGetMidY(selectedPointImageView.bounds),
                                selectedPointImageView.bounds.size.width,
                                selectedPointImageView.bounds.size.height);
  UIBezierPath *path = [UIBezierPath
      bezierPathWithRoundedRect:pathFrame
                   cornerRadius:selectedPointImageView.layer.cornerRadius];
  // accounts for left/right offset and contentOffset of scroll view
  CGPoint shapePosition =
      CGPointMake(CGRectGetMidX(selectedPointImageView.bounds),
                  CGRectGetMidY(selectedPointImageView.bounds));

  CAShapeLayer *circleShape = [CAShapeLayer layer];
  circleShape.path = path.CGPath;
  circleShape.position = shapePosition;
  circleShape.fillColor = [UIColor clearColor].CGColor;
  circleShape.opacity = 0;
  circleShape.strokeColor =
      [CommonImage colorWithHexString:VERSION_TEXT_COLOR].CGColor;
  circleShape.lineWidth = 1;

  [selectedPointImageView.layer addSublayer:circleShape];
  CABasicAnimation *scaleAnimation =
      [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  scaleAnimation.fromValue =
      [NSValue valueWithCATransform3D:CATransform3DIdentity];
  scaleAnimation.toValue =
      [NSValue valueWithCATransform3D:CATransform3DMakeScale(2.5, 2.5, 1)];

  CABasicAnimation *alphaAnimation =
      [CABasicAnimation animationWithKeyPath:@"opacity"];
  alphaAnimation.fromValue = @1;
  alphaAnimation.toValue = @0;

  CAAnimationGroup *animation = [CAAnimationGroup animation];
  animation.animations = @[ scaleAnimation, alphaAnimation ];
  animation.duration = 2.0f;
  animation.timingFunction =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [circleShape addAnimation:animation forKey:nil];

  [UIView animateWithDuration:0.6
      animations:^{ selectedPointImageView.alpha = 1; }
      completion:^(BOOL finished) {

          NSString *bodyID = currentDic[hexString];
          currentBodyID = (int)[bodyID integerValue];  //目前只用来过滤男女某些不同
          [self pushNextPageWithbodyId:bodyID];
          selectedPointImageView.alpha = 0;
      }];
}

/**
 *  根据RGB获得颜色值
 *
 *  @param r
 *  @param g
 *  @param b
 *
 *  @return
 */
- (NSString *)transfromToHexStringWithR:(CGFloat)r
                               andWithG:(CGFloat)g
                               andWithB:(CGFloat)b {
  NSString *hexString = [self ToHex:r];
  hexString = [NSString stringWithFormat:@"#%@%@", hexString, [self ToHex:g]];
  hexString = [NSString stringWithFormat:@"%@%@", hexString, [self ToHex:b]];
  return hexString;
}

- (NSString *)ToHex:(int)tmpid {
  NSString *nLetterValue;
  NSString *str = @"";
  int ttmpig;
  for (int i = 0; i < 9; i++) {
    ttmpig = tmpid % 16;
    tmpid = tmpid / 16;
    switch (ttmpig) {
      case 10:
        nLetterValue = @"a";
        break;
      case 11:
        nLetterValue = @"b";
        break;
      case 12:
        nLetterValue = @"c";
        break;
      case 13:
        nLetterValue = @"d";
        break;
      case 14:
        nLetterValue = @"e";
        break;
      case 15:
        nLetterValue = @"f";
        break;
      default:
        nLetterValue = [NSString stringWithFormat:@"%d", ttmpig];
    }
    str = [nLetterValue stringByAppendingString:str];
    if (tmpid == 0) {
      if (i == 0) {
        str = [NSString stringWithFormat:@"0%@", str];
      }
      break;
    }
  }
  if (str.length == 1) {
    str = [NSString stringWithFormat:@"%@0", str];
  }
  NSLog(@"%@", str);
  return str;
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
