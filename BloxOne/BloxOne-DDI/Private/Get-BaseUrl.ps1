Function Get-BaseUrl {
    <#  
    .Synopsis  
        Constructs the BaseURL for all BloxOne API calls
          
    .Description  
        Creates the base URL for all application specific API calls
          
    .Notes  
        Author      : Don Smith <dsmith@infoblox.com>
        Source      : 
        Version     : 1.0 - 2020-07-29 - Initial release  
          
        #Requires -Version 5.0  
          
    .Inputs  
        System.String  
          
    .Outputs  
        System.Collections.Hashtable  
          
    .Parameter FilePath  
        Specifies the path to the input file.  
          
    .Example  
        $FileContent = Get-IniContent "C:\myinifile.ini"  
        -----------  
        Description  
        Saves the content of the c:\myinifile.ini in a hashtable called $FileContent  
      
    .Example  
        $inifilepath | $FileContent = Get-IniContent  
        -----------  
        Description  
        Gets the content of the ini file passed through the pipe into a hashtable called $FileContent  
      
    .Example  
        C:\PS>$FileContent = Get-IniContent "c:\settings.ini"  
        C:\PS>$FileContent["Section"]["Key"]  
        -----------  
        Description  
        Returns the key "Key" of the section "Section" from the C:\settings.ini file  
          
    .Link  
        Out-IniFile  
    #>  

}