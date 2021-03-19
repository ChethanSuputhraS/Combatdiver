//
//  DataBaseManager.h
//  Elite Operator
//
//  Created by i-MaC on 4/9/15.
//  Copyright (c) 2015 com.oneclick.elite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <sqlite3.h>
@interface DataBaseManager : NSObject
{
    NSString *path;
	NSString* _dataBasePath;
	sqlite3 *_database;
	BOOL copyDb;
    BOOL ret;
    BOOL status;
    BOOL querystatus;
}
+(DataBaseManager*)dataBaseManager;
-(NSString*) getDBPath;
-(void)openDatabase;
-(BOOL)createDatabase;
-(BOOL)createAddressbook;
-(BOOL)createCannedMessage;
-(BOOL)createChatTable;
-(BOOL)createErrorLogTable;
-(BOOL)execute:(NSString*)sqlQuery resultsArray:(NSMutableArray*)dataTable;
-(BOOL)execute:(NSString*)sqlStatement;

#pragma mark- New Methods
-(BOOL)CrateNewCannedMessageTable;
-(BOOL)CreateNewContatTable;
-(BOOL)createNewChatTable;
-(BOOL)CrateDiverMsgTable;
-(BOOL)CreateHeatMessages;
-(BOOL)CreateDiver_Locate;
-(BOOL)CreateDiver_Locate_Details;


#pragma mark- ***************
-(NSInteger)getScalar:(NSString*)sqlStatement;
-(NSString*)getValue1:(NSString*)sqlStatement;

-(BOOL)insertScanneduserDetail:(NSDictionary *)dictInfo;
-(BOOL)insertAddressBookDetail:(NSDictionary *)dictInfo;
-(BOOL)insertChatDetail:(NSDictionary *)dictInfo;
-(BOOL)insertErrorLogDetail:(NSDictionary *)dictInfo;
-(BOOL)insertCannedMessageDetail:(NSDictionary *)dictInfo;
-(BOOL)updateMessage:(NSDictionary *)dictInfo with:(NSString *)user_id;

-(int)executeSw:(NSString*)sqlStatement;

- (NSMutableArray *)getHistoryData;
-(BOOL) executeAddress:(NSString*)sqlQuery resultsArray:(NSMutableArray*)dataTable;
-(BOOL)updateQuery:(NSDictionary *)dictInfo with:(NSString *)user_id;
-(void)addIMEIcolumnstoContactTable;
-(BOOL)createECGMeasurementTable;
-(void)addECGSerialNumbertoContact;
-(void)Add_ECG_Name_to_NewContact;
-(void)Add_sequence_to_NewChat;
@end
