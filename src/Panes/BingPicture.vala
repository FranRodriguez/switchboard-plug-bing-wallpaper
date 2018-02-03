/*
 * Copyright (C) Elementary Tweaks Developers, 2016
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

namespace BingWallpaper {

    [DBus (name = "org.freedesktop.Accounts.User")]
    interface AccountsServiceUser : Object {
        public abstract void set_background_file (string filename) throws IOError;
    }


    public class Panes.BingPicture : Categories.Pane {

        public BingPicture () {
            base (_("Bing Picture"), "bing-wallpaper-icon");
        }

        construct {
            build_ui ();
        }

        private void build_ui () {
            var button_hello = new Gtk.Button.with_label ("Apply");
            button_hello.margin = 12;
            
            button_hello.clicked.connect (() => {
                string name = getImage(getImageUri());
                var builder = new StringBuilder ();
                builder.append ("/tmp/");
                builder.append(name);
                setImage(builder.str);
                //button_hello.sensitive = false;
            });
            grid.add(button_hello);
            grid.show_all();
        }

        static void setImage(string path) {
            try {
                //var destination = File.new_for_path(path);
                //destination.delete();

                var settings = new GLib.Settings ("org.gnome.desktop.background");
                settings.set_string("picture-uri", ("file://" + path));

                AccountsServiceUser accountsservice = null;
                string uid = "%d".printf ((int) Posix.getuid ());
                accountsservice = Bus.get_proxy_sync (BusType.SYSTEM, "org.freedesktop.Accounts", "/org/freedesktop/Accounts/User" + uid);
                accountsservice.set_background_file (path);

                

            }
            catch (Error e) {
                stderr.printf ("%s\n", e.message);
            }


        }

        static string getImage(string url) {
            var src = File.new_for_uri (url);
            // get name from file
            var address = url.split("/");
            var name = "";
            foreach(var attribute in address) {
                if(attribute.contains("jpg")) {
                    name = attribute;
                }
            }
            StringBuilder builder = new StringBuilder();
            builder.append("/tmp/");
            builder.append(name);

            var dst = File.new_for_path (builder.str);
            try {
                    src.copy(dst, FileCopyFlags.OVERWRITE, null, null);
                    FileUtils.chmod (name, 0777);
            } catch (Error e) {
                    stderr.printf ("%s\n", e.message);
            }
            return name;
            
        }

        static string getImageUri() {
            // Returned variable
            string uri = "";
            // Begin
            File file = File.new_for_uri("http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=ES-es");
            if(file.query_exists()) {
                try {
                    // Get the stream
                    DataInputStream stream = new DataInputStream(file.read());
                    string line = "";
                    string content = "";
                    // Read char
                    while ((line = stream.read_line(null))!=null) {
                        content+=line;
                    }
                    var splitted = content.split(",");
                    foreach (var attribute in splitted) {
                        var sub_attribute = attribute.split(":");
                        foreach(var tag in sub_attribute) {
                                if(tag.contains("jpg")) { 
                                    StringBuilder builder = new StringBuilder();
                                    builder.append(tag);
                                    builder.erase(tag.length-1,1);
                                    builder.erase(0,1);

                                    builder.prepend("http://www.bing.com");

                                uri = builder.str;
                                return uri;
                            }
                        }
                    }
                    uri = content;
                }
                catch (Error error) {
                    uri = error.message;
                    stdout.printf ("%s\n", error.message);
                }
            }
            else {
                uri="File not exist";
            }
            // Return result
            return uri;
        }
    }
}