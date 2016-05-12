
// Name: Warren Seto
// Course: CSC 415
// Semester: Spring 2016
// Instructor: Dr. Pulimood
// Project name: Semestr
// Description: An iOS application that keeps track of classes, events, and meetings for students and professors over various semesters in multiple disciplines.
// Filename: UIImage_Extension.swift
// Description: An extension of the UIImage class and UIColor class to get the prominent and dominant colors of an image.
// Last modified on: May 12, 2016

import UIKit

extension UIImage
{
    //-----------------------------------------------------------------------------------------
    //
    //  Function: getColors()
    //
    //    Parameters:
    //    completionHandler Pallet; the structure of the pallet of colors from an image
    //
    //    Pre-condition: A UIImage Object is already initialized
    //    Post-condition: A structure with the prominent and dominant colors of a given image. These are returned asynchronously
    //-----------------------------------------------------------------------------------------
    
    func getColors(completionHandler: (Pallet) -> Void)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            let prcoessImage = self.resizeImage(CGSize(width: 250, height: 250/(self.size.width/self.size.height))).CGImage,
                width = CGImageGetWidth(prcoessImage),
                height = CGImageGetHeight(prcoessImage),
                memColor = CGColorSpaceCreateDeviceRGB(),
                rawByte = malloc(width * height * 4),
                bitMap = CGImageAlphaInfo.PremultipliedFirst.rawValue,
                leftEdge = NSCountedSet(capacity: height),
                colorArray = NSCountedSet(capacity: width * height),
                canvas = CGBitmapContextCreate(rawByte, width, height, 8, width * 4, memColor, bitMap),
                imageData = UnsafePointer<UInt8>(CGBitmapContextGetData(canvas))
            
            CGContextDrawImage(canvas, CGRect(x: 0, y: 0, width: width, height: height), prcoessImage)
            
            for count in 0..<width
            {
                for count2 in 0..<height
                {
                    let pixel = ((width * count2) + count) * 4,
                        pixelColor = UIColor(red: CGFloat(imageData[pixel+1])/255, green: CGFloat(imageData[pixel+2])/255, blue: CGFloat(imageData[pixel+3])/255, alpha: 1)
                    
                    if 5 <= count && count <= 10
                    {
                        leftEdge.addObject(pixelColor)
                    }
                        colorArray.addObject(pixelColor)
                }
            }
            
            var e = leftEdge.objectEnumerator(),
                colorRank = NSMutableArray(capacity: leftEdge.count)
            
            while let colorElement = e.nextObject() as? UIColor
            {
                let colorCount = leftEdge.countForObject(colorElement)
                
                if (Int(CGFloat(height) * 0.01) < colorCount)
                {
                    colorRank.addObject(Pixel(colorElement, colorCount))
                }
            }
            
            colorRank.sortUsingComparator({ (one, two) -> NSComparisonResult in
                return (one as! Pixel).count < (two as! Pixel).count ? NSComparisonResult.OrderedDescending : NSComparisonResult.OrderedAscending
            })
            
            var edgeColor = colorRank.count > 0 ? colorRank.objectAtIndex(0) as! Pixel : Pixel(UIColor.blackColor(), 1)
            if edgeColor.color.whiteORdark() && 0 < colorRank.count
            {
                for count in 1..<colorRank.count
                {
                    let newEdgeColor = colorRank.objectAtIndex(count) as! Pixel
                    if (CGFloat(newEdgeColor.count) / CGFloat(edgeColor.count)) > 0.3
                    {
                        if (!newEdgeColor.color.whiteORdark())
                        {
                            edgeColor = newEdgeColor
                            break
                        }
                    }
                    else
                    {
                        break
                    }
                }
            }
            
            var result = Pallet()
            result.prominent = edgeColor.color
            
            e = colorArray.objectEnumerator()
            colorRank.removeAllObjects()
            colorRank = NSMutableArray(capacity: colorArray.count)
            
            while var colorElement = e.nextObject() as? UIColor
            {
                colorElement = colorElement.saturatedColor(0.15)
                
                if colorElement.dark() == (!result.prominent.dark())
                {
                    colorRank.addObject(Pixel(colorElement, colorArray.countForObject(colorElement)))
                }
            }
            
            colorRank.sortUsingComparator({ (one, two) -> NSComparisonResult in
                return (one as! Pixel).count < (two as! Pixel).count ? NSComparisonResult.OrderedDescending : NSComparisonResult.OrderedAscending
            })
            
            for checkColor in colorRank where result.dominant == nil
            {
                if ((checkColor as! Pixel).color).contrastColor(result.prominent)
                {
                    result.dominant = (checkColor as! Pixel).color
                }
                
                dispatch_async(dispatch_get_main_queue())
                {
                    completionHandler(result)
                }
            }
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: resizeImage()
    //
    //    Parameters:
    //    newSize CGSize; A structure that represents a given height and width
    //
    //    Pre-condition: A UIImage Object is already initialized
    //    Post-condition: A resized UIImage object based on the inputted height and width
    //-----------------------------------------------------------------------------------------
    
    func resizeImage(newSize: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.drawInRect(CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output
    }
}

extension UIColor
{
    //-----------------------------------------------------------------------------------------
    //
    //  Function: dark()
    //
    //    Parameters: None
    //
    //    Pre-condition: A UIColor Object is already initialized
    //    Post-condition: A boolean is returned to check if the color is at least 80% gray
    //-----------------------------------------------------------------------------------------
    
    func dark() -> Bool
    {
        let color = CGColorGetComponents(self.CGColor)
        return (0.2126 * color[0] + 0.7152 * color[1] + 0.0722 * color[2]) < 0.5
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: whiteORdark()
    //
    //    Parameters: None
    //
    //    Pre-condition: A UIColor Object is already initialized
    //    Post-condition: A boolean is returned to check if the color is at either less than 30% gray or more than 70% gray
    //-----------------------------------------------------------------------------------------
    
    func whiteORdark() -> Bool
    {
        let color = CGColorGetComponents(self.CGColor)
        return (color[0] > 0.91 && color[1] > 0.91 && color[2] > 0.91) || (color[0] < 0.09 && color[1] < 0.09 && color[2] < 0.09)
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: saturatedColor()
    //
    //    Parameters:
    //    minSaturation CGFloat; A CGFloat structure that defines the amount of saturation that should be applied on the color
    //
    //    Pre-condition: A UIColor Object is already initialized
    //    Post-condition: A UIColor object is returned with the result of the the current color with a saturation filter applied
    //-----------------------------------------------------------------------------------------
    
    func saturatedColor(minSaturation: CGFloat) -> UIColor
    {
        var hue: CGFloat = 0.0, sat: CGFloat = 0.0, whiteness: CGFloat = 0.0, alpha: CGFloat = 0.0
        self.getHue(&hue, saturation: &sat, brightness: &whiteness, alpha: &alpha)
        return sat < minSaturation ? UIColor(hue: hue, saturation: minSaturation, brightness: whiteness, alpha: alpha) : self
    }
    
    //-----------------------------------------------------------------------------------------
    //
    //  Function: contrastColor()
    //
    //    Parameters:
    //    compareColor UIColor; An UIColor object that is initialized with red, green and blue values
    //
    //    Pre-condition: A UIColor Object is already initialized
    //    Post-condition: A boolean is returned with the result of the comparison between the current color and the inputted color
    //-----------------------------------------------------------------------------------------
    
    func contrastColor(compareColor: UIColor) -> Bool
    {
        let color1 = CGColorGetComponents(self.CGColor),
            color2 = CGColorGetComponents(compareColor.CGColor),
            compare1 = 0.2126 * color1[0] + 0.7152 * color1[1] + 0.0722 * color1[2],
            compare2 = 0.2126 * color2[0] + 0.7152 * color2[1] + 0.0722 * color2[2]
        
        return 1.6 < ((compare1 > compare2) ? (compare1 + 0.05)/(compare2 + 0.05):(compare2 + 0.05)/(compare1 + 0.05))
    }
}

