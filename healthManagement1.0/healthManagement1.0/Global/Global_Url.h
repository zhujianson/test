//
//  Global_Url.h
//  jiuhaohealth4.1
//
//  Created by xjs on 15/9/9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#ifndef jiuhaohealth4_1_Global_Url_h
#define jiuhaohealth4_1_Global_Url_h

//#define SERVER_URL @"http://192.168.0.74:8080"
//#define SERVER_URL @"http://192.168.0.92:8080"
//#define SERVER_URL @"http://192.168.0.146:8080"
//#define SERVER_URL @"http://192.168.0.58:8081"
//#define SERVER_URL @"http://192.168.0.171:8080"
//#define SERVER_URL @"http://192.168.0.40:8080/api_server"
//#define SERVER_URL @"http://192.168.0.187:8080"
//#define SERVER_URL @"http://192.168.2.18:8080/api_server"
//#define SERVER_URL @"http://192.168.0.139:8080/api_server"
//#define SERVER_URL @"http://192.168.0.30/jiuhao-api"
//#define SERVER_URL @"http://192.168.0.72:8080"
//#define SERVER_URL @"http://v4.api.kangxun360.com"
//#define SERVER_URL @"http://new.test.kangxun365.com"
//#define SERVER_URL @"http://192.168.0.171:8077"

//#define  KXDEBUG 1

#ifdef KXDEBUG

#define SERVER_URL           @"http://new.test.kangxun365.com"
//#define SERVER_URL           @"http://192.168.0.62:8080"
#define WX_KANGXUN_URL		 @"http://wx.kangxun365.com/static/"
//支付结果回调页面
#define kWXNOTIFY_URL        @"http://kxpay.kangxun365.com/charge/sendWXGoods"//测试
//回调地址
#define kAliNotify_url       @"http://kxpay.kangxun365.com/charge/sendGoods"

#else

#define SERVER_URL           @"http://v4.api.kangxun360.com"
#define WX_KANGXUN_URL		 @"http://wx.kangxun360.com/static/"
#define kWXNOTIFY_URL        @"http://kxpay.kangxun360.com/charge/sendWXGoods"//正式
#define kAliNotify_url       @"http://kxpay.kangxun360.com/charge/sendGoods"

#endif


#define Share_Server_URL            [WX_KANGXUN_URL stringByAppendingString:@"share_kangxun360/"]


//#define NOTICE_DETAIL_URL			@"http://admin.kangxun360.com/"
#define NOTICE_DETAIL_URL			@"http://admin.kangxun365.com/"


#define HEALP_SERVER_LEVEL @"http://wx.kangxun360.com/static/intro/level.html" //等级说明
#define HEALP_SERVER_BINGDING @"http://wx.kangxun360.com/static/intro/bindingEquipmentHelp.html" //设备绑定说明
#define HEALP_SERVER_BLOOD @"http://wx.kangxun360.com/static/intro/bloodSugarTime.html" //血糖监测说明
#define HEALP_SERVER_NEW @"http://wx.kangxun360.com/static/intro/index.html" //新手指南
#define HEALP_SERVER_POINTDES @"http://wx.kangxun360.com/static/intro/pointDes.html" //积分说明
#define HEALP_SERVER_REFERENCE @"http://wx.kangxun360.com/static/intro/reference.html" //管理目标说明
#define HEALP_SERVER_SPORT @"http://wx.kangxun360.com/static/intro/sport.html" //糖友运动小贴士
#define HEALP_SERVER_integralStore @"http://wx.kangxun360.com/static/points/index.html?token=" //积分商城
#define HEALP_SERVER_ABOURT @"http://wx.kangxun360.com/static/intro/about.html" //关于我们
#define HEALP_SERVER_POINTDES_New @"http://wx.kangxun360.com/static/share_kangxun360/point_detail.html?token=" //积分说明New
#define MYARCHIVES_SERVER @"http://wx.kangxun360.com/static/app/report/list.html?token=" //我的档案

#define REQUEST_PAGE_NUM @"20"

//七牛下载图片前缀
#define QINIUURL @"http://7mnn49.com2.z0.glb.clouddn.com/"
//#define QINIUURL1 @"http://7mnn49.com2.z0.glb.clouddn.com"


//发送消息到服务器
#define UploadUserTokenId   @"/user/uploaduserTokenid"

//查有没有新版本
#define versioncheck_xhtml @"/app/versioncheck.xhtml"

/* 热线电话  */
#define HOTLINEPHONE @"400-015-9595"

/* 登录 */
#define LOGIN_API_URL @"/api/user/login"

//发帖
#define ADDGROUP_POST_URL @"/api/group/addGroupPost"

//校验第三方是否存在
#define LOGIN_API_THIRD @"/api/user/third/login"

/* 注册 */
#define REGISTER_API_URL @"/api/sms/request_code"

/* 判断手机号是否存在 */
#define CHECKPHOTO_API_URL @"/api/user/check_phone"

/* 获取信息 */
#define GETMYINFO_API_URL @"/api/user/info/index"

//完善信息－－－个人
#define DIABETIC_API_URL @"/api/user/info/submit_reg"

//完善信息－－－家人
#define DIABETIC_Fam_API_URL @"/api/user/info/submit_fr_reg"

//修改信息
#define UPDATAField_API_URL @"/api/user/info/m_info_field"

/* 注册第二步 */
#define REGISTER_APITWO_URL @"/user/registerStep2.xhtml"

/* 注册第3步 */
#define REGISTER_APITHREE_URL @"/api/user/reg"

/* 设备绑定 */
#define REGISTER_APIFIVE_URL @"/api/user/info/device/bind"

/* 手机找回密码 */
#define EMAIL_API_URL @"/user/getPwdByPhone.xhtml"

/* 手机找回密码第二步 */
#define EMAILTWO_API_URL @"/api/sms/check_code"

/* 第三方登录绑定手机填写密码 */
#define EMAILTHREE_API_URL @"/api/user/reset_pwd"

/* 修改密码 */
#define UPDATE_USER_PWD @"/api/user/info/modify_pwd"

//家庭成员列表
#define GET_FAMILY_LIST_BY_USERID @"/api/user/info/family/list"

//删除家庭成员
#define DELETEFAMILYINFO @"/api/user/info/family/del"

//修改家庭成员信息
#define UPDATE_FAMILY_INFO @"/family/mod.xhtml"

//发送验证麻
#define SEND_EMAIL_CODE @"/user/bindEmail.xhtml"

//验证邮箱或手机绑定接口
#define validateBind @"/api/user/info/bind_mobile"

//发送验证第三方第三方登录绑定手机号第一步接口说明
#define SEND_THIRD_STEP_ONE @"/user/thirdAccountBindPhoneStep1.xhtml"

//发送验证第三方第三方登录绑定手机号第二步接口说明
#define SEND_THIRD_STEP_TWO @"/user/thirdAccountBindPhoneStep2.xhtml"

//发送验证第三方第三方登录绑定手机号第三步接口说明
#define SEND_THIRD_STEP_THREE @"/user/thirdAccountBindPhoneStep3.xhtml"

//修改用户信息
#define UPDATE_USER_INFO @"/user/mod.xhtml"

//首页
#define GET_HOME_DATA @"/news/getHomeNews.xhtml"

//判断是否第一次进入配餐
#define GET_JUDGE_CATERING @"/food/getCheckUserBasicInfo.xhtml"

//获取个人基本信息
#define GET_PERSONAL_BASIC @"/food/getUserActivityInfo.xhtml"

//添加家庭成员
#define ADD_FAMILY @"/api/user/info/family/add"

//顾问信息
#define SHOW_CONSULT_INFO @"/doctor/getDoctorDetailByid.xhtml"

//获取广告数据
#define GET_ADVERT_LIST @"/advert/getAdvert.xhtml"

//获取所有的话题
#define GET_ALL_POST_LIST @"/post/getAllPostList.xhtml"

//获取某个医生下班所有的帖子
#define GET_POSTLISTBYDOCTORID @"/post/getPostListByDoctorid.xhtml"

//更新本地数据库
#define UPDATE_DATA_DB @"/applocallib/sync.xhtml"

//统计
#define Send_Log @"/logger/sendLog.xhtml"

//会员申请接口
#define applyBind_XHTML @"/applyBind/user/applyBind.xhtml"

//后台启动获取积分
#define getPointsByChannel @"/point/getPointsByChannel.xhtml"

//获取商铺列表
#define URL_getCommunityList @"/api/group/getGroupList"


#pragma make ---
//获取token
#define GET_QINIU_TOKEN @"/api/tertiary/getQiNiuToken"


//设置首页各个模块的顺序
#define SET_HOME_SEQUENCE @"/news/setHomeSequence.xhtml"

//获得用户信息
#define GETUSERINFO @"/assistant/home/getAssistantInfoByAssistantid/"

/* 获取好友信息 */
#define GET_FRIENDDETAIL @"/docapp/getUserInfoByQrCode.xhtml"

//健康自查

/* 修改个人基本信息 */
#define UPDATE_MYDATA @"/food/updateUserInfo.xhtml"

//根据类型查询一级身体部位接口
#define GetAllSymptoBodyPartByType  @"/user/selfttest/getAllSymptomBodyPartByType/"

//根据类型查询二级身体部位接口
#define GetAllSymptoSecondBodyPartByType  @"/user/selfttest/getAllSymptomBodyPartByType/"


//根据部位ID获取当前部位及相关联的子部位
#define GetAllSymptomBodyPartParentPart  @"/user/selfttest/getAllSymptomBodyPartParentPart/"

//根据部位ID查询所有关联症状信息列表
#define GetSymptomsinfoBybodyPart  @"/user/selfttest/getSymptomsinfoBybodyPart/"

//获取症状的相关疾病列表
#define  GetSymptomsDiseaseBysymptomids @"/user/selfttest/getSymptomsDiseaseBysymptomids"

//根据ID获取疾病信息

#define   GetSymptomDiseaseByid    @"/user/selfttest/getSymptomDiseaseByid/"

//获得人群编号
#define GetAllSymptomCrowd          @"/user/selfttest/getAllSymptomCrowd"

//根据人群获得症状

#define GetSymptomsinfoByCrowd  @"/user/selfttest/getSymptomsinfoByCrowd/"

//查询症状详细

#define GetSymptomsinfoById  @"/user/selfttest/getSymptomsinfoById/"

//根据名称模糊搜索症状
#define GetSymptomsinfoByName  @"/user/selfttest/getSymptomsinfoByName"

//根据名称模糊搜索疾病
#define GetDiseaseListByName  @"/user/selfttest/getSymptomsDiseaseByName"

//添加评论
#define GET_ADDCOMMENT_BY_DETAIL @"/discuss/addDiscuss.xhtml"

//添加收藏
#define GET_ADDFAVORITE_BY_DETAIL @"/myfavorite/addFavorite.xhtml"

//取消收藏
#define GET_CANCELFAVORITE_BY_DETAIL @"/myfavorite/cancleFavorite.xhtml"

//点赞
#define GET_ADDPRAISE_BY_DETAIL @"/hug/addHug.xhtml"

//取消点赞
#define GET_DELAGATEPRAISE_BY_DETAIL @"/hug/delHug.xhtml"

//删除消息
#define GET_MYMESSAGEDELETE_BY_ID @"/mymessage/deleteByid.xhtml"

//消息标记以读
#define GET_UPDATEMYMESSAGE_BY_ID @"/mymessage/updateToRead.xhtml"

//意见反馈
#define FEEDBACK_BY_USERID @"/api/feedback/add"


/**
 *  新闻接口
 */

#define NEWS_List @"/news/getNewsList.xhtml"
#define NEWS_Detail @"/news/getNewsByid.xhtml"
#define NEWS_Title @"/news/getSubfieldList.xhtml"

//新闻广告
#define NEWS_Advertising @"/news/getNewsAdvert.xhtml"

/**
 *  话题接口
 *
 */
#define Get_One_Expert_Topic_List @"/theme/getThemeDetailsList.xhtml"

/**
 *  我的信箱接口
 */
//系统信息详细
#define SystemDetail @"/sysmsg/view/"

#define GetDiaryHistory @"/api/record/statistics"

// 记一下
#define FAMILY_List @"/family/list.xhtml"

// 饮食推荐首页接口
#define GET_FOODHOME @"/food/getFoodHome.xhtml"

// 每日饮食推荐详情
#define GET_FOODHOME_DETAIl @"/food/foodsRecommendedDaily.xhtml"

//订阅期数
#define GETPROGRESS_PLAN_BY_ID @"/planuser/planListInfo.xhtml"


//订阅或取消订阅
#define SUBSCRIBE_PLAN_BY_ID @"/planuser/subscribe.xhtml"

//订阅人数
#define PERPLOE_PLAN_BY_ID @"/planuser/planUserCount.xhtml"

//查看评论列表接口说明
#define GET_COMMONTLIST @"/discuss/getDiscussListByid.xhtml"

//评论人
#define SEND_COMMONTTOPERSON @"/discuss/addDiscussDetail.xhtml"

//点赞接口
#define SEND_SUPPORT @"/hug/addHug.xhtml"

//获取我得设备
#define Get_MYDEVICE_List_Count @"/api/user/info/device/list"

//设备绑定更换用户
#define Update_MYDEVICE @"/user/changeDeviceBind.xhtml"

//获取我得设备
#define Get_DELEGATEMYDEVICE_List_Count @"/user/delMyDevice.xhtml"

//获取我得进餐时段
#define Get_DINNERTIME_List_Count @"/user/getUserEatTime.xhtml"

/**
 *  运动接口
 */

//解绑PK对象
#define RemovePKRelation @"/pedometer/relievePK.xhtml"

//PK挑战书jiekou
#define GetLetterOfChallenge @"/api/pedometer/getChallengeBookDetail"

//挑战同意、拒绝
#define UpdateChallenge @"/pedometer/updateChallenge.xhtml"

//解除pk
#define RemovePK @"/pedometer/removePK.xhtml"

#define GetFriendInfo  @"/user/getUserFriendDetailByid.xhtml"

//解除好友关系
#define kRemoveFriend @"/api/friend/removeFriend"

//帖子列表
#define GetGroupPostList  @"/api/group/getGroupPostList"

//关注圈子
#define  JoinGroupRequest @"/api/group/joinGroup"

//获得圈子信息
#define  GetGroupInfo @"/api/group/getGroupInfo"

//应战
#define ConfirmChallengeRequest @"/api/pedometer/confirmChallenge"
//拒绝
#define RefuseChallengeRequest @"/api/pedometer/refuseChallenge"

//发起PK
#define LaunchPK  @"/api/pedometer/challenge"

//PK列表
#define GetStepPKList @"/api/pedometer/getJoinedChallenges"

//糖友档案
#define GetStepUserInfo @"/api/pedometer/getPedometerInfo"

//日排名
#define GetTopListForDay @"/api/pedometer/getDailyRank"

//走走团
//---全部列表
#define GetALLGGTList  @"/api/pedometer/getAllActivity"

//获取团信息
#define GetTInfo  @"/api/pedometer/getActivityInfo"

//获取团成员列表
#define GetTMemList @"/api/pedometer/getActivityMember"

//我的团列表
#define GetMyGGTList  @"/api/pedometer/getAllActivityByAccount"

//加入团
#define AddTeamMem @"/api/pedometer/joinActivityApply"

//退出团
#define DeleteTeamFromMyList @"/api/pedometer/exitActivity"

//获得排名
#define GetTopList @"/api/pedometer/getTotalRank"

//查询异常设备接口
#define CheckExceptionPedometer  @"/api/pedometer/checkTodayDeviceNo"

//上传数据接口
#define StepDataUploadRequest @"/api/pedometer/upload"

//切换设备接口
#define AlterDeviceNo @"/api/pedometer/updateTodayDeviceNo"

//计步明细
#define GetPedometerItem @"/api/pedometer/getPedometerHistory"

//最近血糖开关
#define BSValueSwitch @"/api/pedometer/triggerShowSwitch"

//获得规则和积分
#define GetRuleAndPoint @"/api/pedometer/getChallengeRule"

//查找注册好友
#define QueryRegisterFriend  @"/api/user/rel/view"

//字符编码
NSStringEncoding g_GBKEncod;

//5.13. 详细查询
#define kGetRecordDetail @"/api/record/detail"

//5.13.	获取用户记录
#define kGetUserRecord @"/api/record/getUserHistoryRecord"

//5.9.	获取帖子列表
#define kGetGroupPostCommentsList @"/api/group/getGroupPostCommentsList"

//5.3.	用户帖子/评论点赞接口说明
#define kAddPostPraise @"/api/group/addPostPraise"

//5.11.	用户删除评论
#define kDelGroupPostComments @"/api/group/delGroupPostComments"

//5.7.	用户添加评论回复
#define kAddGroupPostCommentsReply @"/api/group/addGroupPostCommentsReply"

//5.6.	用户添加评论
#define kAddGroupPostComments @"/api/group/addGroupPostComments"

//5.13.	获取评论回复详情列表
#define kGetGroupPostCommentsReplyList @"/api/group/getGroupPostCommentsReplyList"

//5.4.	用户举报帖子
#define kReportPost @"/api/group/reportPost"

//发帖
#define ADDGROUP_POST_URL @"/api/group/addGroupPost"

//获取我的帖子
#define URL_getMyPost @"/api/group/getMyPost"

//5.13.	获取评论回复详情列表
#define kDelGroupPost @"/api/group/delGroupPost"


//获取首页
#define URL_getHomeList @"/api/home/index"

//签到
#define URL_checkin @"/api/continuous/addUserRegistration"

//医友

/* 添加好友 */
#define ADD_FRIEND_URL @"/api/friend/addFriendApply"

/* 获取好友申请列表 */
#define GET_FRIENDAPPLY_LIST @"/api/friend/getFriendApplyList"

/* 获取好友列表 */
#define GET_FRIEND_LIST @"/api/friend/getFriendList"

/* 接受好友请求 */
#define APPROVE_FRIEND_URL @"/api/friend/approveFriendApply"

/* 拒绝好友请求 */
#define REJICT_FRIEND_URL @"/api/friend/applyRejectById"

/* 删除好友 */
#define REMOVE_FRIEND_URL @"/api/friend/removeFriend"

/* 好友聊天 */
#define SEND_FRIEND_MSG @"/api/consult/sendChatMsg"
//
///* 获取好友聊天聊天记录 */
//#define GET_FRIENDCHAT_MSG @"/api/friend/getChatMsgList"

/* 获取好友详情 */
#define GET_FRIEND_DATA @"/api/user/rel/view"

//获取好友申请列表
#define getFriendApplyList @"/api/friend/getFriendApplyList"

//	获取聊天记录
#define getChatMsgList @"/api/consult/getChatMsgList"

/* 修改好友备注信息 */
#define MODIFY_FRIEND @"/api/friend/updateCommentName"

//雷达获取糖友列表
#define FIND_FriendList @"/api/friend/scanFriend"

//查看医生详情
#define GET_DOCTOR_DATA @"/api/user/rel/view_doctor"

//查看个人信息详情
#define kGET_PedometerInfoHasActivity @"/api/pedometer/getPedometerInfoHasActivity"

//推送开关接口
#define SET_PUSH_OPEN_OR_CLOSE @"/api/user/info/config/m_field"


#pragma mark - 人个中心
//5.14.	获取用户信箱列表
#define URL_getBroadcastList @"/api/broadcast/getBroadcastList"

//5.14.	获取用户健康提醒
#define URL_getHEALTHALERTList @"/api/broadcast/getBroadcastListForHealthAlert"

//1.1.	获取用户信箱详情
#define URL_getBroadcastDetail @"/api/broadcast/getBroadcastDetail"

//收藏
#define COLLECT_ADD_API @"/api/user/collect/add"

//取消收藏
#define COLLECT_REMOVE_API @"/api/user/collect/del"

//获取收藏列表
#define COLLECT_LIST_API @"/api/user/collect/list"

//获取积分和未读消息
#define GET_MSG_NOT_READ_COUNT @"/api/user/info/dynamic"

#pragma end

//查有没有新版本
#define URL_getCheck @"/api/version/check"

//5.30.	启动广告图接口
#define URL_getadv @"/api/ad/index"

#pragma mark - 记录
//获取记录首页
#define URL_getUserRecord @"/api/record/cell"

//获取记录有无数据
#define kGetUserRecordMonthData @"/api/record/monthData"

//5.19.	获取我的帖子
#define kGetMyPost @"/api/group/getMyPost"

//我得设备详情
#define Get_MYDEVICE_DETAIL @"/api/device/view"

//5.20.	获取我的评论
#define kGetMyCommentReply @"/api/group/getMyCommentReply"

//添加纪录
#define RECORD_add_URL @"/api/record/addRecord"

//删除纪录
#define RECORD_DELETE_URL @"/api/record/deleteRecord"

//统一修改身高体重接口
#define WEIGHT_HIGHT_add_URL @"/api/user/info/m_info_weight_hight"

//获取当前日期用户时间段方案接口
#define GET_TIME_URL @"/api/user/conf/time/setting/get"

//修改当前日期用户时间段方案
#define UPDATE_TIME_URL @"/api/user/conf/time/setting/modify"

//获取管理目标信息
#define GET_HEALTH_GOAL @"/api/user/conf/health/goal_view"

//修改目标管理信息
#define UPDATE_HEALTH_GOAL @"/api/user/conf/health/goal_update"

//获取进餐时间段
#define GET_TIME_CONF @"/api/user/conf/time/setting/view"

//修改进餐时间段
#define UPDATE_TIME_CONF @"/api/user/conf/time/setting/update_batch"

//获取进餐时间段(告诉你今天属于那个时间段)
#define GET_TIME_CONF_1 @"/api/user/conf/time/setting/view_and_time_setting"

//获取积分说明
#define URL_getPointDailyTasks @"/api/continuous/getPointDailyTasks"

//分享获取积分
#define URL_grouppointForForwardPost @"/api/group/pointForForwardPost"

//帖子详情
#define GET_TOPIC_BY_DETAIL @"/api/group/isZambiaORCollectionByForGroupPost"

//帖子详情
#define GET_WALLET_SWITCH @"/api/health/home/getHealthServiceList"

//获得发表圈子的列表
#define GetPublishedGroupList  @"/api/group/getPublishedGroupList"

//现金收支明细
#define GET_MONEY_DETAIL @"/api/wallet/cash/list_change"
//现金
#define GET_MONEY_INDEX @"/api/wallet/index"

//聊天设为已读
#define refreshChatMessage @"/api/consult/refreshChatMessage"
//健康资讯
#define GetHealthGroupPostList @"/api/health/group/getHealthGroupPostList"
//医师列表
#define URL_getDoctorList @"/api/consult/getDoctorList"
/* 首页信息 */
//#define GET_API_USERIFNO_URL @"/api/health/home/get_health_home_msg"
#define GET_API_USERIFNO_URL @"/api/health/home/get_new_health_home_msg"

//微课堂数据
#define GET_API_CORSELIST @"/api/course/get_course_list"


/* 首页菜单 */
#define GET_API_ALLHOMEMENUS_URL @"/api/health/configure/allMenus"

/* 首页菜单自定义 */
#define GET_API_UPDATEHOMEMENUS_URL @"/api/health/configure/customing"

//微信支付获取信息
#define URL_wxPrePay @"/api/shop/order/wxPrePay"

//创建订单
#define URL_buy @"/api/shop/medical/buy"

//获取医生付费信息
#define URL_medicalIndex @"/api/shop/medical/index"

#define  Get_Account_Health_Profile  @"/api/health/home/get_account_health_profile"

//获取红包列表
#define k_GetRedPacketList @"/api/bonus/getBonusList"

/* 获取订单，红包等信息 */
#define GET_ACCOUNTINFO_URL @"/api/health/home/getAccountInfoForHealthPplatform"

/* 体重数据上传 */
#define UPLOAD_DEVICEDATA @"/api/thirdequipment/data_save_weight"

//获取医生付费信息
#define URL_medicalIndex_new @"/api/shop/medical/index_new"

//获取享受派周期数据
#define URL_GETCYCLEDATA @"/api/reduce/get_reduce_list"

//完善个人资料
#define URL_UPDATAINFO @"/api/reduce/perfect_account_information"

//获得个人资料
#define URL_GETINFO @"/api/reduce/get_account_information"


//获得图标首页信息
#define URL_get_reduce_chart_home_msg @"/api/reduce/get_reduce_chart_home_msg"

//周期详情
#define k_GET_REDUCE_DETAIL @"/api/reduce/get_reduce_detail"

//用户打卡
#define k_PUNCH_THE_CLOCK @"/api/reduce/punch_the_clock"

//微课堂视频详情页面
#define get_course_video_detail @"/api/course/get_course_video_detail"

//微课堂视频状态操作（喜欢or不喜欢）
#define course_like_or_dislike @"/api/course/course_like_or_dislike"

//微课堂搜索查询列表
#define get_course_serch_list @"/api/course/get_course_serch_list"

//视频支付
#define URL_POSTREWARD @"/api/course/createOrder"

//用户给代理人发送视频解锁请求
#define course_unlock_request @"/api/course/course_unlock_request"

//体检报告
#define MEDICAL_LIST @"/api/medical/get_report_list"

//绑定代理人
#define bind_account_agent @"/api/agent/bind_account_agent"

//快速登录
#define login_by_mobile_code @"/api/user/login_by_mobile_code"

//获取我的代理人
#define GET_MY_AGENT @"/api/agent/get_my_agent"

//绑定代理人
#define BIND_AGENT @"/api/agent/bind_account_agent"

//微课堂音频增加点击量
#define add_audio_counts @"/api/course/add_audio_counts"

#endif
