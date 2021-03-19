//
//  DataBaseManager.m
//  Elite Operator
//
//  Created by i-MaC on 4/9/15.
//  Copyright (c) 2015 com.oneclick.elite. All rights reserved.
//

#import "DataBaseManager.h"
static DataBaseManager * dataBaseManager = nil;

@implementation DataBaseManager
#pragma mark - DataBaseManager initialization
-(id) init
{
    self = [super init];
	if (self)
    {
		// get full path of database in documents directory
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		path = [paths objectAtIndex:0];
		_dataBasePath = [path stringByAppendingPathComponent:@"eliteOperator.sqlite"];
        
        NSLog(@"data base path:%@",path);
		
//		_database = nil;
		[self openDatabase];
    }
	return self;
    
}
+(DataBaseManager*)dataBaseManager
{
    static dispatch_once_t _singletonPredicate;
    dispatch_once(&_singletonPredicate, ^{
        if (!dataBaseManager)
        {
            dataBaseManager = [[super alloc]init];
        }
    });
    
	return dataBaseManager;
}

- (NSString *) getDBPath
{
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"eliteOperator.sqlite"];
    
}
-(void)openDatabase
{
	BOOL ok;
	NSError *error;
	
	/*
	 * determine if database exists.
	 * create a file manager object to test existence
	 *
	 */
	NSFileManager *fm = [NSFileManager defaultManager]; // file manager
	ok = [fm fileExistsAtPath:_dataBasePath];
	
	// if database not there, copy from resource to path
	if (!ok)
    {
        // location in resource bundle
        NSString *appPath = [[[NSBundle mainBundle] resourcePath]
                             stringByAppendingPathComponent:@"eliteOperator.sqlite"];
        if ([fm fileExistsAtPath:appPath])
        {
            // copy from resource to where it should be
            copyDb = [fm copyItemAtPath:appPath toPath:_dataBasePath error:&error];
            
            if (error!=nil)
            {
                copyDb = FALSE;
            }
            ok = copyDb;
        }
        
    }
    
    
    // open database
    if (sqlite3_open([_dataBasePath UTF8String], &_database) != SQLITE_OK)
    {
        sqlite3_close(_database); // in case partially opened
        _database = nil; // signal open error
    }
    
    if (!copyDb && !ok)
    { // first time and database not copied
        ok = [self createDatabase]; // create empty database
        if (ok)
        {
            // Populating Table first time from the keys.plist
            /*	NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"ads" ofType:@"plist"];
             NSArray *contents = [NSArray arrayWithContentsOfFile:pListPath];
             for (NSDictionary* dictionary in contents) {
             
             NSArray* keys = [dictionary allKeys];
             [self execute:[NSString stringWithFormat:@"insert into ads values('%@','%@','%@')",[dictionary objectForKey:[keys objectAtIndex:0]], [dictionary objectForKey:[keys objectAtIndex:1]],[dictionary objectForKey:[keys objectAtIndex:2]]]];
             }*/
        }
    }
    
    if (!ok)
    {
        // problems creating database
        NSAssert1(0, @"Problem creating database [%@]",
                  [error localizedDescription]);
    }
    
}

-(BOOL)createDatabase
{
    int rc;
    
	// SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'scanned_user'(id integer primary key autoincrement not null,'name' varchar(255) NOT NULL,'user_id' varchar(255) NOT NULL,'photo' varchar(255) NOT NULL,'created_time' varchar(255) NOT NULL,'device_id' varchar(255) NOT NULL)",nil];
    
    
    
    NSLog(@"querie %@",queries);
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}

-(BOOL)createAddressbook
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Address_book' (id integer primary key autoincrement not null,'name' varchar(255) NOT NULL,'user_id' varchar(255) NOT NULL,'photo' TEXT NOT NULL,'created_time' varchar(255) NOT NULL,'device_id' varchar(255) NOT NULL)",nil];
    
    NSLog(@"querie %@",queries);
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}
-(BOOL)createCannedMessage
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Canned_message' (id integer primary key autoincrement not null,'Message' varchar(255) NOT NULL,'is_emergency' varchar(255) NOT NULL,'created_time' varchar(255) NOT NULL)",nil];
    
    NSLog(@"querie %@",queries);
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}

-(BOOL)createChatTable

{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Chat_table' (id integer primary key autoincrement not null,'from_userId' varchar(255) NOT NULL,'to_userId' varchar(255) NOT NULL,'message' varchar(255) NOT NULL,'time' varchar(255) NOT NULL,'device_id' varchar(255) NOT NULL,'from_sent' varchar(255) NOT NULL,'status' varchar(255) NOT NULL)",nil];
    
    NSLog(@"querie %@",queries);
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
}

-(BOOL)createErrorLogTable
{
    int rc;
    
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'ErrorLog_Table' (id integer primary key autoincrement not null,'button_title' varchar(255) NOT NULL,'message' varchar(255) NOT NULL,'time' varchar(255) NOT NULL)",nil];
    
    NSLog(@"querie %@",queries);
    
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                // statement built, execute
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
        
        
    }
    
    return ret;
    
    
}
#pragma mark - New Database List
-(BOOL)CrateNewCannedMessageTable
{
    int rc;
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'NewCanned_message' (id integer primary key autoincrement not null,'Message' varchar(255) ,'is_emergency' varchar(255),'indexStr' varchar(255))",nil];
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
    }
    return ret;
}
-(BOOL)CrateDiverMsgTable
{
    int rc;
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'DiverMessage' (id integer primary key autoincrement not null,'Message' varchar(255) ,'is_emergency' varchar(255),'indexStr' varchar(255))",nil];
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
    }
    return ret;
}
-(BOOL)CreateNewContatTable
{
    int rc;
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'NewContact' (id integer primary key autoincrement not null,'name' varchar(255),'phone' varchar(255),'nano' varchar(255),'irridium_id' varchar(255),'msg' varchar(255),'time' varchar(255),'SC4_nano_id' varchar(255),'lignlight_nano_id' varchar(255),'SC4_Ble_address' varchar(255),'lignlight_Ble_Address' varchar(255),'isBoat' varchar(255),'gsm_irridium_id' varchar(255))",nil];
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
    }
    return ret;
}
-(BOOL)CreateDiver_Locate
{
    int rc;
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Diver_Locate' (id integer primary key autoincrement not null,'diver_id' varchar(255) ,'diver_name' varchar(255),'time' varchar(255), 'nanoID' varchar(255), 'status' varchar(255))",nil];
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
    }
    return ret;
}
-(BOOL)CreateDiver_Locate_Details
{
    int rc;
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'Diver_Locate_Detail' (id integer primary key autoincrement not null,'diver_locate_id' varchar(255) ,'step1_distance' varchar(255), 'step1_lat' varchar(255), 'step1_long' varchar(255), 'step1_pingtime' varchar(255), 'step2_distance' varchar(255), 'step2_lat' varchar(255), 'step2_long' varchar(255), 'step2_pingtime' varchar(255), 'step3_distance' varchar(255), 'step3_lat' varchar(255), 'step3_long' varchar(255), 'step3_pingtime' varchar(255), 'final_lat' varchar(255), 'final_long' varchar(255), 'status' varchar(255))",nil];
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
    }
    return ret;
}

-(void)addIMEIcolumnstoContactTable
{
    sqlite3_stmt *createStmt = nil;

    NSString *query = [NSString stringWithFormat:@"ALTER TABLE NewContact ADD COLUMN imei TEXT"];

    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &createStmt, NULL) == SQLITE_OK)
    {
        sqlite3_exec(_database, [query UTF8String], NULL, NULL, NULL);
    }
    else
    {
        NSLog(@"The imei table already exist in Contact");
    }

    sqlite3_finalize(createStmt);
}
-(void)addECGSerialNumbertoContact
{
    sqlite3_stmt *createStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"ALTER TABLE NewContact ADD COLUMN serial_no TEXT"];
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &createStmt, NULL) == SQLITE_OK)
    {
        sqlite3_exec(_database, [query UTF8String], NULL, NULL, NULL);
    }
    else
    {
        NSLog(@"The imei table already exist in Contact");
    }
    
    sqlite3_finalize(createStmt);
}
-(void)Add_ECG_Name_to_NewContact
{
    sqlite3_stmt *createStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"ALTER TABLE NewContact ADD COLUMN ecgdevice_name TEXT"];
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &createStmt, NULL) == SQLITE_OK)
    {
        sqlite3_exec(_database, [query UTF8String], NULL, NULL, NULL);
    }
    else
    {
        NSLog(@"The imei table already exist in Contact");
    }
    
    sqlite3_finalize(createStmt);
}

-(BOOL)createNewChatTable
{
    int rc;
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'NewChat' (id integer primary key autoincrement not null,'from_name' varchar(255),'from_nano' varchar(255),'to_name' varchar(255),'to_nano' varchar(255),'msg_id' varchar(255),'msg_txt' varchar(255),'time' varchar(255),'status' varchar(255),'timeStamp' real)",nil];
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
    }
    return ret;
}

-(BOOL)CreateHeatMessages
{
    int rc;
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"create table 'HeatMessage' (id integer primary key autoincrement not null,'Message' varchar(255) ,'Msgid' varchar(255),'indexStr' varchar(255))",nil];
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
    }
    return ret;
}
-(BOOL)createECGMeasurementTable
{
    int rc;
    // SQL to create new database
    NSArray* queries = [NSArray arrayWithObjects:
                        @"CREATE TABLE measurementsecg (id integer primary key, recordingid integer, timestamp long, diver_id text, ECG_serial text, findings text, comments text, synced boolean, measurement_patients_id integer, offset long, modified boolean, measurement_patient_id integer)",nil];
    if(queries != nil)
    {
        for (NSString* sql in queries)
        {
            sqlite3_stmt *stmt;
            rc = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL);
            ret = (rc == SQLITE_OK);
            //            //NSLog(@" create %@",sql);
            if (ret)
            {
                rc = sqlite3_step(stmt);
                ret = (rc == SQLITE_DONE);
                sqlite3_finalize(stmt); // free statement
                //sqlite3_reset(stmt);
            }
        }
    }
    return ret;
}
-(void)Add_sequence_to_NewChat
{
    sqlite3_stmt *createStmt = nil;
    
    NSString *query = [NSString stringWithFormat:@"ALTER TABLE NewChat ADD COLUMN sequence TEXT"];
    
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &createStmt, NULL) == SQLITE_OK)
    {
        sqlite3_exec(_database, [query UTF8String], NULL, NULL, NULL);
    }
    else
    {
        NSLog(@"The Session table already exist in NewChat");
    }
    
    sqlite3_finalize(createStmt);
}

#pragma mark - Insert Query
/*
 * Method to execute the simple queries
 */
-(BOOL)execute:(NSString*)sqlStatement
{
	sqlite3_stmt *statement = nil;
    status = FALSE;
	//NSLog(@"%@",sqlStatement);
	const char *sql = (const char*)[sqlStatement UTF8String];
    
	
	if(sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
           NSAssert1(0, @"Error while preparing  statement. '%s'", sqlite3_errmsg(_database));
        status = FALSE;
    } else {
        status = TRUE;
    }
	if (sqlite3_step(statement)!=SQLITE_DONE) {
        	NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        status = FALSE;
	} else {
        status = TRUE;
	}
	
	sqlite3_finalize(statement);
    return status;
}
#pragma mark - SQL query methods
/*
 * Method to get the data table from the database
 */
-(BOOL) execute:(NSString*)sqlQuery resultsArray:(NSMutableArray*)dataTable
{
    
    char** azResult = NULL;
    int nRows = 0;
    int nColumns = 0;
    querystatus = FALSE;
    char* errorMsg; //= malloc(255); // this is not required as sqlite do it itself
    const char* sql = [sqlQuery UTF8String];
    sqlite3_get_table(
                      _database,  /* An open database */
                      sql,     /* SQL to be evaluated */
                      &azResult,          /* Results of the query */
                      &nRows,                 /* Number of result rows written here */
                      &nColumns,              /* Number of result columns written here */
                      &errorMsg      /* Error msg written here */
                      );
	
    if(azResult != NULL)
    {
        nRows++; //because the header row is not account for in nRows
		
        for (int i = 1; i < nRows; i++)
        {
            NSMutableDictionary* row = [[NSMutableDictionary alloc]initWithCapacity:nColumns];
            for(int j = 0; j < nColumns; j++)
            {
                NSString*  value = nil;
                NSString* key = [NSString stringWithUTF8String:azResult[j]];
                if (azResult[(i*nColumns)+j]==NULL)
                {
                    value = [NSString stringWithUTF8String:[[NSString string] UTF8String]];
                }
                else
                {
                    value = [NSString stringWithUTF8String:azResult[(i*nColumns)+j]];
                }
				
                [row setValue:value forKey:key];
            }
            [dataTable addObject:row];
        }
        querystatus = TRUE;
        sqlite3_free_table(azResult);
    }
    else
    {
        NSAssert1(0,@"Failed to execute query with message '%s'.",errorMsg);
        querystatus = FALSE;
    }
    
    return 0;
}
-(NSInteger)getScalar:(NSString*)sqlStatement
{
	NSInteger count = -1;
	
	const char* sql= (const char *)[sqlStatement UTF8String];
	sqlite3_stmt *selectstmt;
	if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
    {
		while(sqlite3_step(selectstmt) == SQLITE_ROW)
        {
			count = sqlite3_column_int(selectstmt, 0);
		}
	}
	sqlite3_finalize(selectstmt);
	
	return count;
}

-(NSString*)getValue1:(NSString*)sqlStatement
{
	
	NSString* value = nil;
	const char* sql= (const char *)[sqlStatement UTF8String];
	sqlite3_stmt *selectstmt;
	if(sqlite3_prepare_v2(_database, sql, -1, &selectstmt, NULL) == SQLITE_OK)
    {
		while(sqlite3_step(selectstmt) == SQLITE_ROW)
        {
			if ((char *)sqlite3_column_text(selectstmt, 0)!=nil)
            {
				value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 0)];
			}
		}
	}
	return value;
}

-(BOOL)insertScanneduserDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'scanned_user'('name','user_id','photo','created_time','device_id') values(?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"name"]];
                if (row1 && [row1 length] > 0) {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"user_id"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"photo"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    NSData * data =[dicInfo valueForKey:@"photo"];
                    sqlite3_bind_blob(statement, 3, [data bytes], [data length], NULL);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_time"]];
                if (row4 && [row4 length] > 0) {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                    NSLog(@"%@",row4);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row5 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"device_id"]];
                if (row5 && [row5 length] > 0) {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(BOOL)insertAddressBookDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'Address_book'('name','user_id','photo','created_time','device_id') values(?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"name"]];
                if (row1 && [row1 length] > 0) {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"user_id"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"photo"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    NSData * data =[dicInfo valueForKey:@"photo"];
                    sqlite3_bind_blob(statement, 3, [data bytes], [data length], NULL);
                }
            
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_time"]];
                if (row4 && [row4 length] > 0) {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                    NSLog(@"%@",row4);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row5 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"device_id"]];
                if (row5 && [row5 length] > 0) {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(BOOL)insertChatDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
           
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'Chat_table'('from_userId','to_userId','message','time','device_id','from_sent','status') values(?,?,?,?,?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"from_userId"]];
                if (row1 && [row1 length] > 0) {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"to_userId"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"message"]];
                if (row3 && [row3 length] > 0) {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"time"]];
                if (row4 && [row4 length] > 0) {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                    NSLog(@"%@",row4);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row5 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"device_id"]];
                if (row5 && [row5 length] > 0) {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row6 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"from_sent"]];
                if (row6 && [row6 length] > 0) {
                    sqlite3_bind_text(statement, 6,[row6 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 6, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row7 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"status"]];
                if (row7 && [row7 length] > 0) {
                    sqlite3_bind_text(statement, 7,[row7 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 7, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(BOOL)insertErrorLogDetail:(NSDictionary *)dictInfo
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
           
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'ErrorLog_Table'('button_title','message','time') values(?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"button_title"]];
                if (row1 && [row1 length] > 0) {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"message"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"time"]];
                if (row3 && [row3 length] > 0) {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
               
                
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(NSData *)getimages:(NSString *)idStr
{
    NSData *imageData;
    sqlite3_stmt *compiledStmt;
    sqlite3 *db;
    int i = [idStr intValue];
    if(sqlite3_open([_dataBasePath UTF8String], &db)==SQLITE_OK){
        NSString *insertSQL = [NSString stringWithFormat:@"Select photo from Address_book Where Id= %d",i];
        if(sqlite3_prepare_v2(db,[insertSQL cStringUsingEncoding:NSUTF8StringEncoding], -1, &compiledStmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStmt) == SQLITE_ROW) {
                
                int length = sqlite3_column_bytes(compiledStmt, 0);
                imageData = [NSData dataWithBytes:sqlite3_column_blob(compiledStmt, 0) length:length];
                
                NSLog(@"Length : %d", [imageData length]);
                
                if(imageData == nil)
                    NSLog(@"No image found.");
                else{
                    
                    }
        }
        sqlite3_finalize(compiledStmt);
    }
    sqlite3_close(db);
}

    return imageData;
}

-(BOOL) executeAddress:(NSString*)sqlQuery resultsArray:(NSMutableArray*)dataTable
{
    
    char** azResult = NULL;
    int nRows = 0;
    int nColumns = 0;
    querystatus = FALSE;
    char* errorMsg; //= malloc(255); // this is not required as sqlite do it itself
    const char* sql = [sqlQuery UTF8String];
    sqlite3_get_table(
                      _database,  /* An open database */
                      sql,     /* SQL to be evaluated */
                      &azResult,          /* Results of the query */
                      &nRows,                 /* Number of result rows written here */
                      &nColumns,              /* Number of result columns written here */
                      &errorMsg      /* Error msg written here */
                      );
	
    if(azResult != NULL)
    {
        nRows++; //because the header row is not account for in nRows
		
        for (int i = 1; i < nRows; i++)
        {
            NSMutableDictionary* row = [[NSMutableDictionary alloc]initWithCapacity:nColumns];
            for(int j = 0; j < nColumns; j++)
            {
                NSString*  value = nil;
                NSString* key = [NSString stringWithUTF8String:azResult[j]];
                if (azResult[(i*nColumns)+j]==NULL)
                {
                    value = [NSString stringWithUTF8String:[[NSString string] UTF8String]];
                }
                else
                {
                    value = [NSString stringWithUTF8String:azResult[(i*nColumns)+j]];
                }
                
				
                [row setValue:value forKey:key];
            }
            
            NSData * myData =[self getimages:[NSString stringWithFormat:@"%d",i]];
            if ([myData length]==0)
            {
                [row setObject:@"" forKey:@"photo"];

            }
            else
            {
                [row setObject:myData forKey:@"photo"];

            }
            [dataTable addObject:row];
        }
        querystatus = TRUE;
        sqlite3_free_table(azResult);
    }
    else
    {
        NSAssert1(0,@"Failed to execute query with message '%s'.",errorMsg);
        querystatus = FALSE;
    }
    
    return 0;
}
-(BOOL)updateQuery:(NSDictionary *)dictInfo with:(NSString *)user_id
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"update Address_book set name = ?, user_id = ?, photo = ?, created_time = ?, device_id = ? where user_id ='%@'",user_id];
            
//
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"name"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                    
//                    if (sqlite3_bind_text(statement, 1, [row1 UTF8String], -1, NULL) != SQLITE_OK)
//                       NSLog(@"bind 1 failed: %s", sqlite3_errmsg(_database));

                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"user_id"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"photo"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    NSData * data =[dicInfo valueForKey:@"photo"];
                    sqlite3_bind_blob(statement, 3, [data bytes], [data length], NULL);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row4 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_time"]];
                if (row4 && [row4 length] > 0) {
                    sqlite3_bind_text(statement, 4,[row4 UTF8String] , -1, SQLITE_TRANSIENT);
                    NSLog(@"%@",row4);
                }
                else
                {
                    sqlite3_bind_text(statement, 4, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                NSString *row5 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"device_id"]];
                if (row5 && [row5 length] > 0) {
                    sqlite3_bind_text(statement, 5,[row5 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 5, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}

-(BOOL)updateMessage:(NSDictionary *)dictInfo with:(NSString *)message
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            sqlQuery=[NSString stringWithFormat:@"update Canned_message set Message = ?, is_emergency = ?, created_time = ? where Message ='%@'",message];
            
            //
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"Message"]];
                if (row1 && [row1 length] > 0)
                {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                    
                    //                    if (sqlite3_bind_text(statement, 1, [row1 UTF8String], -1, NULL) != SQLITE_OK)
                    //                       NSLog(@"bind 1 failed: %s", sqlite3_errmsg(_database));
                    
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"is_emergency"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_time"]];
                if (row3 && [row3 length] > 0)
                {
                    
                    NSData * data =[dicInfo valueForKey:@"photo"];
                    sqlite3_bind_blob(statement, 3, [data bytes], [data length], NULL);
                }
                
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}


//-(void)updateImages
//{
////    UIImage *uiimg = img.image;
////    NSData *data = UIImagePNGRepresentation(uiimg);
//    
//    NSString* statemt;
//    
//    statemt = @"BEGIN EXCLUSIVE TRANSACTION";
//    
//    const char *sql = "update APPUSERS set name = ?, u_name = ?, contact_no = ?, address = ?, dob = ?, pswrd = ?, confirm_pswrd = ?, img = ? where u_name =?";
//    
////    NSString * nameStr =[];
//    
//    if (sqlite3_prepare_v2(_database, sql, -1, [statemt UTF8String], NULL) != SQLITE_OK)
//        NSLog(@"prepare failed: %s", sqlite3_errmsg(_database));
//    
//    if (sqlite3_bind_text(update_statement, 1, [name.text UTF8String], -1, NULL) != SQLITE_OK)
//        NSLog(@"bind 1 failed: %s", sqlite3_errmsg(database));
//    
//    if (sqlite3_bind_text(update_statement, 2, [uname.text UTF8String], -1, NULL) != SQLITE_OK)
//        NSLog(@"bind 2 failed: %s", sqlite3_errmsg(database));
//    
//    if (sqlite3_bind_text(update_statement, 3, [pnoneno.text UTF8String], -1, NULL) != SQLITE_OK)
//        NSLog(@"bind 3 failed: %s", sqlite3_errmsg(database));
//    
//    if (sqlite3_bind_text(update_statement, 4, [address.text UTF8String], -1, NULL) != SQLITE_OK)
//        NSLog(@"bind 4 failed: %s", sqlite3_errmsg(database));
//    
//    if (sqlite3_bind_text(update_statement, 5, [dob.text UTF8String], -1, NULL) != SQLITE_OK)
//        NSLog(@"bind 5 failed: %s", sqlite3_errmsg(database));
//    
//    if (sqlite3_bind_text(update_statement, 6, [password.text UTF8String], -1, NULL) != SQLITE_OK)
//        NSLog(@"bind 6 failed: %s", sqlite3_errmsg(database));
//    
//    if (sqlite3_bind_text(update_statement, 7, [confirmpassword.text UTF8String], -1, NULL) != SQLITE_OK)
//        NSLog(@"bind 7 failed: %s", sqlite3_errmsg(database));
//    
//    // note, use blob here
//    
//    if (sqlite3_bind_blob(update_statement, 8, [data bytes], [data length], SQLITE_TRANSIENT) != SQLITE_OK)
//        NSLog(@"bind 8 failed: %s", sqlite3_errmsg(database));
//    
//    if (sqlite3_bind_text(update_statement, 9, [tempstore UTF8String], -1, NULL) != SQLITE_OK)
//        NSLog(@"bind 9 failed: %s", sqlite3_errmsg(database));
//    
//    if (sqlite3_step(update_statement) == SQLITE_DONE)
//    {
//        NSLog(@"success");
//    }
//    else
//    {
//        NSLog(@"failed: %s", sqlite3_errmsg(database));
//    }
//    
//    sqlite3_finalize(update_statement);
//}


-(BOOL)insertCannedMessageDetail:(NSDictionary *)dictInfo;
{
    {
        
        @try
        {
            
            // insert all other data
            sqlite3_stmt *statement=nil;
            sqlite3_stmt *init_statement =nil;
            NSString  *sqlQuery=nil;
            
            NSString* statemt;
            
            statemt = @"BEGIN EXCLUSIVE TRANSACTION";
            
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &init_statement, NULL) != SQLITE_OK)
            {
                return NO;
            }
            if (sqlite3_step(init_statement) != SQLITE_DONE)
            {
                sqlite3_finalize(init_statement);
                return NO;
            }
            
            
            
            sqlQuery=[NSString stringWithFormat:@"insert into 'Canned_message'('Message','is_emergency','created_time') values(?,?,?)"];
            
            if(sqlite3_prepare_v2(_database, [sqlQuery  UTF8String], -1, &statement, NULL)!=SQLITE_OK)
            {
                NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(_database));
            }
            
            NSString *emptyString = @"";
            
            NSMutableArray * dataArray = [[NSMutableArray alloc]init];
            [dataArray addObject:dictInfo];
            for (NSDictionary *dicInfo in dataArray)
            {
                
                //=================Dictionary Data inserting===============
                
                NSString *row1 = [NSString stringWithFormat:@"%@", [dicInfo valueForKey:@"Message"]];
                if (row1 && [row1 length] > 0) {
                    sqlite3_bind_text(statement, 1,[row1 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 1, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row2 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"is_emergency"]];
                if (row2 && [row2 length] > 0) {
                    sqlite3_bind_text(statement, 2,[row2 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 2, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                NSString *row3 = [NSString stringWithFormat:@"%@",[dicInfo valueForKey:@"created_time"]];
                if (row3 && [row3 length] > 0) {
                    sqlite3_bind_text(statement, 3,[row3 UTF8String] , -1, SQLITE_TRANSIENT);
                }
                else
                {
                    sqlite3_bind_text(statement, 3, [emptyString UTF8String], -1, SQLITE_TRANSIENT);
                }
                
                
                while(YES){
                    NSInteger result = sqlite3_step(statement);
                    if(result == SQLITE_DONE){
                        break;
                    }
                    else if(result != SQLITE_BUSY)
                    {
                        printf("db error: %s\n", sqlite3_errmsg(_database));
                        break;
                    }
                }
                sqlite3_reset(statement);
                
            }
            
            statemt = @"COMMIT TRANSACTION";
            sqlite3_stmt *commitStatement;
            if (sqlite3_prepare_v2(_database, [statemt UTF8String], -1, &commitStatement, NULL) != SQLITE_OK) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            if (sqlite3_step(commitStatement) != SQLITE_DONE) {
                printf("db error: %s\n", sqlite3_errmsg(_database));
                return NO;
            }
            
            sqlite3_finalize(statement);
            sqlite3_finalize(commitStatement);
        }
        @catch (NSException *e)
        {
            //NSLog(@":::: Exception : %@",e);
        }
        return NO;
    }
    
    
}
-(int)executeSw:(NSString*)sqlStatement
{
    sqlite3_stmt *statement = nil;
    status = FALSE;
    //NSLog(@"%@",sqlStatement);
    const char *sql = (const char*)[sqlStatement UTF8String];
    
    
    if(sqlite3_prepare_v2(_database, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while preparing  statement. '%s'", sqlite3_errmsg(_database));
        status = FALSE;
    } else {
        status = TRUE;
    }
    if (sqlite3_step(statement)!=SQLITE_DONE) {
        NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(_database));
        status = FALSE;
    } else {
        status = TRUE;
    }
    
    sqlite3_finalize(statement);
    int  returnValue = sqlite3_last_insert_rowid(_database);
    
    return returnValue;
}


@end
