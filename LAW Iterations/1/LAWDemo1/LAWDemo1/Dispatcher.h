//
//  Dispatcher.h
//  LAWDemo1
//
//  Created by Daniel Ho on 5/21/12.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"
#import "TemplateWindow.h"

enum templateID
{
    kTemplateIDNone = -1,
    kTemplateIDID1,
    kTemplateID32,
};

@interface Dispatcher : NSObject
{

}

-(int)getTemplateIDForDocument:(CXMLDocument*)doc;
-(TemplateWindow*)getTemplateWindowForDocument:(CXMLDocument*)doc;
-(NSMutableDictionary*)getDictionaryForTemplateID:(int)templateID forDocument:(CXMLDocument*)doc;
-(CXMLElement*)getNodeWithString:(NSString*)name forAttribute:(NSString*)attribute withXPath:(NSString*)xPath fromDoc:(CXMLDocument*)doc;
-(NSString*)searchForAttribute:(NSString*)attribute inNodes:(NSArray*)nodes;
-(void)searchForAttributes:(NSString*)attribute inNodes:(NSArray*)nodes putIntoArray:(NSMutableArray*)stringArray;
-(CXMLDocument*)loadFile:(NSString*)fileName;
+ (Dispatcher *)dispatcher;

@end
