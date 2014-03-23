//
//  TableViewController.m
//  PicportLauncher
//
//  Created by itok on 2014/03/21.
//  Copyright (c) 2014年 itok. All rights reserved.
//

#import "TableViewController.h"
#import "Picport.h"

#define APP_NAME    @"PicportLauncher"
#define BACK_URL    @"PicportLauncher://"
#define HASH_TAG    @"#PicportLauncher"

#define NUMBER_ASSETS   (1)

@import MobileCoreServices;

@interface TableViewController () <UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController* docCtl;
@property (nonatomic, strong) NSMutableArray* urls;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UISwitch *callbackSw;
@property (weak, nonatomic) IBOutlet UISwitch *hashtagSw;

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) imagePath
{
    NSArray* exts = @[@"jpg", @"png", @"mov"];
    
    return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d", self.segment.selectedSegmentIndex] ofType:[exts objectAtIndex:self.segment.selectedSegmentIndex]];
}

-(NSDictionary*) options
{
    NSMutableDictionary* options = [NSMutableDictionary dictionary];
    if (self.callbackSw.on) {
        [options setObject:APP_NAME forKey:PPPicportParamAppName];
        [options setObject:BACK_URL forKey:PPPicportParamBackURL];
    }
    if (self.hashtagSw.on) {
        [options setObject:HASH_TAG forKey:PPPicportParamHashTag];
    }
    return options;
}


#pragma mark -

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.section) {
		case 0:
		{
			switch (indexPath.row) {
				case 1:
				{
					// Use UIDocumentInteractionViewController
					NSURL* url = [NSURL fileURLWithPath:[self imagePath]];
					self.docCtl = [UIDocumentInteractionController interactionControllerWithURL:url];
					self.docCtl.delegate = self;
					self.docCtl.annotation = [self options];
					[self.docCtl presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
				}
					break;
				default:
					break;
			}
		}
			break;
		case 2:
		{
			switch (indexPath.row) {
				case 0:
				{
					// Use pasteboard as data
					NSURL* url = [NSURL fileURLWithPath:[self imagePath]];
					NSString* uti = (__bridge_transfer NSString*)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[url pathExtension], NULL);
					NSData* data = [NSData dataWithContentsOfURL:url];
					
					[Picport openPicportWithData:data UTI:uti options:[self options]];
				}
					break;
				case 1:
				{
					// Use pasteboard as image
					UIImage* img = [UIImage imageWithContentsOfFile:[self imagePath]];
					[Picport openPicportWithImage:img options:[self options]];
				}
					break;
				case 2:
				{
					// Use AssetsLibrary
					self.urls = [NSMutableArray array];
					
					UIImagePickerController* ctl = [[UIImagePickerController alloc] init];
					ctl.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
					ctl.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:ctl.sourceType];
					ctl.delegate = self;
					[self presentViewController:ctl animated:YES completion:nil];
				}
					break;
				case 3:
				{
					// Use latest photo
					[Picport openPicportWithLatestPhoto];
				}
					break;
					
				default:
					break;
			}
		}
			break;
		case 3:
			// Open AppStore
			[Picport openAppStore];
			break;
		default:
			break;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIDocumentInteractionController

-(void) documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
	self.docCtl = nil;
}

#pragma mark UIImagePickerController

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL* url = [info objectForKey:UIImagePickerControllerReferenceURL];
    if (url) {
        [self.urls addObject:url];
        if ([self.urls count] == NUMBER_ASSETS) {
			[self dismissViewControllerAnimated:YES completion:^{
				[Picport openPicportWithAssetURLs:self.urls options:[self options]];
			}];
        }
    }
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
