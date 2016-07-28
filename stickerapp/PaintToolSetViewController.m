//
//  PaintToolSetViewController.m
//  CatwangFree
//
//  Created by Fonky on 2/24/15.
//
//

#import "PaintToolSetViewController.h"

@interface PaintToolSetViewController (){
    BOOL paint;
}

@end

@implementation PaintToolSetViewController

@synthesize delegate;

- (void)viewDidLoad {
    paint = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)setDone:(id)sender {
    
    [self.delegate editModePaintSetDone:self];
    
}
// PAINTER
-(IBAction)setPaint:(UIButton *)sender {
    
    if (paint){
        
        [sender setImage:[UIImage imageNamed:@"ui_btn_tool_erase.png"] forState:UIControlStateNormal];
        [self.delegate editModePaintSetEraser:self];


        paint = NO;
    } else {
        
        [sender setImage:[UIImage imageNamed:@"ui_btn_tool_paint.png"] forState:UIControlStateNormal];
        [self.delegate editModePaintSetPaint:self];

        paint = YES;
    }
    
}

-(IBAction)setEraser:(id)sender {
    
    
}

-(IBAction)changeSlider:(id)sender {
    
    [self.delegate editModePaintSetSize:self withValue:[(UISlider *)sender value]];
    
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
