//
//  Dispatcher.m
//  LAWDemo1
//
//  Created by Daniel Ho on 5/21/12.
//

#import "Dispatcher.h"
#import "TemplateID1.h"
#import "Template32.h"

static Dispatcher *_dispatcher = nil;

@implementation Dispatcher


+ (Dispatcher *)dispatcher 
{ 
	@synchronized(self)
    {
        if (_dispatcher == NULL)
		{
			_dispatcher = [[self alloc] init];
		}
    }
	
    return(_dispatcher);
} 

+(id)alloc
{	
	@synchronized([Dispatcher class])
	{ 
		NSAssert(_dispatcher == nil, @"Attempted to allocate a second instance of a singleton.");
		_dispatcher = [super alloc];
		return _dispatcher;
	}
	
	return nil;    
}

-(CXMLDocument*)loadFile:(NSString*)fileName
{
	//  using local resource file
    NSString *XMLPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
	NSData *XMLData   = [NSData dataWithContentsOfFile:XMLPath];
    CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:XMLData options:0 error:nil] autorelease];

    return doc;
}

-(int)getTemplateIDForDocument:(CXMLDocument*)doc
{
    NSArray *nodes = [doc nodesForXPath:@"//AUSY" error:nil];
    CXMLElement *root = [nodes objectAtIndex:0];
    id template = [root attributeForName:@"template"];
    if (template)
    {    
        NSString *templateString = [template stringValue];
        if ([templateString isEqualToString:@"id1"])
            return kTemplateIDID1;
        else if ([templateString isEqualToString:@"3-2"])
            return kTemplateID32;
    }   
    
    return kTemplateIDNone;
}

-(TemplateWindow*)getTemplateWindowForDocument:(CXMLDocument*)doc
{
    int templateID = [self getTemplateIDForDocument:doc];
    NSMutableDictionary *dict = [self getDictionaryForTemplateID:templateID forDocument:doc];
    
    if (templateID == kTemplateIDID1)
    {
        return [[[TemplateID1 alloc] initWithDictionary:dict] retain];
        
    }
    else if (templateID == kTemplateID32)
    {
        return [[[Template32 alloc] initWithDictionary:dict] retain];
    }
    return nil;
}

-(NSMutableDictionary*)getDictionaryForTemplateID:(int)templateID forDocument:(CXMLDocument*)doc
{
    NSMutableDictionary *dict = nil;
    NSString *fileID = nil;
    CXMLElement *node = nil;
    NSArray *nodes = nil;
    
    //Get file ID
    nodes = [doc nodesForXPath:@"//AUSY" error:nil];
    CXMLElement *root = [nodes objectAtIndex:0];
    id template = [root attributeForName:@"fileid"];
    if (template)
        fileID = [template stringValue];
        
    if (templateID == kTemplateIDID1)
    {
        //Get the instruction
        node = [self getNodeWithString:@"prompt" forAttribute:@"name" withXPath:@"//property" fromDoc:doc];
        nodes = [NSArray arrayWithObject:node];
        NSString *instruction = [self searchForAttribute:@"text" inNodes:nodes];
        
        //Get the questions
        node = [self getNodeWithString:@"question" forAttribute:@"name" withXPath:@"//property" fromDoc:doc];
        nodes = [NSArray arrayWithObject:node];
        NSMutableArray *stringArray = [[[NSMutableArray alloc] init] autorelease];
        [self searchForAttributes:@"text" inNodes:nodes putIntoArray:stringArray];
        
        //Get feedback 
        node = [self getNodeWithString:@"feedback" forAttribute:@"name" withXPath:@"//property" fromDoc:doc];
        nodes = [NSArray arrayWithObject:node];
        NSString *feedback = [self searchForAttribute:@"text" inNodes:nodes];
        
        //Get the answer
        node = [self getNodeWithString:@"answer" forAttribute:@"name" withXPath:@"//property" fromDoc:doc];
        nodes = [NSArray arrayWithObject:node];
        NSString *answer = [self searchForAttribute:@"value" inNodes:nodes];
        
        dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:instruction, @"instruction",
                                                                stringArray, @"questions",
                                                                feedback, @"feedback",
                                                                answer, @"answer", 
                                                                fileID, @"fileID", nil] autorelease];
    }
    else if (templateID == kTemplateID32)
    {
        //Get the instruction
        node = [self getNodeWithString:@"instruction" forAttribute:@"name" withXPath:@"//property" fromDoc:doc];
        nodes = [NSArray arrayWithObject:node];
        NSMutableArray *instructionArray = [[[NSMutableArray alloc] init] autorelease];
        [self searchForAttributes:@"text" inNodes:nodes putIntoArray:instructionArray];
        
        //Get the questions
        node = [self getNodeWithString:@"question" forAttribute:@"name" withXPath:@"//property" fromDoc:doc];
        nodes = [NSArray arrayWithObject:node];
        NSMutableArray *stringArray = [[[NSMutableArray alloc] init] autorelease];
        [self searchForAttributes:@"text" inNodes:nodes putIntoArray:stringArray];
        
        //Get the number of choices
        node = [self getNodeWithString:@"count" forAttribute:@"name" withXPath:@"//property" fromDoc:doc];
        NSString *countString = [[node attributeForName:@"value"] stringValue];
        int count = [countString intValue];
     
        //Get all the choices and messages
        NSString *tempString = nil;
        NSMutableArray *choiceArray = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
        NSMutableArray *messageArray = [[[NSMutableArray alloc] initWithCapacity:count] autorelease];
        for (int i = 1; i <= count; i++)
        {
            tempString = [NSString stringWithFormat:@"%i-choice", i];
            node = [self getNodeWithString:tempString forAttribute:@"name" withXPath:@"//property" fromDoc:doc];
            nodes = [NSArray arrayWithObject:node];
            NSString *choice = [self searchForAttribute:@"text" inNodes:nodes];
            if (choice != nil)
                [choiceArray addObject:choice];
            
            tempString = [NSString stringWithFormat:@"%i-message", i];
            node = [self getNodeWithString:tempString forAttribute:@"name" withXPath:@"//property" fromDoc:doc];
            if (node != nil)
            {
                nodes = [NSArray arrayWithObject:node];
                NSString *message = [self searchForAttribute:@"text" inNodes:nodes];
                if (message != nil)
                    [messageArray addObject:message];
                else
                    [messageArray addObject:@"answer"];
            }
            else
                [messageArray addObject:@"answer"];
            
        }
        
        dict = [[[NSMutableDictionary alloc] initWithObjectsAndKeys:instructionArray, @"instructions",
                 stringArray, @"questions",
                 choiceArray, @"choices",
                 messageArray, @"messages", 
                 fileID, @"fileID", nil] autorelease];
    }
    
    return dict;
}

// Recursively search for the first given attribute within the array of nodes
-(NSString*)searchForAttribute:(NSString*)attribute inNodes:(NSArray*)nodes
{
    if (nodes == nil || [nodes count] == 0)
        return nil;
    
    for (CXMLElement *node in nodes)
    {
        if (![node isKindOfClass:[CXMLElement class]])
            continue;
        
        CXMLNode *attributeNode = [node attributeForName:attribute];
        if (attributeNode != nil)
            return [attributeNode stringValue];
        else
            return [self searchForAttribute:attribute inNodes:[node children]];
    }
    return nil;
}

// Recursively search for all the attributes within the array of nodes, and put into stringArray
-(void)searchForAttributes:(NSString*)attribute inNodes:(NSArray*)nodes putIntoArray:(NSMutableArray*)stringArray
{
    if (nodes == nil || [nodes count] == 0)
        return;
    
    for (CXMLElement *node in nodes)
    {
        if (![node isKindOfClass:[CXMLElement class]])
            continue;
        
        NSString *string = nil;
        CXMLNode *attributeNode = [node attributeForName:attribute];
        if (attributeNode != nil)
            string = [attributeNode stringValue];
        else
            [self searchForAttributes:attribute inNodes:[node children] putIntoArray:stringArray];
        
        if (string != nil)
            [stringArray addObject:string];
    }
}

// Returns the element with the attribute of value "name" with the given xPath in the given doc
-(CXMLElement*)getNodeWithString:(NSString*)name forAttribute:(NSString*)attribute withXPath:(NSString*)xPath fromDoc:(CXMLDocument*)doc
{
    NSArray *nodes = [doc nodesForXPath:xPath error:nil];
    for (CXMLElement *node in nodes) 
    {
        id nodeId = [node attributeForName:attribute];
        if (nodeId)
            if ([[nodeId stringValue] isEqualToString:name])
                return node;
	}
    return nil;
}



@end
