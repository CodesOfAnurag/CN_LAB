BEGIN{
    count=0
}
{
    event=$1
    if (event=="d")
        count++;
}
END{
    printf("Packets Dropped: %d\n", count);
}