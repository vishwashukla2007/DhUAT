public class BusinessDays{
    
    //this method add noOfDays from startdate excluding weekends and holidays.
    public static Datetime addDays(Datetime startDate, Integer noOfDays) 
    {
        
        Datetime endDate=startDate+noOfDays;
        List<Holiday> holidays=[Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h];

        while (startDate <= endDate) 
        {
            if (startDate.format('E') == 'Sat' || startDate.format('E') == 'Sun') 
            {
                endDate=endDate+1;
            }
            else
            {
                for(Holiday hDay:holidays)
                {
                    if (hday.ActivityDate.isSameDay(startDate.Date())) {
                        endDate=endDate+1;
                    }
                }
            }
            startDate = startDate.addDays(1);
        }
        return endDate;
    }
}