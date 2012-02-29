//
//  Utilities.cpp
//  Game
//
//  Created by  on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

#define PIXEL_PER_METER 50.

double meterToPixel(double x) {
    return x * PIXEL_PER_METER;
}

double pixelToMeter(double x) {
    return x / PIXEL_PER_METER;
}