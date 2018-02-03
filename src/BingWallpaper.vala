/*
 * Copyright (C) Francisco Javier Rodríguez Isabel, 2018
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

    public class BingWallpaperPlugin : Switchboard.Plug {
        // Necessary global variables
        public static BingWallpaperPlugin plugin;
        Gtk.Paned paned;

        // Main construct
        public BingWallpaperPlugin () {
            // init plugin stuff
            Object (category: Category.PERSONAL, 
                    code_name: "bing-wallpaper", 
                    display_name: _("Bing Wallpaper"), 
                    description: _("A daily wallpaper from Bing"), 
                    icon: "bing-wallpaper-icon");
            plugin = this;
        }

        /**
         * Returns the main Gtk.Widget that contains all of our UI for Switchboard.
         */
        public override Gtk.Widget get_widget () {
            if (paned == null) {
                paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
                var categories = new Categories ();
                paned.pack1 (categories, false, false);
                var stack = new Gtk.Stack ();
                paned.add2 (stack);
                categories.set_stack (stack);

                paned.show_all ();
            }
            return paned;
        }

        public override void shown () { }
        public override void hidden () { }
        public override void search_callback (string location) { }

        public override async Gee.TreeMap<string, string> search (string search) {
            return new Gee.TreeMap<string, string> (null, null);
        }

    }


 }
 public Switchboard.Plug get_plug (Module module) {
    info ("Activating bing wallpaper plug");
    var plug = new BingWallpaper.BingWallpaperPlugin ();
    return plug;
}