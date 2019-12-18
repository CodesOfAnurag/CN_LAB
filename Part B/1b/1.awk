BEGIN{
    sent=0;
    rec=0;
    lost=0;
}
{
    packetType = $5
    event = $1
    if (packetType == "cbr")
    {
        if (event == "+")
            sent++;
        else if (event == "r")
            rec++;
        else if (event == "d")
            lost++;
    }
}
END{
    #printf("\t%d\t%d\t%d\n", sent, rec, lost);
    printf("\t%d\n", lost);
}