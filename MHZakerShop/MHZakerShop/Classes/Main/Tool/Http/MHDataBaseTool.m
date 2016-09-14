//
//  MHDataBaseTool.m
//  MHZakerShop
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 Mike_He. All rights reserved.
//

#import "MHDataBaseTool.h"
#import "MHHttpTool.h"
#import "MHBanner.h"
#import "MHBlockData.h"



@interface MHDataBaseTool ()
{
    // 用来开线程
    dispatch_queue_t _goodsDataQueue;
}
/** 所有数据 */
@property (nonatomic, strong) NSArray *blocksData;

/** 主页数据源pk */
@property (nonatomic, strong) NSMutableArray *homeBlockPkItems;
/** 福利数据源pk */
@property (nonatomic, strong)NSMutableArray *benefitBlockPkItems;
/** 好店数据源pk */
@property (nonatomic, strong)NSMutableArray *shopBlockPkItems;
/** 专题数据源pk */
@property (nonatomic, strong)NSMutableArray *topicBlockPkItems;


/** 主页banner数据源 */
@property (nonatomic, strong) NSMutableArray *homeBanners;
/** 好店banner数据源 */
@property (nonatomic, strong)NSMutableArray *shopBanners;

/** 主页数据源 */
@property (nonatomic, strong)NSMutableArray *homeDataSource;
/** 福利数据源 */
@property (nonatomic, strong)NSMutableArray *benefitDataSource;
/** 好店数据源 */
@property (nonatomic, strong)NSMutableArray *shopDataSource;
/** 专题数据源 */
@property (nonatomic, strong)NSMutableArray *topicDataSource;

@end


@implementation MHDataBaseTool

MHSingletonM(DataBase)
#pragma mark - 懒加载
- (NSMutableArray *)homeBlockPkItems
{
    if(_homeBlockPkItems == nil)
    {
        _homeBlockPkItems = [[NSMutableArray alloc] init];
    }
    return _homeBlockPkItems;
}

- (NSMutableArray *)benefitBlockPkItems
{
    if(_benefitBlockPkItems == nil)
    {
        _benefitBlockPkItems = [[NSMutableArray alloc] init];
    }
    return _benefitBlockPkItems;
}

- (NSMutableArray *)shopBlockPkItems
{
    if(_shopBlockPkItems == nil)
    {
        _shopBlockPkItems = [[NSMutableArray alloc] init];
    }
    return _shopBlockPkItems;
}
- (NSMutableArray *)topicBlockPkItems
{
    if(_topicBlockPkItems == nil)
    {
        _topicBlockPkItems = [[NSMutableArray alloc] init];
    }
    return _topicBlockPkItems;
}
- (NSMutableArray *)homeBanners
{
    if(_homeBanners == nil)
    {
        _homeBanners = [[NSMutableArray alloc] init];
    }
    return _homeBanners;
}

- (NSMutableArray *)homeDataSource
{
    if(_homeDataSource == nil)
    {
        _homeDataSource = [[NSMutableArray alloc] init];
    }
    return _homeDataSource;
}

- (NSMutableArray *)benefitDataSource
{
    if(_benefitDataSource == nil)
    {
        _benefitDataSource = [[NSMutableArray alloc] init];
    }
    return _benefitDataSource;
}

- (NSMutableArray *)shopDataSource
{
    if(_shopDataSource == nil)
    {
        _shopDataSource = [[NSMutableArray alloc] init];
    }
    return _shopDataSource;
}

- (NSMutableArray *)topicDataSource
{
    if(_topicDataSource == nil)
    {
        _topicDataSource = [[NSMutableArray alloc] init];
    }
    return _topicDataSource;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建数据库
        
        
    }
    return self;
}
#pragma mark - 初始化
- (void)_setup
{
    // 创建线程
    _goodsDataQueue = dispatch_queue_create("com.zakerShop.goods.data", NULL);
}


#pragma mark - 解析responseObject
- (void)_handleRequestDataWithResponseObject:(NSDictionary *)responseObject
{
    __weak typeof(self) weakSelf = self;
    // 子线程跑数据 主线程刷UI
    dispatch_async(_goodsDataQueue, ^{
       
        // 获取所有数据
        self.blocksData = responseObject[@"data"][@"blocksData"];
        
        // 获取每页商品id的数据
        NSArray *pageInfos = responseObject[@"data"][@"pageInfos"];
        
        for (NSDictionary *pageInfo in pageInfos)
        {
            
            if ([pageInfo[@"title"] isEqualToString:@"主页"])
            {
                //主页 pk 数据源
                //block_pk 数据源
                NSArray *items = pageInfo[@"items"];
                for (NSDictionary *item in items) {
                    [weakSelf.homeBlockPkItems addObject:item[@"block_pk"]];
                }
                //滚动图片数据源
                NSArray *bannerItems = pageInfo[@"big_block"][@"items"];
                for (NSDictionary *bannerItem in bannerItems) {
                    MHBanner *banner = [[MHBanner alloc] init];
                    banner.pic = bannerItem[@"pic"];
                    banner.s_pic = bannerItem[@"s_pic"];
                    banner.title = bannerItem[@"title"];
                    banner.pk = bannerItem[@"pk"];
                    if ([[bannerItem allKeys] containsObject:@"web_url"]) {
                        banner.url = bannerItem[@"web_url"];
                        banner.type = MHGoodsUrlTypeWeb;
                    }
                    else {
                        banner.url = bannerItem[@"api_url"];
                        banner.type = MHGoodsUrlTypeApi;
                    }
                    [weakSelf.homeBanners addObject:banner];
                }
                
                
            }else if ([pageInfo[@"title"] isEqualToString:@"福利"]){
            
                //主页 pk 数据源
                NSArray *items = pageInfo[@"items"];
                for (NSDictionary *item in items) {
                    [weakSelf.benefitBlockPkItems addObject:item[@"block_pk"]];
                }
            }else if ([pageInfo[@"title"] isEqualToString:@"好店"]){
                
                //好店 pk 数据源
                NSArray *items = pageInfo[@"items"];
                for (NSDictionary *item in items) {
                    
                    NSArray *blockPks = [item[@"block_pk"] componentsSeparatedByString:@","];
                    
                    [weakSelf.shopBlockPkItems addObjectsFromArray:blockPks];
                }
                
                //滚动图片数据源
                NSArray *bannerItems = pageInfo[@"big_block"][@"items"];
                for (NSDictionary *bannerItem in bannerItems) {
                    MHBanner *banner = [[MHBanner alloc] init];
                    banner.pic = bannerItem[@"pic"];
                    banner.s_pic = bannerItem[@"s_pic"];
                    banner.title = bannerItem[@"title"];
                    banner.pk = bannerItem[@"pk"];
                    if ([[bannerItem allKeys] containsObject:@"web_url"]) {
                        banner.url = bannerItem[@"web_url"];
                        banner.type = MHGoodsUrlTypeWeb;
                    }
                    else {
                        banner.url = bannerItem[@"api_url"];
                        banner.type = MHGoodsUrlTypeApi;
                    }
                    [weakSelf.shopBanners addObject:banner];
                }
                
                
            }else if ([pageInfo[@"title"] isEqualToString:@"专题"]){
                
                //专题 pk 数据源
                NSArray *items = pageInfo[@"items"];
                for (NSDictionary *item in items) {
                    [weakSelf.topicBlockPkItems addObject:item[@"block_pk"]];
                }
            }
        }
        
        
        // 给每个模块提供数据源
        
        // 主页
        for (NSString *blockPk in weakSelf.homeBlockPkItems)
        {
            for (NSDictionary *blockData in weakSelf.blocksData) {
                if ([blockPk isEqualToString:blockData[@"pk"]])
                {
                    MHBlockData *block = [[MHBlockData alloc] init];
                    block.title = blockData[@"title"];
                    block.data_type = blockData[@"data_type"];
                    block.default_pic = blockData[@"default_pic"];
                    block.url = blockData[@"api_url"];
                    block.pk = blockData[@"pk"];
                    [weakSelf.homeDataSource addObject:block];
                    break;
                }
            }
        }
        
        
        // 福利
        for (NSString *blockPk in weakSelf.benefitBlockPkItems)
        {
            for (NSDictionary *blockData in weakSelf.blocksData) {
                if ([blockPk isEqualToString:blockData[@"pk"]])
                {
                    MHBlockData *block = [[MHBlockData alloc] init];
                    block.title = blockData[@"title"];
                    block.data_type = blockData[@"data_type"];
                    block.default_pic = blockData[@"default_pic"];
                    block.url = blockData[@"web_url"]; //blockData[@"origin_url"]
                    block.pk = blockData[@"pk"];
                    [weakSelf.benefitDataSource addObject:block];
                    break;
                }
            }
        }
        
        
        // 好店
        for (NSString *blockPk in weakSelf.shopBlockPkItems)
        {
            for (NSDictionary *blockData in weakSelf.blocksData) {
                if ([blockPk isEqualToString:blockData[@"pk"]])
                {
                    MHBlockData *block = [[MHBlockData alloc] init];
                    block.title = blockData[@"title"];
                    block.data_type = blockData[@"data_type"];
                    block.default_pic = blockData[@"default_pic"];
                    block.url = blockData[@"api_url"];
                    block.pk = blockData[@"pk"];
                    [weakSelf.shopDataSource addObject:block];
                    break;
                }
            }
        }
        
        
        // 专题
        for (NSString *blockPk in weakSelf.topicBlockPkItems)
        {
            for (NSDictionary *blockData in weakSelf.blocksData) {
                if ([blockPk isEqualToString:blockData[@"pk"]])
                {
                    MHBlockData *block = [[MHBlockData alloc] init];
                    block.title = blockData[@"title"];
                    block.data_type = blockData[@"data_type"];
                    block.default_pic = blockData[@"default_pic"];
                    block.url = blockData[@"api_url"];
                    block.pk = blockData[@"pk"];
                    [weakSelf.topicDataSource addObject:block];
                    break;
                }
            }
        }
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //主页滚动视图 发送通知
            [MHNotificationCenter postNotificationName:MHHomeBannersDataDidLoad object:nil];
            
            //好店滚动视图 发送通知
            [MHNotificationCenter postNotificationName:MHShopBannersDataDidLoad object:nil];
            
            
            
            //主页blockData 发送通知
            [MHNotificationCenter postNotificationName:MHHomeBlocksDataDidLoad object:nil];
            
            //好店blockData 发送通知
            [MHNotificationCenter postNotificationName:MHShopBlocksDataDidLoad object:nil];
            
            //福利block 发送通知
            [MHNotificationCenter postNotificationName:MHBenefitBlocksDataDidLoad object:nil];
            
            //主题block 发送通知
            [MHNotificationCenter postNotificationName:MHTopicBlocksDataDidLoad object:nil];
        });

    });
    
}


#pragma mark - 公共方法
#pragma mark - 请求数据
- (void) requestAllData
{
    //???: 这里请求的是所有的数据  而且这个请求回来的数据也特别蛋疼，请求回来的JSON数据 请查看Other--Resource--Data--Json--ZakerData.json所示 这样我只能通过手动解析这些数据了 呜呜...
    //请求数据
    [MHHttpTool getWithUrl:MHAllDataUrl refreshCache:YES success:^(id responseObject) {
        
        //解析responseObject
        [self _handleRequestDataWithResponseObject:responseObject];
        
        
    } failure:^(NSError *error) {
        
        //这里需要从数据库里面查找
        
        
        //数据库里面没 就加载本地JSON
        
        
    }];
}


#pragma mark - 获取主页滚动视图的图片
- (NSArray *)homeBannersData
{
    return self.homeBanners;
}

#pragma mark - 获得好店滚动视图的图片
- (NSArray *)shopBannersData
{
    return self.shopBanners;
}

#pragma mark - 获得主页的数据
- (NSArray *)homeBlocksData
{
    return self.homeDataSource;
}

#pragma mark - 获得福利的数据
- (NSArray *)benefitBlocksData
{
    return self.benefitDataSource;
}

#pragma mark - 获得好店的数据
- (NSArray *)shopBlocksData
{
    return self.shopDataSource;
}

#pragma mark - 获得专题的数据
- (NSArray *)topicBlocksData
{
    return self.topicDataSource;
}

@end
