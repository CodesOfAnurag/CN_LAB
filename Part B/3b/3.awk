BEGIN{
    tcpSent=0;
    tcpRec=0;
    tcpLost=0;
    udpSent=0;
    udpRec=0;
    udpLost=0;
}
{
    pktType=$5
    event=$1
    if (pktType=="tcp")
    {
        if (event=="+")
            tcpSent++;
        else if (event=="r")
            tcpRec++;
        else if (event=="d")
            tcpLost++;
    }
    if (pktType=="cbr")
    {
        if (event=="+")
            udpSent++;
        else if (event=="r")
            udpRec++;
        else if (event=="d")
            udpLost++;
    }
}
END{
    printf("Total Sent: %d\nTotal Lost: %d\n", tcpSent+udpSent, tcpLost+udpLost);
    printf("\tSent\tRec\tLost\n");
    printf("TCP:\t%d\t%d\t%d\n", tcpSent, tcpRec, tcpLost);
    printf("UDP:\t%d\t%d\t%d\n", udpSent, udpRec, udpLost);
}