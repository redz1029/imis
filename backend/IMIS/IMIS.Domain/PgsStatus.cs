using System.ComponentModel;

namespace IMIS.Domain
{
    public enum PgsStatus 
    {
        [Description("Not Started")]
        notStarted,
         
        [Description("On Going")]
        onGoing,
   
        [Description("Completed")]
        completed,       
    }
}
