//
//  ListViewCell.h
//  玩记
//
//  Created by monica on 16/6/30.
//  Copyright © 2016年 ClassroomM. All rights reserved.


#import "NotepadViewController.h"
#import "UIColor+CustomColor.h"
#import "Colours.h"
#import <UIKit/UIKit.h>
#import "NoteModel.h"
#import "SVProgressHUD.h"
#import "Constants.h"
#import "ListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+SLImage.h"
#import "ImageTextAttachment.h"
#import "PhotoCell.h"
#import "PhotoFlowLayout.h"
#import "xyxShareManager.h"


#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen  mainScreen].bounds.size.height)

#define BARandomData arc4random_uniform(100)




static const CGFloat kViewOriginY = 70;
static const CGFloat kTextFieldHeight = 30;
static const CGFloat kToolbarHeight = 44;
static const CGFloat kVertical = 10;
static const CGFloat kHorizontalMargin = 10;


@interface NotepadViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak) NoteModel *note;
@property (nonatomic,strong) UITextView  *contentTextView;
@property (nonatomic,strong) UITextField *titleTextField;
@property(nonatomic, assign) BOOL isEditingTitle;

@property (strong,nonatomic)UIImagePickerController * imagePikerViewController;
@property (nonatomic,assign) NSUInteger location;  //纪录变化的起始位置
@property (nonatomic,strong) NSMutableAttributedString * locationStr;
@property (nonatomic,strong) NSAttributedString * ContentStr;

@property (nonatomic, copy)NSString *imageName;//图片名
@property (nonatomic, strong) NSData *imageData;//图片流

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *picName;

@property (nonatomic, copy) __block NSString* lastPath;










@end

static NSString *identifier = @"photoCell";
@implementation NotepadViewController{
     float image_h;

    xyxShareManager *shareView;
    
    
}

-(instancetype)initWithContent:(NSAttributedString *)string  AndNote:(NoteModel *)note{
    
    self = [super init];
    if (self) {
       
        _ContentStr = string;
        _note = note;
        

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setToolbar];
    //[self setupSpeechRecognizer];

    
    self.imagesArray = @[@"animal_01",@"pure_01",@"flower_01",@"animal_04",@"animal_06",@"pure_03",@"flower_04",@"pure_02",@"animal_02",@"animal_05",@"animal_03",@"flower_06",@"flower_05",@"flower_02",@"flower_03",@"flower_07"];
    UIImage *image = [UIImage imageNamed:_note.bgImageName];
    
    NSLog(@"33-----%@",_note.bgImageName);
    self.picName = _note.bgImageName;
    
    self.view.layer.contents = (id)image.CGImage;
    //如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.contentTextView setAttributedText:_ContentStr];
    
    
    self.titleTextField.text = _note.title;

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // 1. 实例化一个 flowlayout的对象
    PhotoFlowLayout *flowLayout = [[PhotoFlowLayout alloc] init];
    
    // 2. 实例化一个collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, HEIGHT-200, WIDTH, 100) collectionViewLayout:flowLayout];
    
    
    // 3. 设置数据源代理
    _collectionView.dataSource = self;
    
    // 设置代理
    _collectionView.delegate = self;
    
    // 4. 注册cell
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:identifier];
    
    
    // 5. 添加到控制器的view上
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor easterPinkColor];
    _collectionView.hidden = YES;
    
    shareView = [[xyxShareManager alloc]init];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)pickerImage:(id)sender{
    
    UIView *v = [sender superview];//获取父类view
    PhotoCell *cell = (PhotoCell *)[v superview];//获取cell
    
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];//获取cell对应的indexpath;
    self.picName = self.imagesArray[indexpath.row];
    
    UIImage *image = [UIImage imageNamed:self.picName];
    NSLog(@"7777 %@",self.picName);

   
    self.view.layer.contents = (id)image.CGImage;
     //如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
   
}


// 组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 行

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imagesArray count];
}

// 内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString*imagename = self.imagesArray[indexPath.row];
    UIImage *image = [UIImage imageNamed:imagename];
    NSLog(@"------%@",self.picName);
    

    //找到每一个按钮；
    UIButton *deviceImageButton = cell.imageButton;
    [deviceImageButton addTarget:self action:@selector(pickerImage:) forControlEvents:UIControlEventTouchUpInside];
    
    //给每一个cell加边框；
    cell.layer.borderColor = [UIColor grayColor].CGColor;
    cell.layer.borderWidth = 0.3;
    
    [cell.imageButton setBackgroundImage:image forState:UIControlStateNormal];
    
    
    return cell;
}

#pragma mark Initial
-(NSArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [[NSArray alloc] init];
    }
    return _imagesArray;
}



- (void)setupNavigationBar
{
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(save)];
    
    self.navigationItem.rightBarButtonItem = saveItem;
    
    
}

-(void)save
{
    [self hideKeyboard];
    if ((_contentTextView.text == nil || _contentTextView.text.length == 0) &&
        (_titleTextField.text == nil || _titleTextField.text.length == 0)) {
        [SVProgressHUD showErrorWithStatus:@"未输入内容"];
        return;
    }
    NSDate *createDate;
    if (_note && _note.createdDate) {
        createDate = _note.createdDate;
    } else {
        createDate = [NSDate date];
        
    }
    
    if ((_titleTextField.text == nil || _titleTextField.text.length == 0) && (_contentTextView.text.length>0)) {
        
    _titleTextField.text = @"未命名标题";

    
    }
    
    if (_note.content == nil) {
        
        
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [path objectAtIndex:0];
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"content"];
        BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        NSAssert(bo,@"创建目录失败");

        //获得沙箱的 Document 的地址
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", a];
        
    
        _filePath = [documentsDirectory stringByAppendingPathComponent:timeString]; //要保存的文件名
        NSLog(@"111111%@",_filePath);
        
    }else{
        
        _filePath = _note.content;
    }
    
    NSLog(@"222222%@",_filePath);

    
    
    NSData *data = [_contentTextView.textStorage dataFromRange:NSMakeRange(0, _contentTextView.textStorage.length) documentAttributes:@{NSDocumentTypeDocumentAttribute:NSRTFDTextDocumentType} error:nil];   //将 NSAttributedString 转为NSData
    
    [data writeToFile:_filePath atomically:YES];
    
    NSLog(@"00000000%@",_note.bgImageName);
    NSLog(@"uuuuu %@",_picName);


    NoteModel *note = [[NoteModel alloc] initWithTitle:_titleTextField.text
                                    content:_filePath
                                     createdDate:createDate
                                      updateDate:[NSDate date]
                                    bgImageName:_picName];
    NSLog(@"8888%@",_picName);
    _note = note;
    
    BOOL success = [note Persistence] ;
    
   if(success){
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCreateFile object:nil userInfo:nil];

    }else{
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}



-(UIBarButtonItem *)ImageName:(NSString *)name frame:(NSInteger)width Target:(SEL)action{
    
    UIImage *image = [UIImage imageNamed:name];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width , width)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    return  [[UIBarButtonItem alloc]initWithCustomView:button];
    
}


- (void)setToolbar
{
    
    UIBarButtonItem *voiceBarButton = [self ImageName:@"micphone" frame:56 Target:@selector(useVoiceInput)];
    
    UIBarButtonItem *photoBarButton = [self ImageName:@"camera" frame:56 Target:@selector(usePhotoInput)];
    
    UIBarButtonItem *letterBarButton = [self ImageName:@"pic" frame:56 Target:@selector(usePictruesInput)];
    
    UIBarButtonItem *shareBarButton = [self ImageName:@"share" frame:56 Target:@selector(useshareInput)];

    
    UIBarButtonItem *okBarButton = [self ImageName:@"ok" frame:56 Target:@selector(useokInput)];
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, WIDTH-20, kToolbarHeight)];
    [toolbar setBarTintColor:[UIColor colorWithWhite:1 alpha:1]];
    
    UIBarButtonItem* spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    toolbar.items = [NSArray arrayWithObjects: spaceButtonItem, voiceBarButton,photoBarButton,letterBarButton,shareBarButton,okBarButton,spaceButtonItem, nil];
    
    CGRect frame = CGRectMake(kHorizontalMargin, kViewOriginY, self.view.frame.size.width - kHorizontalMargin * 2, kTextFieldHeight);
    
    _titleTextField = [[UITextField alloc] initWithFrame:frame];
    if (_note) {
        _titleTextField.text = _note.title;
    } else {
        _titleTextField.placeholder = @"请输入标题";
    }
    _titleTextField.textColor = [UIColor blackColor];
    _titleTextField.inputAccessoryView = toolbar;
    [self.view addSubview:_titleTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kHorizontalMargin, kViewOriginY + kTextFieldHeight, self.view.frame.size.width - 2*kHorizontalMargin, 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineView];
    
    CGFloat textY = kViewOriginY + kTextFieldHeight + kVertical;
    frame = CGRectMake(kHorizontalMargin,
                       textY,
                       self.view.frame.size.width - kHorizontalMargin * 2,
                       self.view.frame.size.height - textY - kVertical * 2);
    _contentTextView = [[UITextView alloc] initWithFrame:frame];
    _contentTextView.textColor = [UIColor blackColor];
    _contentTextView.font = [UIFont systemFontOfSize:15];
    _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_contentTextView setScrollEnabled:YES];
    [_contentTextView setBackgroundColor: [UIColor clearColor]];
    _contentTextView.inputAccessoryView = toolbar;
    [self.view addSubview:_contentTextView];
    
}
//
//- (void)setupSpeechRecognizer
//{
//    NSString *appid = @"5779f9f4";//自己申请的appId
//    NSString *initString = [NSString stringWithFormat:@"appid=%@",appid];
//    [IFlySpeechUtility createUtility:initString];
//    
//    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
//    _iflyRecognizerView.delegate = self;
//    
//    [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
//    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
//    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
//}


- (IFlyRecognizerView *) iflyRecognizerView {
    if (!_iflyRecognizerView) {
        NSString *appid = @"5779f9f4";//自己申请的appId
        NSString *initString = [NSString stringWithFormat:@"appid=%@",appid];
        [IFlySpeechUtility createUtility:initString];
        _iflyRecognizerView = [[IFlyRecognizerView alloc]initWithCenter:self.view.center];
        _iflyRecognizerView.delegate = self;
        [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        //asr_audio_path保存录音文件名,默认目录是documents
        [_iflyRecognizerView setParameter: @"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
        //设置返回的数据格式为默认plain
        [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    }
    
    return _iflyRecognizerView;
}


-(void)useVoiceInput{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                    message:@"使用语音功能选择的图片会失效呦!"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self startListenning:self.iflyRecognizerView];//可以建一个按钮,点击按钮调用此方法
        
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.contentTextView resignFirstResponder];
    }];
    
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [self hideKeyboard];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [IFlySpeechUtility destroy];
}

- (void)startListenning:(id)sender{
    [self.iflyRecognizerView start];
    [self hideKeyboard];
    
    NSLog(@"开始识别");
}
//返回数据处理
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [NSMutableString new];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    if (_isEditingTitle) {
        _titleTextField.text = [NSString stringWithFormat:@"%@%@", _titleTextField.text, result];
    } else {
        
        _contentTextView.text = [NSString stringWithFormat:@"%@%@", _contentTextView.text, result];
    }
    
}

- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%@", [error errorDesc]);
}


-(void)showAlertWithMessage:(NSString *)message{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"警告"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
}


-(void)usePhotoInput{
    
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        //判断相机是否能够使用
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(status == AVAuthorizationStatusAuthorized) {
          
            [self successUsePhoto];
        }
        
        else if(status == AVAuthorizationStatusDenied){
            [self showAlertWithMessage:@"请在设备的设置-隐私-相机中允许访问相机。"];
            return ;
        }
        
        else if(status == AVAuthorizationStatusRestricted){
            NSLog(@"Restricted");
        }
        
        else if(status == AVAuthorizationStatusNotDetermined){
            // not determined
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if(granted){
                    [self successUsePhoto];

                } else {
                    return;
                }
            }];
        }
    }
    
}

-(void)successUsePhoto{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: nil
                                                                              message: nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction: [UIAlertAction actionWithTitle: @"相机" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            self.imagePikerViewController = [[UIImagePickerController alloc] init];
            self.imagePikerViewController.delegate = self;
            self.imagePikerViewController.allowsEditing = YES;
            self.imagePikerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePikerViewController animated:YES completion:NULL];
            
        }else{
            [self showAlertWithMessage:@"相机未能正常开启"];
        }
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"相册" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            self.imagePikerViewController = [[UIImagePickerController alloc] init];
            self.imagePikerViewController.delegate = self;
            self.imagePikerViewController.allowsEditing = YES;
            self.imagePikerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:self.imagePikerViewController animated:YES completion:NULL];
            });
            
        }else{
            [self showAlertWithMessage:@"相册未能正常打开"];
        }
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:nil]];
    [self presentViewController: alertController animated: YES completion: nil];
}
/**
 *  拍摄完后,保存照片或取消保存
 */

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //图片保存时每一张图片都要由一个名字，而相册和拍照中返回的info是不同的，但不管如何，都要想办法给每张图片一个唯一的名字
    if (picker.sourceType ==UIImagePickerControllerSourceTypePhotoLibrary) {
        //获取每张图片的id，用来作为保存在沙盒中的文件名
        NSString *getsrc=[NSString stringWithFormat:@"%@",(NSString *)[info objectForKey:@"UIImagePickerControllerReferenceURL"]];
        NSRange range={33,47};
        self.imageName=[NSString stringWithFormat:@"%@.jpg",[getsrc substringWithRange:range]];
    }
    if (picker.sourceType ==UIImagePickerControllerSourceTypeCamera) {
        self.imageName=[NSString stringWithFormat:@"%@.jpg",[[[info objectForKey:@"UIImagePickerControllerMediaMetadata"] objectForKey:@"{Exif}"] objectForKey:@"DateTimeDigitized"]];
        self.imageName = [self.imageName stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        
    }
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    self.imageName = [NSString stringWithFormat:@"%@%u.jpg",identifierForVendor,BARandomData];
    [self saveImage:image WithName:self.imageName];


    UIImage *image1 = [image scaleToSize:CGSizeMake(WIDTH, image.size.height*WIDTH/image.size.width)];
    image = [self compressImage:image toMaxFileSize:0.2];
    image_h = image1.size.height;
    ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
    
    image=[imageTextAttachment scaleImage:image withSize:CGSizeMake(WIDTH - 40,image_h)];
    //Set tag and image
    imageTextAttachment.image =image;
    
    //Set image size
    imageTextAttachment.imageSize = CGSizeMake(WIDTH - 40,image_h);
    
    // 表情图片
    imageTextAttachment.image = image;
    imageTextAttachment.imageSize = CGSizeMake(WIDTH - 40,image_h);
    

    // 3.将图片插入文本
    
    NSRange insertionPoint = self.contentTextView.selectedRange ;
    
    [_contentTextView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment] atIndex:insertionPoint.location];
    
    self.contentTextView.selectedRange = NSMakeRange(self.contentTextView.selectedRange.location + 1,self.contentTextView.selectedRange.length);

    [self setInitLocation];
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.contentTextView becomeFirstResponder];

}

//保存图片至沙盒
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imaName
{
    //压缩图片
    self.imageData = UIImageJPEGRepresentation(tempImage, 0.5);
    
    //从沙盒中获取文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imaName];
    //图片流写入沙盒
    BOOL flag =[self.imageData writeToFile:fullPathToFile atomically:YES];
    if (flag) {
        NSLog(@"图片保存到沙盒成功");
    }
    
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

-(void)setInitLocation
{
    
    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:self.contentTextView.attributedText];
    //self.contentTextView.font = [UIFont systemFontOfSize:15];
    //重新设置位置
    self.location=self.contentTextView.textStorage.length;
    
}


//点击Cancel按钮后执行方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//点击相册,选中图片后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    
    [dict setObject:image forKey:@"UIImagePickerControllerEditedImage"];
    
    //直接调用3.x的处理函数
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];

}

-(void)usePictruesInput{
    _collectionView.hidden = NO;
    [self hideKeyboard];
    
}

-(void)useshareInput{
    [self hideKeyboard];
    
    NSURL *url = [NSURL URLWithString:@"http://www.wulinlw.org/xiaowanzi/save.php"];
    // 可变的网络请求!
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *bodyStr = [NSString stringWithFormat:@"title=%@&content=%@&crtime=%@",_titleTextField.text ,_contentTextView.text,    [formatter stringFromDate:_note.createdDate]];
    
    // 设置请求体:
    request.HTTPBody =[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    //建立任务
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //解析
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            mDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (mDict[@"archiveId"]) {
                
                self.lastPath= [NSString stringWithFormat:@"http://www.wulinlw.org/xiaowanzi/view.php?archiveId=%@",mDict[@"archiveId"]];
                
                [shareView setShareVC:self content:@"心情记录(来自玩记)" image:[UIImage imageNamed:@"girl2"] url:self.lastPath];
                
            }
            
        }}];
    
    //启动任务
    [task resume];
    [shareView show];

    
}

-(void)useokInput{
    
    [self hideKeyboard];
    self.collectionView.hidden = YES;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo [UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect keyboardFrame = [[userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
         CGFloat keyboardHeight = keyboardFrame.size.height;
         
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - keyboardHeight - kVertical - kToolbarHeight,
         _contentTextView.frame = frame;
     }               completion:NULL];
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    [UIView animateWithDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.f
                        options:[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]
                     animations:^
     {
         CGRect frame = _contentTextView.frame;
         frame.size.height = self.view.frame.size.height - kViewOriginY - kTextFieldHeight - kVertical * 3;
         _contentTextView.frame = frame;
     }               completion:NULL];
}


- (void)hideKeyboard
{
    if ([_titleTextField isFirstResponder]) {
        _isEditingTitle = YES;
        [_titleTextField resignFirstResponder];
    }
    if ([_contentTextView isFirstResponder]) {
        _isEditingTitle = NO;
        [self.view endEditing:YES];
        //[_contentTextView resignFirstResponder];
    }
}






@end
