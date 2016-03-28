//
//  ClassTransmistslogs.swift
//  Affinion
//
//  Created by Dennis Menjivar on 3/22/16.
//  Copyright © 2016 Dennis Menjivar. All rights reserved.
//

public class ClassTransmistslogs{
    var Date:NSDate
    var SiteID:Int
    var PGPFound:Int
    var PGPStillTransmiting:Int
    var PGPIntegrity:Int
    var ZipIntegrity:Int
    var CSVFound:Int
    var CSVEmpty:Int
    var TotalRecords:Int
    var RecordsLoaded:Int
    var Comments:String
    var LoadDate:NSDate
    var FileReceived:String
    
    init(pDate:NSDate,pSiteID:Int,pPGPFound:Int,pPGPStillTransmiting:Int,pPGPIntegrity:Int, pZipIntegrity:Int, pCSVFound:Int,pCSVEmpty:Int,pTotalRecords:Int, pRecordsLoaded:Int,pComments:String, pLoadDate:NSDate, pFileReceived:String){
        Date = pDate
        SiteID = pSiteID
        PGPFound = pPGPFound
        PGPStillTransmiting = pPGPStillTransmiting
        PGPIntegrity = pPGPIntegrity
        ZipIntegrity = pZipIntegrity
        CSVFound = pCSVFound
        CSVEmpty = pCSVEmpty
        TotalRecords = pTotalRecords
        RecordsLoaded = pRecordsLoaded
        Comments = pComments
        LoadDate = pLoadDate
        FileReceived = pFileReceived
    }
}
