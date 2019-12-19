{
    pktType=$5
    event=$1
    if (pktType=="cbr")
    {
        if (event=="r")
            UDPtimePacketCountRecieved[int($2)] = ++UDPtimePacketCount[int($2)];
    }
    else if (pktType=="tcp")
    {
        if (event=="r")
            TCPtimePacketCountRecieved[int($2)] = ++TCPtimePacketCount[int($2)];
    }
}
END{
    n=asort(UDPtimePacketCountRecieved);
    for(i=1; i<=n; i++)
        print(i "\t" UDPtimePacketCountRecieved[i]) >> "UDP.xg"
    n=asort(TCPtimePacketCountRecieved);
    for(i=1; i<=n; i++)
        print(i "\t" TCPtimePacketCountRecieved[i]) >> "TCP.xg"
}