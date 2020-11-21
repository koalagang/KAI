README

activities-config


Gnome Shell Extension Activities Configurator

This extension is covered by copyright and is provided under the terms
of the GNU General Public License version 2.

See the copyright statement in the file extension.js and the file
COPYING for details.

For normal use please install from the Gnome Shell Extension website:
https://extensions.gnome.org/extension/358/activities-configurator/

Additional information is available at:
https://nls1729.github.io


2012-11-30 Fixed missing corners.  Black opaque panel background displays corners.
           Added German Translations thanks for the efforts of Tobias Bannert.
           Added function to determine utf8 strings length in bytes.
           Created separate branches for Gnome Shell 3.4 and 3.6.

2012-12-02 Uploaded for review.

2012-12-09 Fixed bug in missing icon logic.
           Removed uneeded string length function.

2012-12-10 v12 and v13 active.

2012-12-14 Updated German Translations thanks to Jonatan Zeidler.
           No programmatic changes. Sources same as v12 GS3.4 and v13 GS3.6.
           Uploaded for review.

2013-01-14 Fixed conflicts with some extensions in GS3.6 when screen was locked.
           Fixed inconsistent custom colors in GS3.4 and GS3.6.
           Added pango formating in prefs tool when entering Activities Text,
           ie. <i>Activities</i> displays text in italics.
           Rounded corners are displayed in the color and transparency selected
           for the panel background.  Rounded corners can be hidden.
           The appearance of rounded corners is affected by screen width and
           height ratio, screen resolution, font size and font scaling, screen
           background image and screen background colors and your panel background
           color choice.  The rounded corners with an opaque black panel background
           work well with almost any background image or color.  Other colors and
           levels of transparency for the panel background may or may not work as
           well with your choice of background image or background color.
           Uploaded for review.

2013-04-29 Updated for Gnome Shell 3.8.

           Tested on openSuse 12.3, Fedora 19 Alpha and Arch Linux.

           Thanks to Craig Rob, Sven Gjukison and Simon Perry for 
           their valuable testing, patience and comments.  

           Uploaded for review.
  
           The Hot Corner is removed from the Activities Button in Gnome Shell 3.8.
           The functions performed by Hot Corner Sensitivity and Disable Hot Corner
           preferences are changed to continue providing user control of the Hot 
           Corner as described in the following.

           The Hot Corner Sensitivity preference is renamed Hot Corner Threshold.

           The Barrier Pressure System is introduced in Gnome Shell 3.8 to reduce false
           triggers of the Overview and the Message Tray by wayward pointer movements.
           If Extended Barriers are provided by the installed version of the X server
           the Barrier Pressure System is supported.  If supported the Hot Corner 
           Threshold is a pixel value which is used by the Barrier Pressure System to
           calculate the pressure of the pointer pressing against the barrier.  If the
           pressure exceeds the Hot Corner Threshold the Overview is toggled.  With
           Barrier Pressure System support if the Disable Hot Corner preference is ON
           the Hot Corner Threshold is set to a very high value effectively disabling
           the Hot Corner.  The default threshold pressure is 100 pixels.

           If Extended Barriers are not provided the Barrier Pressure System is not 
           functional.  A fallback is implemented in the extension as follows.  The Hot
           Corner Threshold is a value in milliseconds which is used by a timer to delay
           the triggering of the Overview by the Hot Corner.  When the Disable Hot Corner
           preference is ON the Hot Corner is disabled by ignoring Overview toggles
           initiated by the Hot Corner.  The default threshold delay is 250 milliseconds.

2013-05-03 Bug Fix "Remove Activities Button" ON not effective after shell was restarted.

           Changed approach to sync psuedo style of button with hot corner when switching
           to and from Overview to use native shell code instead of extension hack.

2013-05-08 Changed repaint logic to eliminate double paints except when preference settings
           require it.

2013-09-28 Uploaded for review supports GS3.8 and GS3.10

2013-10-12 Created new branch for GS3.8 and GS3.10

2013-11-23 Added logic to handle hot corners on multiple displays. 
           User reported bug hot corner corner was not disabled on 
           secondary display.
 
           Tested on Fedora Beta F20 GS 3.10 with Pressure Barrier, 
           Arch GS 3.10 with Pressure Barrier, openSuse 12.3 GS 3.8 
           without Pressure Barrier.

2013-11-28 Thanks to Florian Rau for testing Debian Jessie with GS 3.8.
           Uploaded for review.

2014-01-17 Corrected my error that resulted in missing German translations.

2014-04-10 Uploaded new version added 3.12 to metadata.json.

2014-05-02 Added user kubecz3k's suggested feature Window Maximized Effect
           for GS 3.8 and above. kubecz3k saw this effect on a youtube
           video of Elementary Isis: [ http://youtu.be/mzSPGkOyzW8?t=1m30s ].

           For this extension the feature is implemented as follows:

           When a window is maximized on the primary display the panel
           background is affected based on the preference settings.

           1.  No effect on Panel.
           2.  Panel background is set to opaque (transparency removed).
           3.  Panel background is set to opaque and black.

           When the window is unmaximized the panel background returns to the
           original state based on the extension's current preferences.

           Tested on GS 3.8 Fedora 19, GS 3.10 Fedora 20, f20-gnome-3-12 COPR
           and Arch updated today GS 3.12.

2014-05-03 Uploaded for review for GS 3.8, GS 3.10, GS 3.12.

2014-06-08 Corrected bug - hidden window causing false  Window Maximized Effect
           Corrected bug - transparency set incorrectly mainly in virtural machine
           Uploaded for review.

2014-08-27 Corrected bug - in 3.12 function setTransient was removed from Source class.
           Changed to use setTransient in Notification class.
           Uploaded for review.

2014-10-05 Updated for Gnome Shell 3.14  -  Uploaded for review.

           Changed secondary click response on Activities Text/Icon to execute
           gnome-shell-extension-prefs without the extension as an argument due
           to changes in GS 3.14 to the gnome-shell-extension-prefs tool.  The
           behavior is unchanged for earlier versions.

           Added display of extension version number in prefs widget.
           Added horizontal width request to prefs widget scrolled window.

           Changed readme window displayed by prefs to be modal with a parent.

2014-10-06 Passed review version 31 supports GS 3.8, 3.10, 3.12, 3.14.

2014-10-17 Created github repository:  https://github.com/nls1729/activities-config

2014-10-29 Set github url as metadata.json url to "https://nls1729.github.io" for ego and github repo
           ego version is 32 only change was to metadata.json

2014-11-04 Removed code to present prefs tool on first enable.  It is not needed.  The prefs tool
           is available with a right click of the activities icon or text, with the Tweak tool and
           from the ego website.  This also fixes a bug of the prefs tool being displayed when
           unlocking the screen.

2014-11-05 Version 33 passed review on ego.

2015-02-17 Version 34 version change only

2015-03-20 Version 35 updated metadata.json for GS 3.16

2015-06-20 Version 36
           jonnius provided German Translation Update and Full Localization Support.
           All instances of _N were removed which had prevented use of xgettext to
           create translation template files.

2015-06-23 Version 36 passed review on ego.

2015-08-28 Changes to Activities Configurator extension.

           Updated Activities Configurator to hopefully handle Touch Screen.
           I do not have a touch screen device.  Changes were made based on
           current code in panel.js.  

           Added option to hide Application Menu Button Icon. Suggested
           by francoism90.

           Changed layout of extension preferences.  Changed readme.js to
           follow layout change.

           Changed disabled Hot Corner behavior for DND to be the
           same as if Hot Corner is enabled. Dragging an item into
           the Hot Corner will toggle the Overview when the
           Hot Corner is disabled. Suggested by Jehan.

           Fixed bug in Window Maximized Effect which occurred when a
           window was in the maximized state and the extenssion preferences
           were changed from Opaque Background Color to Panel - No Effect.
           Transparency was not being applied after the change.

           Changed Window Maximized Effect to be work with GS 3.17.90 in
           preparation of GS 3.18.

           Cleaned up inconsistent coding style "if(" --> "if ("

2015-08-29 Uploaded version 37 to ego for review.

2015-08-20 Version 37 passed review on ego. Applies to GS 3.14 and later.

2015-09-25 Changed app menu icon hide icon code to handle conflict
           with StatusTitleBar@devpower.org extension.
           Tested on Fedora 23 Beta with GS 3.18.0.
           Uploaded for review.

2015-12-17 Moved local repo to valkyrie3

2015-12-30 Changed init and enable code to workaround a conflict with the
           Gno-Menu extension involving hot corners.
           Changed the display of preferences to handle the Vertex Theme
           representation of the Gtk.Switch widgit in a sane manner.
           Added display of text to show Pango formatting and enable changing
           text without complete replacement.
           Changed preferences layout to be more readable and consistent.

2015-12-31 Uploaded for review.

2016-01-03 Version 39 passed review GS 3.14 3.16 3.18

2016-02-23 Added configurable shadow box to the panel.
           The panel is a simple rectangle.  The top and sides of
           the panel cannot be shadowed.  Only the bottom is accessible.
           The shadow is effective only in the vertical direction.
           The color, transparency, vertical length, blur radius
           and spread radius can be adjusted with the preferences tool.
           Setting the vertical length to 0 will remove the shadow.
           The panel transparency affects the shadow transparency.
           A high value of panel transparency will cause the shadow
           to be transparent.

2016-02-28 Uploaded for review.

2016-02-29 Activities Configurator - Version 40 passed review GS 3.14 3.16 3.18

2016-03-15 Added logic to workaround another extension showing hidden rounded corners.

2016-03-17 Activities Configurator - uploaded for review

2016-03-18 Activities Configurator - Version 42 passed review GS 3.14 3.16 3.18

2016-04-07 Activities Configurator - GS 3.16 3.18 3.20

           Override Shell Theme Preference

           The following settings interact with User Themes and the Gnome Classic Mode:
           Set Panel Background, Panel Transparency, Panel Shadow Color, Transparency,
           Vertical Length, Blur Radius, Spread Radius and Window Maximized Effect.
           These options are designed to function with the default Gnome Mode and the
           default Shell Theme.  Available User Themes are common and are written
           in ways that do not behave in the same manner as the default Shell Theme.
           The Classic Mode theme is different from the default Shell Theme.  Depending
           on the user's tastes and the theme installed the extension's preferences
           can be used in a useful way.  In some cases some settings are not effective
           or are not useful.  The Override Shell Theme Preference allows the user to
           enable or disable the interactions of the settings that affect the installed
           theme.  The default for the setting is OFF, all listed panel options will
           not interact with an installed User Theme or when in the Gnome Classic Mode.
           The user can set it to ON allowing the listed settings to override or interact
           with the installed theme.  When operating in the default Gnome Mode with the
           default Shell Theme installed the switch is set to OFF and is not sensitive.
           When a theme change occurs from the default Shell Theme to a User Theme or
           the session is in the Gnome Classic Mode the switch is set sensitive in the
           OFF position.  If the user wishes to use any of the listed settings the
           switch can be set to ON.  The option will remain ON until the user sets it
           to OFF or the theme is changed or the mode changes.

2016-04-07 Activities Configurator - uploaded for review

2016 04-07 Activities Configurator - Version 44 passed review GS 3.16 3.18 3.20

2016-06-29 Activities Configurator - GS 3.16 3.18 3.20
           User requested option to display the Activities Overview after login.
           Added option "Show Overview after Login".

2016-06-29 Activities Configurator - uploaded for review

2016-07-01 Activities Configurator - Version 46 passed review GS 3.16 3.18 3.20

2016-07-20 Activities Configurator - Added user requested option to move Activities
           Icon Button to the right corner of the Panel.  The Hot Corner is not a part
           of the button and it remains in the left corner.  When the option to move
           to the right is selected the Conflict Detection option is not available.

2016-07-20 Activities Configurator - uploaded for review

2016-07-20 Activities Configurator - Version 47 passed review GS 3.16 3.18 3.20

2016-08-21 Activities Configurator - GS 3.16 3.18 3.20
           User requested to expand option of displaying the Activities Overview after
           login to include display the overview when no applications are running.
           The option now displays the overview after login and any time closing
           an application results in no running applications.

2016-08-23 Activities Configurator - GS 3.16 3.18 3.20
           Corrected false overview displays when running with Wayland.  Added
           time window to prevent check for no running apps if an app had been
           started in the past 2 seconds.  Problem occured only on some apps and
           only if starting first app from overview.

2016-08-23 Activities Configurator - uploaded for review

2016-08-24 Activities Configurator - found bug when running under Wayland
           I rejected version 48 before review.

2016-09-10 Changed overview show/no show logic to depend on:
           1.  Current state of overview.
           2.  No windows active.
           3.  App state change of STARTING or RUNNING.
           Removed time window hack.
           Tested running under Wayland and X11 for GS 3.21.90 and 3.21.91.
           Problems with Wayland appear to be solved.

2016-09-17 Activities Configurator - Version 49 passed review 
           GS 3.16 3.18 3.20 3.21.90 3.21.91 3.21.92

2016-09-25 Activities Configurator - Version 50 auto review
           GS 3.16 3.18 3.20 3.22 3.21.90 3.21.91 3.21.92

2016-11-01 Activities Configurator - added French translations thanks to narzb
           GS 3.16 3.18 3.20 3.22
           cosmetic change corrected inconsistent button display in prefs.js
           removed GS development versions from metadata.json
           uploaded for review

2016-11-23 Activities Configurator - updated copyright due to fsf address change
           Removed address and added license url instead. Uploaded for review.

2017-03-12 Activities Configurator - changed name of translation mo files
           requested by Andrew Toskin to avoid duplicate filenames when
           creating RPM packages for Fedora.  Removed empty css file.
           Uploaded for review.

2017-04-05 Activities Configurator - Un-needed imports removed from prefs.js
           and notify.js which caused errors in prefs.js for GS3.24. Updated
           to GS3.24.  Uploaded for review.

2017-05-21 Translations updated. Thanks to Jonatan Zeidler

2017-06-18 Added additonal defensive code for hidden corners.
           Uploaded for review.

2017-06-23 Translation correction. Thanks to Stéphane Roucheray.
           Uploaded for review.

2017-10-18 Added 3.26 to metadata.json

2017-11-11 Added detection of undefined Hot Corner

           The Hot Corner is required for proper operation of the Activities
           Configurator.  The Hot Corner can be undefined due to a conflict
           with another extension or a new global setting provided for
           Ubuntu version 17.10.  The Hot Corner is disabled by a patch
           provided in < https://bugzilla.gnome.org/show_bug.cgi?id=688320 >.
           The patch is not applied to the current upstream Gnome Shell
           at this time. The patch may be applied in a future release of the
           upstream shell.

           The following is specific to Ubuntu but can apply to any linux
           distribution which has been modified by the patch.

           Ubuntu 17.10 introduced the Gnome Shell as the desktop for Ubuntu.
           On initial install only the Ubuntu Session is available. The shell
           is modified to disable the shell's hot corners by not creating the
           hot corners in the default Ubuntu Session. The patch includes an
           addition of the global setting enable-hot-corners. As part of the
           Ubuntu developers' effort to provide an experience familiar to Unity
           users in the Ubuntu Session the setting is set false to disable
           the Activities Overview Hot Corner.

           A GNOME Session is available by installing the gnome-session package
           for Ubuntu.  In the Ubuntu GNOME Session the setting is set to true
           to enable the hot corners by their creation for the session.

           The gnome-tweak-tool (known also as "Tweaks" and "Tweak Tool")
           is modified in Ubuntu.  The global enable-hot-corners is exposed
           as Activities Overview Hot Corner in the Top Bar settings.
           Currently the modification is in the upstream repository but
           is commented out to be non-functional in the upstream Tweak Tool. 

           The Activities Configurator has been updated to be functional in the
           default Ubuntu Session.

           The action taken by the extension depends on four factors:

           F: Is the enable-hot-corners setting found?
           V: If found, what is the current setting value?
           C: Was the value changed?
           U: Is the hot corner undefined?

           ON = true
           OFF = false

           The extension detects if the setting enable-hot-corners exists.
           If the setting exists the extension gets the setting's value.

           Case 1.

           F = true V = true C = false U = false OR F = False U = False  

           If the setting enable-hot-corners exists and is set to ON and
           no change was required to the setting and the Hot Corner is not
           undefined, or setting enable-hot-corners does not exist and the
           Hot Corner is not undefined the extension takes no action.

           Case 2.

           F = true V = false C = false U = true

           If the setting enable-hot-corners is found OFF the extension sets
           enable-hot-corners to ON creating the hot corners and then disables
           the Hot Corner by setting the extension's local preference Disable
           Hot Corner to ON. 

           F = true V = true C = true U = false

           The extension informs the user of the actions.

           Case 3.

           F = true V = false C = false U = true

           The extension attempts to create the Hot Corners as in
           Case 2.

           F = true V true C = true U = true 

           The Hot Corners remain undefined. The user is alerted the Activities
           Configurator cannot function without the Hot Corner. The Hot Corner
           may not exist due to a conflict with another shell extension other
           software error.

           Case 4.

           F = False U = True

           Since the enable-hot-corners was not found and the Hot Corner is
           undefined the extension cannot take any action.  The Activities
           Configurator cannot function. A conflict with another extension
           is likely. 

           End of Cases.

           Clicking the right (secondary) button on the extension's icon
           or text will execute the gnome-shell-extension-prefs tool. The
           prefs tool provides access to the installed extensions for enable
           or disable and local preference setting. On the first execution of
           the tool selecting Activities Configurator preferences button
           sets all the extension's preferences to their default value.

           Note the default value for the Disable Hot Corner preference is
           OFF.

           If the user sets the global Activities Overview Hot Corner
           from OFF to ON during a Ubuntu Session with the Activities
           Configurator enabled the user is alerted by a message. If the
           user does not want to use the Activities Configurator, it
           should be disabled or removed.  If extension remains enabled,
           the extension will repeat the process described above of
           setting the global Activities Overview Hot Corner to OFF at
           the start of the next Ubuntu Session.

2017-11-12 Uploaded for review.

2017-11-18 Added Activities Button drag over for Wayland to allow mouse DND
           through the overview when Hot Corner is disabled.  The Super Key is
           not required to switch to the Overview.  Github acme-code issue
           #28. This update restores this ability which was broken in Wayland
           sessions.

2017-11-19 Uploaded for review.

2018-03-05 Merged feature to provide scaling of icon in preferences provided by
           dgmurx. Uploaded for review.

2018-04-14 Removed line 15 of prefs.js, "const Colors = Me.imports.colors;".
           Reported by jessedubord.  Ubuntu 18.04 beta 2, Gnome 3.28.
           Github issue #34 nls1729/acme-code. "There was an error loading the
           preferences dialog for Activities Configurator:" "Error: Requiring
           Clutter ..."  The import was no longer needed. In 2013 (version 16)
           functions provided by the import were replaced with a different set
           of functions.  The import should have been removed then.

2018-09-06 Fixed class names to be compatible with GS 3.30. Uploaded for review.

2018-10-03 Completed changes for ES6.
           Changed code to use arrow notation => instead of Lang.bind for anonymous
           functions. Changed code to use ES6 classes. Updated prefs.js to use GJS ES6
           class wrapper for GObject class. Changed to use Function.prototype.bind()
           instead of Lang.bind for named call backs.  Changed let and const to var for
           modules with symbols to be exported.  "....according to the ES6 standard.
           Any symbols to be exported from a module must be defined with 'var'." 

2018-10-08 For GS 3.30 changed max window effect to handle change of global.screen
           to global.display, changed workspace access from global.screen to
           global.workspace_manager, changed acess of signals from global.window_manager
           to Main.wm._shellwm.

2018-10-09 Uploaded for review.

2018-11-22 When logging in from a locked screen, the Window Maximized Effect opaque panel
           background preferences were ignored. The problem was fixed by moving enabling the
           Window Maximized Effect preferences to later in the delayed enable function.
           Also code was added to prevent the Show Overview If No Applications Are Running
           preference from being falsely activated when returning from a locked screen.
           Thanks to Micha Preußer for reporting the Window Maximized Effect issue.

2018-11-26 Uploaded for review.

2018-12-15 Added Tile Maximize Effect.  When tiling windows in native Gnome Shell two
           windows on the primary monitor will be adjacent to the panel.  If the panel
           has transparency applied the look is not good.  The Tile Maximize Effect
           applies the Window Maximize Effect of Opaque Background Color or Black Opaque
           Background to the panel if an option is selected.  The option to turn the
           Tile Maximized Effect Off in the preferences is provided in case of a conflict
           with an installed tiling extension. Thhftsinanks to Micha Preußer for reporting the
           tiling appearance issue.

2018-12-30 Uploaded for review.

2019-01-07 Found bug requiring an additional line of code to handle the
           Tile Maximized Effect Off option correctly.  Uploaded for review.

2019-01-17 Changed Tile Maximized Effect to remove panel transparency when a window is
           tiled on the primary monitor and a Window Maximized Effect preference is
           selected.

2019-03-08 Added diable-enable on monitor change to handle loss of diabled hot corner
           for laptop.  Changed Tile Maximized Effect to be more efficient.

2019-03-16 Thanks to rockon999 for his merge request that fixed Gnome Shell 3.32 issues
           for extension-reloader  It was helpful in updating activities-config.

2019-03-20 Changes for GS3.32 are not compatible with earlier versions. Changing
           metadata.json to reflect only version 3.32.  Added set and get methods to
           the ActivitiesIconButton GObject class to allow access to variables that
           are not visible to previous javascript.  Modified the previous javascript
           to use the get and set methods.  Added imports.misc.util to replace calls
           where the util code was previously accessible through main.js.  Increased
           delay for feature to move the ActivitiesIconButton from top left corner to
           top right corner.
           
2019-03-23 Removed un-needed "_( )" and added needed "_( )"for translations.  Now xgettext
           should find everything and gettext will not be executed when not needed.
           
2019-03-27 Uploaded for review update for GS 3.32.

2019-04-27 Removed disable enable on monitor change - not required.

2019-05-25 User reported unable to close a message concerning missing hot corners. POP OS 19.04
           is based on Ubuntu which has a patch applied to the shell which causes the missing
           hot corners.  Gnome Shell 3.32 aparently does not allow a reactive St.Bin which was
           used to close the message.  The St.Bin has been replaced with an St.Button to fix
           the problem.  See 2017-11-11 for all the details of the workaround for the patch.

2019-09-18 Version 3.34 of Gnome Shell removed access to extension version and shell version
           from access in prefs.js.  Usage of object.actor is deprecated.  Worked around
           access to extension version and shell version and corrected object.actor issues.

2019-09-20 GS3.34 is supported.  Uploaded for review.

2019-10-30 Ubuntu 19.10 included a change of the enable-hot-corners setting.  The setting
           was changed from global.settings to Gio settings org.gnome.desktop.interface.
           Added detection code for Gio settings.  Uploaded for review.

2019-11-05 Merged merge request from hftsin @ github.com.  Thanks to hftsin for his efforts.
           The activities-config extension has dependency on convenience.js, which
           is provided by gnome-shell-extension. However, the file convenience.js
           has been removed in gnome-shell-extension 3.34, which results an error
           on loading this extension.

2020-03-15 Updated Activities Configurator to GS 3.36. Uploaded for review.

2020-05-05 On disable for lock screen prevent showing "Activities" in session mode
           'unlock-dialog' due to changes in GS 3.36. Uploaded for review.

2020-07-05 When the screen is locked all enabled extensions are disabled.
           When the screen is unlocked the extensions are re-enabled.  To
           insure the Activities Configurator button is in the left-most
           corner of the panel where the Activities button normally resides
           a delay is provided. In the past the delay  was required for some
           functions of the Activities Configurator to operate properly.
           Now the Activities Configurator can operate if displaced by
           another extension. I received requests to be able to disable
           the 1.5 second delay before performing the enable because when
           unlocking the screen the delay was a distraction. A preference to
           disable the enable delay is now provided.

2020-08-02 Re-implemented the ability to drag through the hot corner when
           the hot corner is disabled in a Wayland session.
           Reviewing the journal I found "gnome-shell-extension-prefs is
           deprecated" messages produced by the Activities Configurator.
           gnome-shell-extension-prefs is replaced with gnome-extensions-app
           if it is installed or ExtensionUtils.openPrefs() if not. Added
           additonal logic to handle hot corner changes due to monitor
           changes.  Thanks to Jeremias Ortega for a pull request correcting
           an error in a timeout removal.  Uploaded for review.

2020-11-05 Changed prefs.js to get installed Gnome Shell version for display.
           This allows correct display of shell version on the preferences
           dialog when the extension change was to the shell versions in
           metadata.json.

...
zip file: 2020-11-05 12:23 aef3a9f1
