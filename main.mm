#import <Foundation/Foundation.h>

// https://github.com/robbertkl/ResolutionMenu/blob/master/Resolution%20Menu/DisplayModeMenuItem.m
// CoreGraphics DisplayMode struct used in private APIs
typedef struct {
	uint32_t modeNumber;
	uint32_t flags;
	uint32_t width;
	uint32_t height;
	uint32_t depth;
	uint8_t unknown[170];
	uint16_t freq;
	uint8_t more_unknown[16];
	float density;
} CGSDisplayMode;

extern "C" {
	void CGSGetCurrentDisplayMode(CGDirectDisplayID display, int *mode);
	void CGSConfigureDisplayMode(CGDisplayConfigRef config, CGDirectDisplayID display, int mode);
	void CGSGetNumberOfDisplayModes(CGDirectDisplayID display, int *count);
	void CGSGetDisplayModeDescriptionOfLength(CGDirectDisplayID display, int index, CGSDisplayMode *mode, int length);
};

int main(int argc, char *argv[]) {
	@autoreleasepool {
		
		CGDirectDisplayID display = CGMainDisplayID();
		
		/*
		int current;
		CGSGetCurrentDisplayMode(display,&current);
		*/
		
		int num;
		CGSGetNumberOfDisplayModes(display,&num);
		
		CGSDisplayMode *modes = (CGSDisplayMode *)malloc(sizeof(CGSDisplayMode)*num);
		
		for(int k=0; k<num; k++) {
						
			CGSGetDisplayModeDescriptionOfLength(display,k,modes+k,sizeof(CGSDisplayMode));
			CGSDisplayMode *mode = &modes[k];
			
			if(mode->depth>4) {
				
				printf("| %d | %d | %d | %0.1f | %d |\n",mode->modeNumber,mode->width,mode->height,mode->density,mode->depth);
				
				/*
				if((mode->width==1920&&mode->height==1080&&mode->depth==8)) {
									
					if(k!=current) {
						NSLog(@"%dx%d",mode->width,mode->height);
						CGDisplayConfigRef config;
						CGBeginDisplayConfiguration(&config);
						CGSConfigureDisplayMode(config,display,mode->modeNumber);
						CGCompleteDisplayConfiguration(config,kCGConfigurePermanently);
					}
										
					break;
					
				}
				*/
			}
		}
	}
	
	return 0;
}