//
//  TransmistsLogsTableViewController.swift
//  Affinion
//
//  Created by Dennis Menjivar on 3/22/16.
//  Copyright © 2016 Dennis Menjivar. All rights reserved.
//

import UIKit

class TransmistsLogsTableViewController: UITableViewController, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    var TransmistsArray = [ClassTransmistslogs]()
    var SitesArray = [SiteClass]()
    var VendorArray = [VendorClass]()
    var selectedIndexPath : NSIndexPath?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        }else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<NSIndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath{
            return 290
        } else {
            return 70
        }
    }
    
    //Variable para poder llamar la opcion de refresh
    var RefreshControlClassified = UIRefreshControl()
    
    override func viewDidLoad() {
        StartActivityIndicator()
        super.viewDidLoad()
        setNavigationTitle("Transmit Log")
        
        LoadDataTransmitLog()
        
        navigationController?.delegate = self
        FunctionPullToRefresht()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func FunctionPullToRefresht(){
        //CREAMOS LA FUNCION PARA PODER ACTUALIZAR
        self.refreshControl = self.RefreshControlClassified
        self.RefreshControlClassified.tintColor = UIColor.grayColor()
        self.RefreshControlClassified.addTarget(self, action: #selector(TransmistsLogsTableViewController.LoadDataTransmitLog), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func LoadDataSite(){
        LoadDataVendor()
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client! //boiler-plate for azure
        
        let site = client.tableWithName("t_sites").query()
        site.includeTotalCount = true
        site.fetchLimit = 1000
        
        site.readWithCompletion {(resultlog:MSQueryResult!, error) in
            for log in resultlog.items {
                print("Sites:  ",resultlog.items.count)
                self.SitesArray.append(SiteClass(pSiteID: log.valueForKey("SiteID") as! Int, pSiteName: log.valueForKey("Name") as! String, pVendorID: log.valueForKey("VendorID") as! Int))
            }
        }
    }
    
    //Asiganr el titulo y poner color blamco
    var titulo = UILabel(frame: CGRectMake(0, 0, 10, 20))
    func setNavigationTitle(texto : String){
        //titulo.textColor = UIColor.whiteColor()
        titulo.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        titulo.backgroundColor = UIColor.clearColor()
        titulo.textAlignment = NSTextAlignment.Center
        titulo.text = texto
        titulo.font = UIFont(name: "Verdana", size: 17)
        self.navigationItem.titleView = titulo
    }
    
    func LoadDataVendor(){
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client! //boiler-plate for azure
        
        let Vendor = client.tableWithName("t_Vendors").query()
        Vendor.includeTotalCount = true
        Vendor.fetchLimit = 1000
        
        Vendor.readWithCompletion{(resultVendor:MSQueryResult!, error) in
            for vendor in resultVendor.items {
                self.VendorArray.append(VendorClass(pVendorID: vendor.valueForKey("VendorID") as! Int, pName: vendor.valueForKey("Name") as! String))
            }
            print("Vendor ", self.VendorArray.count)
        }
    }
    
    func getPercent(Number1:Double, Number2:Double)-> Double{
        if(Number1 == 0 || Number2 == 0){
            return 0
        }
        
        let Result:Double = (Number1 / Number2) * 100
        return Result
    }
    
    func getFormatCurrentDate(Date:NSDate) -> String{
        let calendar = NSCalendar.currentCalendar()
        let Month = calendar.component(.Month, fromDate: Date)
        let Day = calendar.component(.Day, fromDate: Date)
        let Year = calendar.component(.Year, fromDate: Date)
        
        let CurrentDate:String = String(Year) + "-" + String(Month) + "-" + String(Day)
        
        return CurrentDate
    }
    
    //let CurrentDate:String = "Date == '" + String(Year) + "-" + String(Month) + "-" + String(Day) + "'"
    
    @IBAction func LoadDataTransmitLog() {
        TransmistsArray.removeAll(keepCapacity: false)
        VendorArray.removeAll(keepCapacity: false)
        SitesArray.removeAll(keepCapacity: false)
        
        LoadDataSite()
        
        //--var events:[String] = [] //this is to be updated
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let client = delegate.client! //boiler-plate for azure
        
        let transmitlog = client.tableWithName("t_transmitslogs").query()
        transmitlog.includeTotalCount = true
        transmitlog.fetchLimit = 1000
        transmitlog.orderByDescending("Date")
        
        let QueryDate:String = "LoadDate >= '" + getFormatCurrentDate(NSDate()) + "'"
        
        print("Query Date: " + QueryDate)
        
        let predicate = NSPredicate(format: QueryDate)
        transmitlog.predicate = predicate
        
        transmitlog.readWithCompletion {
            //something about this query block might be preventing successful initialization to the events array
            (result:MSQueryResult!, error) in
            //usually error-checking here
            for item in result.items {
                //print("Load Date: ", item.valueForKey("LoadDate"))
                //print(result.items.count)
                //--events.append(item.valueForKey("ID") as! String)
                
                //self.Array.append(ClassFile(UserName: item.valueForKey("username") as! String, Price: item.valueForKey("price") as! Int))
                //let formatter = NSDateFormatter()
                //formatter.dateFormat = "yyyy/MM/dd HH:mm"
                //let someDateTime = formatter.dateFromString("2015/10/26 18:31")
                
                self.TransmistsArray.append(ClassTransmistslogs(pDate: item.valueForKey("Date") as! NSDate, pSiteID: item.valueForKey("SiteID") as! Int, pPGPFound: item.valueForKey("PGPFound") as! Int, pPGPStillTransmiting: item.valueForKey("PGPStillTransmiting") as! Int, pPGPIntegrity: item.valueForKey("PGPIntegrity") as! Int, pZipIntegrity: item.valueForKey("ZIPIntegrity") as! Int, pCSVFound: item.valueForKey("CSVFound") as! Int, pCSVEmpty: item.valueForKey("CSVEmpty") as! Int, pTotalRecords: item.valueForKey("TotalRecords") as! Int, pRecordsLoaded: item.valueForKey("RecordsLoaded") as! Int, pComments: item.valueForKey("Comments") as! String, pLoadDate: item.valueForKey("LoadDate") as! NSDate, pFileReceived: item.valueForKey("FileReceived") as! String))
            }
            self.indicator.stopAnimating()
            self.RefreshControlClassified.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return TransmistsArray.count
    }
    
    func getPercentColor(TotalRecord:Double, RecordsLoaded:Double)-> UIColor{
        if(TotalRecord == RecordsLoaded){
            return UIColor.greenColor().colorWithAlphaComponent(0.1)
        }else if(RecordsLoaded > 1){
            return UIColor.yellowColor().colorWithAlphaComponent(0.1)
        }else if(RecordsLoaded == 0){
            return UIColor.redColor().colorWithAlphaComponent(0.1)
        }
        return UIColor.whiteColor()
    }
    
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    func StartActivityIndicator(){
        indicator.center = view.center
        indicator.frame = CGRectMake((self.view.frame.width / 2) - indicator.frame.width / 2, (self.view.frame.height / 3) - indicator.frame.height / 3, indicator.frame.height, indicator.frame.width / 2)
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.Gray
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func getYESorNO(Val:Int)-> String{
        if(Val == 1){
            return "YES"
        }else{
            return "NO"
        }
    }
    
    func getYESorNOAdverse(Val:Int)-> String{
        if(Val == 1){
            return "NO"
        }else{
            return "YES"
        }
    }
    
    func getFormatDate(datevalue:NSDate) -> String{
        let mydateFormatter = NSDateFormatter()
        mydateFormatter.dateFormat = "MMMM-dd-YYYY"
        mydateFormatter.timeZone = NSTimeZone(name: "UTC")
        let CurrentDate:String = mydateFormatter.stringFromDate(datevalue)
        return CurrentDate
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:LogsTableViewCell = tableView.dequeueReusableCellWithIdentifier("CellLogs", forIndexPath: indexPath) as! LogsTableViewCell
        let Log:ClassTransmistslogs = self.TransmistsArray[indexPath.row] as ClassTransmistslogs
        cell.Date.text = getFormatDate(Log.LoadDate)
        cell.Date.textColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        let SiteID:Int = Log.SiteID
        cell.VendorAndSite.backgroundColor = UIColor(red: 10.0 / 255.0, green: 90.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0).colorWithAlphaComponent(0.2)
        cell.VendorAndSite.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        cell.VendorAndSite.text = "Vendor / Site:   " + getVendorName(getVendorID(SiteID)) + " - " + getSiteName(SiteID)
        cell.FileReceived.text = "File Received: " + Log.FileReceived
        cell.FileReceived.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        let TotalRecord:Double = Double(Log.TotalRecords)
        let RecordsLoaded:Double = Double(Log.RecordsLoaded)
        cell.Percent.text = "  " + String(getPercent(RecordsLoaded, Number2: TotalRecord)) + "%  "
        cell.Percent.backgroundColor = getPercentColor(TotalRecord, RecordsLoaded: RecordsLoaded)
        cell.Percent.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        cell.PGPFound.text = "PGP Found: " + getYESorNO(Log.PGPFound)
        cell.PGPFound.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        cell.Comment.text = "Comment: " + Log.Comments
        cell.Comment.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        //cell.ProgressView.progress = Float(getPercent(RecordsLoaded, Number2: TotalRecord) / 100)
        
        cell.PGPIntegrity.text = "PGP Integrity OK: " + getYESorNO(Log.PGPIntegrity)
        cell.PGPIntegrity.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        cell.ZIPIntegrity.text =  "ZIP Integrity OK: " + getYESorNO(Log.ZipIntegrity)
        cell.ZIPIntegrity.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        cell.CSVTransmitted.text = "CSV Transmitted: " + getYESorNO(Log.CSVFound)
        cell.CSVTransmitted.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        cell.CsvContainsData.text = "CSV Contains Data: " + getYESorNOAdverse(Log.CSVEmpty)
        cell.CsvContainsData.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        cell.RecordsReceived.text = "Records Received: " + String(Log.TotalRecords)
        cell.RecordsReceived.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        cell.RecordsLoaded.text = "Records Loaded: " + String(Log.RecordsLoaded)
        cell.RecordsLoaded.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        
        //cell.NonSalesLoaded.text = "Comments: " + Log.Comments
        //---cell.NonSalesLoaded.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        //let SiteID:Int = Log.SiteID
        //cell.SiteID.text = String(SiteID)
        //cell.SiteName.text = getSiteName(SiteID)
        //cell.VendorName.text = getVendorName(getVendorID(SiteID))
        return cell
    }
    
    func getSiteName(SiteId:Int)-> String{
        var Count:Int = 0
        let Name:String = ""
        while(Count < SitesArray.count){
            //--print("SiteId: ->",SitesArray[Count].SiteID)
            if(SiteId == SitesArray[Count].SiteID){
                //print("SiteName: ",SitesArray[Count].SiteName)
                return SitesArray[Count].SiteName
            }
            Count += 1
        }
        return Name
    }
    
    func getVendorID(SiteID:Int)->Int {
        var Count:Int = 0
        while(Count < SitesArray.count){
            if(SiteID == SitesArray[Count].SiteID){
                return SitesArray[Count].VendorID
            }
            Count += 1
        }
        return 0
    }
    
    func getVendorName(VendorID:Int)->String{
        var Count:Int = 0
        while(Count < VendorArray.count){
            if(VendorID == VendorArray[Count].VendorID){
                return VendorArray[Count].Name
            }
            Count += 1
        }
        return ""
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
