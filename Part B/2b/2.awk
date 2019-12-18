BEGIN{
    telnetPkt=0;
    ftpPkt=0;
    telnetSize=0;
    ftpSize=0;
    totalTelnet=0;
    totalFTP=0;
}
{
    event = $1
    pktType = $5
    fromnode = $9
    tonode = $10
    pktsize = $6
    if(fromnode=="1.0" && tonode=="3.1" && pktType=="tcp" && event=="r")
    {
        ftpPkt++;
        ftpSize=pktsize;
    }
    if(fromnode=="0.0" && tonode=="3.0" && pktType=="tcp" && event=="r")
    {
        telnetPkt++;
        telnetSize=pktsize;
    }
}
END{
    totalTelnet=telnetPkt*telnetSize*8;
    totalFTP=ftpPkt*ftpSize*8;
    # comment out line 31 and leave line 30 for FTP reading, and vice-versa
    #printf("\t%d\n",totalFTP/24);
    printf("\t%d\n", totalTelnet/24);
}