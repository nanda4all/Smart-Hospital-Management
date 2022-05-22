using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LastHMS2.Class_Attriputes
{
    // for security give each hospital a different Key ...
    public static class PasswordSecurity
    {
        private static string PreKey = "preViKings";
        private static string AfterKey = "afterViKings";

        public static string Encrypt(string password)
        {
            if (string.IsNullOrEmpty(password))
                return "";
            //PreKey += password;
            //password = PreKey + AfterKey; 
            password = string.Concat(PreKey, password, AfterKey);
            var passwordBytes = Encoding.UTF8.GetBytes(password);
            return Convert.ToBase64String(passwordBytes);
        }
        public static string Decrypt(string Base64EncodeData)
        {
            if (string.IsNullOrEmpty(Base64EncodeData))
                return "";
            var base64EncodeBytes = Convert.FromBase64String(Base64EncodeData);
            var Result = Encoding.UTF8.GetString(base64EncodeBytes); // prekey+password+afterkey
            Result = Result.Substring(PreKey.Length, Result.Length - (PreKey.Length + AfterKey.Length));

            return Result;

        }
    }
}
