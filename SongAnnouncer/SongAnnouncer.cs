
using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SongAnnouncer
{
    //SongAnnouncer Plugin. Announces Songs Using the Festival text to speech software.
    //A reference is added to the ToastifyApi.dll(PluginBase)
    //The plugin class below implements the PluginBase interface

    
    //Toastify.xml
    //<Plugins>
    //  <PluginDetails>
    //    <FileName>SongAnnouncer.dll</FileName>                            Plugin filename
    //    <TypeName>SongAnnouncer.SongAnnouncer</TypeName>                   Plugin type name (Namespace + "." + ClassName)
    //    <SettingsC:\ToastifyLog.txt</Settings>                            Plugin settings data
    //  </PluginDetails>
    //</Plugins>

    public class SongAnnouncer : Toastify.Plugin.PluginBase
    {
        // The set of words and symbols which will be replaced. {"search","replace"}
        private static Dictionary<string, string> replaceStrings = new Dictionary<string, string>
        {
            {"[",""}, {"]", ""}, {"Single Version", ""}, {"&", " and "}, {";", " ; "}, {"|", " ; "}, {"Original Radio Edit", ""}, {"Radio Edit", ""}, {" / ", " ; "}
        };
        public void TrackChanged(string artist, string title)
        {
            ExecuteCommand("echo (voice_cmu_us_slt_arctic_hts) (SayText \"" + string.Format("{0}. ; , : {1}", ReplaceWords(artist.Replace(title, "")), ReplaceWords(title.Replace(artist, ""))) + "\") | SongAnnouncer\\festival.exe --pipe --libdir SongAnnouncer/lib/");
            
        }
        /*
         * Announces the new song using Festival
         */
        public void ExecuteCommand(string Command)
        {
            System.Diagnostics.Process process = new System.Diagnostics.Process();
            System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo();
            startInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
            startInfo.FileName = "cmd.exe";
            startInfo.Arguments = "/C "+ Command;
            process.StartInfo = startInfo;
            process.Start();
        }
        /*
         * Replaces words and symbols to improve the quality of the speech
         */
        public string ReplaceWords(string words)
        {
            string result = words;
            foreach(System.Collections.Generic.KeyValuePair<string,string> replace in replaceStrings) {
                result = result.Replace(replace.Key, replace.Value);
            }
            return result;
        }
        public void Dispose() { }
        public void Init(string settings) { }
        public void Started() { }
        public void Closing() { }
    }
}
