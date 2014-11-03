#import <CoreText/CoreText.h>
#import "GDefaultClusterRenderer.h"
#import "GQuadItem.h"
#import "GCluster.h"
#import "MapViewController.h"
#import "SlideMenuViewController.h"

//extern NSString *iconOfSelectedMarker;
@implementation GDefaultClusterRenderer
{
    GMSMapView *_map;
    NSMutableArray *_markerCache;
    NSString *iconOfSelectedMarker;
   // SlideMenuViewController *menuController;
    DataModel *dataModel;
}

- (id)initWithMapView:(GMSMapView*)googleMap
{
    if (self = [super init]) {
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        //menuController = [[rootViewController childViewControllers] objectAtIndex:0];
        _map = googleMap;
        _markerCache = [[NSMutableArray alloc] init];
        iconOfSelectedMarker = @"Parking.png";
        dataModel = [DataModel sharedModel];
        [self setObservingForMarkerIcon];
        
    }
    return self;
}

// here need to do changes!
- (void)clustersChanged:(NSSet*)clusters
{
    for (GMSMarker *marker in _markerCache) {
        marker.map = nil;
    }
    
    [_markerCache removeAllObjects];
    
    for (id <GCluster> cluster in clusters) {
        GMSMarker *marker;
        marker = [[GMSMarker alloc] init];
        [_markerCache addObject:marker];
        
        NSUInteger count = cluster.items.count;
        if (count > 1) {
            marker.icon = [self generateClusterIconWithCount:count];
        }
        else {
            
            marker.icon = [UIImage imageNamed:iconOfSelectedMarker];
        }
        marker.position = cluster.position;
        marker.map = _map;
    }
}


- (UIImage*) generateClusterIconWithCount:(NSUInteger)count
{
    
    int diameter = 40;
    float inset = 3;
    
    CGRect rect = CGRectMake(0, 0, diameter, diameter);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // set stroking color and draw circle
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8] setStroke];
    if ([iconOfSelectedMarker isEqualToString:@"Parking.png"])
    {
        [[UIColor blueColor]setFill];
    }
    if ([iconOfSelectedMarker isEqualToString:@"BicycleShop.png"])
    {
        [[UIColor greenColor]setFill];
    }
    if ([iconOfSelectedMarker isEqualToString:@"Cafe.png"])
    {
        [[UIColor orangeColor] setFill];
    }
    if ([iconOfSelectedMarker isEqualToString:@"Supermarket.png"])
    {
        [[UIColor cyanColor]setFill];
    }
    CGContextSetLineWidth(ctx, inset);
    
    // make circle rect 5 px from border
    CGRect circleRect = CGRectMake(0, 0, diameter, diameter);
    circleRect = CGRectInset(circleRect, inset, inset);
    
    // draw circle
    CGContextFillEllipseInRect(ctx, circleRect);
    CGContextStrokeEllipseInRect(ctx, circleRect);
    
    CTFontRef myFont = CTFontCreateWithName( (CFStringRef)@"Helvetica-Bold", 18.0f, NULL);
    
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (__bridge id)myFont, (id)kCTFontAttributeName,
                                    [UIColor whiteColor], (id)kCTForegroundColorAttributeName, nil];
    
    // create a naked string
    NSString *string = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)count];
    
    NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:string
                                                                       attributes:attributesDict];
    
    // flip the coordinate system
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, diameter);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(stringToDraw));
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
                                                                        frameSetter, /* Framesetter */
                                                                        CFRangeMake(0, stringToDraw.length), /* String range (entire string) */
                                                                        NULL, /* Frame attributes */
                                                                        CGSizeMake(diameter, diameter), /* Constraints (CGFLOAT_MAX indicates unconstrained) */
                                                                        NULL /* Gives the range of string that fits into the constraints, doesn't matter in your situation */
                                                                        );
    CFRelease(frameSetter);
    
    //Get the position on the y axis
    float midHeight = diameter;
    midHeight -= suggestedSize.height;
    
    float midWidth = diameter / 2;
    midWidth -= suggestedSize.width / 2;
    
    CTLineRef line = CTLineCreateWithAttributedString(
                                                      (__bridge CFAttributedStringRef)stringToDraw);
    CGContextSetTextPosition(ctx, midWidth, 12);
    CTLineDraw(line, ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"categoryIcon"]) {
        iconOfSelectedMarker = [object categoryIcon];
    }
}

-(void)setObservingForMarkerIcon
{
    [dataModel.currentCategory addObserver:self
                     forKeyPath:@"categoryIcon"
                        options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void) dealloc
{
    [dataModel.currentCategory removeObserver:self
                        forKeyPath:@"categoryIcon"];
}


@end
