/*****************************************************************************
 *   ViewController.m
 ******************************************************************************
 *   by Kirill Kornyakov and Alexander Shishkov, 19th May 2013
 ******************************************************************************
 *   Chapter 15 of the "OpenCV for iOS" book
 *
 *   Detecting Facial Features presents a simple facial feature
 *   detection demo.
 *
 *   Copyright Packt Publishing 2013.
 *   http://bit.ly/OpenCV_for_iOS_book
 *****************************************************************************/

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView;
@synthesize startCaptureButton;
@synthesize toolbar;
@synthesize videoCamera;

@synthesize imageResult;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.videoCamera = [[CvVideoCamera alloc]
                        initWithParentView:imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition =
                            AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset =
                            AVCaptureSessionPreset640x480;
    self.videoCamera.defaultAVCaptureVideoOrientation =
                            AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
 
    isCapturing = NO;

//    // Load images
//    UIImage* resImage = [UIImage imageNamed:@"glasses.png"];
//    UIImageToMat(resImage, parameters.glasses, true);
//    cvtColor(parameters.glasses, parameters.glasses, CV_BGRA2RGBA);
//
//    resImage = [UIImage imageNamed:@"mustache.png"];
//    UIImageToMat(resImage, parameters.mustache, true);
//    cvtColor(parameters.mustache, parameters.mustache, CV_BGRA2RGBA);
//
//    // Load Cascade Classisiers
//    NSString* filename = [[NSBundle mainBundle]
//                          pathForResource:@"lbpcascade_frontalface"
//                                   ofType:@"xml"];
//    parameters.faceCascade.load([filename UTF8String]);
//
//    filename = [[NSBundle mainBundle]
//                pathForResource:@"haarcascade_mcs_eyepair_big"
//                         ofType:@"xml"];
//    parameters.eyesCascade.load([filename UTF8String]);
//
//    filename = [[NSBundle mainBundle]
//                pathForResource:@"haarcascade_mcs_mouth"
//                         ofType:@"xml"];
//    parameters.mouthCascade.load([filename UTF8String]);
}

- (NSInteger)supportedInterfaceOrientations
{
    // Only portrait orientation
    return UIInterfaceOrientationMaskPortrait;
}

-(IBAction)startCaptureButtonPressed:(id)sender
{
    [videoCamera start];
    isCapturing = YES;
    
//    faceAnimator = new FaceAnimator(parameters);
}

-(IBAction)stopCaptureButtonPressed:(id)sender
{

    NSData *data = UIImageJPEGRepresentation(imageResult, 1);


//
//    // setting up the request object now
//    NSURL *nsurl =[NSURL URLWithString:@"http://10.48.12.176:1234/upload"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
//    [request setURL:nsurl];
//    [request setHTTPMethod:@"POST"];
//
//
//    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//
//    /*
//     now lets create the body of the post
//     */
//    NSMutableData *body = [NSMutableData data];
//
//    //parameter1
////    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"parameter1\"\r\n\r\n%@", parameter1] dataUsingEncoding:NSUTF8StringEncoding]];
////    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////    //Tags
////    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"tag\"\r\n\r\n%@", tag] dataUsingEncoding:NSUTF8StringEncoding]];
////    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////    //Status
////    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n%@", status] dataUsingEncoding:NSUTF8StringEncoding]];
////    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////    //customerID
////    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"customerID\"\r\n\r\n%@", customerID] dataUsingEncoding:NSUTF8StringEncoding]];
////    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////    //customerName
////    [body appendData:[[NSString stringWithFormat:@"C  ontent-Disposition: form-data; name=\"customerName\"\r\n\r\n%@", customerName] dataUsingEncoding:NSUTF8StringEncoding]];
////    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    //Image
//    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; type=\"file\"; name=\"image\"; filename=\"%@\"\r\n",@"wave.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[NSData dataWithData:data]];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//
//    // setting the body of the post to the reqeust
//    [request setHTTPBody:body];
//
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];



//
//    NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@""];
//    [urlString appendFormat:@"%@", data];
////    NSMutableString *urlString = [[NSMutableString alloc] initWithFormat:@"name=thefile&&filename=recording"];
////    [urlString appendFormat:@"%@", data];
//    NSData *postData = [urlString dataUsingEncoding:NSASCIIStringEncoding
//                               allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];




//
//    NSString *postLength = [NSString stringWithFormat:@"%d", [data length]];
//
//
//    NSString *baseurl = @"http://10.48.12.176:1234/upload";
//
//    NSURL *url = [NSURL URLWithString:baseurl];
//    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
//    [urlRequest setHTTPMethod: @"POST"];
//    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [urlRequest setValue:@"application/x-www-form-urlencoded"
//      forHTTPHeaderField:@"Content-Type"];
//    [urlRequest setHTTPBody:data];
////
////    NSURLConnection *connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
////    [connection start];
//    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
//




    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];

// set Content-Type in HTTP header
    NSString *FileParamConstant = [NSString stringWithString:@"file"];
    NSString *boundary = [NSString stringWithString:@"----------V2ymHFg03ehbqgZCaKO6jy"];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];

// post body
    NSMutableData *body = [NSMutableData data];

//// add params (all params are strings)
//    for (NSString *param in _params) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
//    }

// add image data
    if (data) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

// setting the body of the post to the reqeust
    [request setHTTPBody:body];

// set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];

// set URL
    [request setURL:[NSURL URLWithString:@"http://10.48.12.176:1234/upload"]];

    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSLog(@"rupload return:%@", [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding]);
//    [videoCamera stop];
//    isCapturing = NO;
}

// Macros for time measurements
#if 1
  #define TS(name) int64 t_##name = cv::getTickCount()
  #define TE(name) printf("TIMER_" #name ": %.2fms\n", \
    1000.*((cv::getTickCount() - t_##name) / cv::getTickFrequency()))
#else
  #define TS(name)
  #define TE(name)
#endif



- (void)processImage:(cv::Mat&)image
{
//    TS(DetectAndAnimateFaces);
//    faceAnimator->detectAndAnimateFaces(image);
//    TE(DetectAndAnimateFaces);



    imageResult = MatToUIImage(image);

//
//    cv::Mat source, src_gray;
//    cv::Mat maskedImage, detected_edges;
//
//    int edgeThresh = 1;
//    int lowThreshold = 15;
//    int const max_lowThreshold = 100;
//    int ratio = 3;
//    int kernel_size = 3;
//
//
//    cv::Mat imageMatrix;
//    UIImageToMat(image, imageMatrix);
//    if (imageMatrix.rows > imageMatrix.cols)
//    {
//        imageMatrix = imageMatrix.t();
//        flip(imageMatrix, imageMatrix, 1);
//        resize(imageMatrix, imageMatrix,
//            cv::Size(imageMatrix.cols, imageMatrix.rows*2));
//    }
//
//    source = imageMatrix;
//
//    cvtColor(source, src_gray, cv::COLOR_BGR2GRAY);
//
//    cv::blur(src_gray, detected_edges, cv::Size(3,3));
//
//    /// Canny detector
//    cv::Canny( detected_edges, detected_edges, lowThreshold, lowThreshold*ratio, kernel_size);
//
//    /// Using Canny's output as a mask, we display our result
//    maskedImage = cv::Scalar::all(0);
//
//    source.copyTo(maskedImage, detected_edges);
//
//    UIImage *imageResult = MatToUIImage(detected_edges);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isCapturing)
    {
        [videoCamera stop];
    }
}

- (void)dealloc
{
    videoCamera.delegate = nil;
}

@end
