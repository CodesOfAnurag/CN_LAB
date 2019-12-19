BEGIN{
    udprec=0;
    udplost=0;
    tcprec=0;
    tcplost=0;
}
{
    pktType=$5
    event=$1
    if (event == "r")
    {
        if (pktType=="cbr")
            udprec++;
        else if (pktType=="tcp")
            tcprec++;
    }
    else if (event == "d")
    {
        if (pktType=="cbr")
            udplost++;
        else if (pktType=="tcp")
            tcplost++;
    }
}
END{
    printf("TCP Rec: %d\tLost:%d\n", tcprec, tcplost);
    printf("UDP Rec: %d\tLost:%d\n", udprec, udplost);
}