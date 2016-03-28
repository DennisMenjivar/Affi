//
//  SiteClass.swift
//  Affinion
//
//  Created by Dennis Menjivar on 3/22/16.
//  Copyright © 2016 Dennis Menjivar. All rights reserved.
//

import Foundation

public class SiteClass{
    var SiteID:Int
    var SiteName:String
    var VendorID:Int
    init(pSiteID:Int, pSiteName:String, pVendorID:Int){
        SiteID = pSiteID
        SiteName = pSiteName
        VendorID = pVendorID
    }
}