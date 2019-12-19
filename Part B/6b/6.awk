BEGIN{
   FTPPackets=0;
   FTPSize=0;
   cbrSize=0;
   cbrPackets = 0;
}
{
    event=$1;
    pkttype= $5;
    pktsize=$6;
    if(event == "r" && pkttype == "tcp")
    {
        FTPPackets++;
        FTPSize = pktsize;
    }
    else if(event == "r" && pkttype == "cbr")
    {
        cbrPackets++;
        cbrSize = pktsize;
    }
}
END{
    totalFTP=FTPPackets*FTPSize;    
    totalCBR=cbrPackets*cbrSize;
    #comment appropriately for FTP And CBR Graph Values
    printf("FTP : %d\n", totalFTP/123.0);    # Bytes per second 
    printf("CBR : %d\n", totalCBR/124.4);    # Bytes per second 
}