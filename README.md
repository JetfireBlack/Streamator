# STREAMATOR
A spectator mod for Arma 3.

# Users Manual
## CAMERA MODE
The camera mode is shown on the top right.

Mode | Description
---|---
**FREE** | Free movement of the camera.
**FOLLOW [&lt;Object&gt;]** | The camera is moving relatively to a focussed object.<br>***Special Remarks:***<br>If the &lt;Object&gt; is a spectator, the current camera state (position, view angle etc.) of the focussed spectator is transferred to your camera. To limit network traffic, this is done only at the moment of focussing. It can be refreshed by pressing the R key.

## 3D VIEW
Key Binding | Short Description | Remarks
---|---|---
**`W` `S` `A` `D`** | Horiz. movement |
**`Q` `Y`** | Vert. movement |
**`F`** | (De-)focus object | Changes the camera mode to FOLLOW. The current camera target (shown on the bottom) will be the focussed object. If no object is selected (camera target = Null Object), the camera mode will change to FREE.
**`CTRL`** + **`F`** | Find object | Opens a search field with completion. All alive units and spectators are searchable. The selected object in the completion list can be cycled by pressing **`TAB`** (right) and **`SHIFT`**+**`TAB`** (left). With ENTER the selected object will be the focussed object in FOLLOW mode.
**`ALT`** + **`F`** | last Shooting Unit | Changes the FOLLOW Target to the last Shooting Unit
**`R`** | Refocus object | Only in FOLLOW Mode! Refocus (center) the camera to the current focussed object. If a spectator is selected, the current camera state (position, view angle etc.) is transferred to your camera.
**`SHIFT`** + **`Scrollwheel`** | Change Speed | Changes the Speed of the Camera.
**`CTRL`** + **`Scrollwheel`** | Change Smoothing | Changes the camera smoothing coefficient.
**`ALT`** + **`Scrollwheel`** | Change FOV | Changes the field of view (zoom).
**`TAB`** | Resets FOV | Resets the field of View
**`N`** | Vision mode | Cycles the vision mode (IR/NV with different color schemes)
**`F1`** | Toggle Group Markers | Toggles the visibility of group marker.
**`F2`** | Toggle Unit Marker | Toggles the visibility of unit marker and names.
**`F3`** | Toggle Custom Marker | Toggles the visibility of custom Marker, defined by mission creator.
**`F5`** | Toggle Unit Chyron | Toggles Chyron for the current Unit
**`F6`** | Toggle Planing Mode Icons and Markers | Toggle Planing Mode Icons and Markers from other spectators
**`CTRL`** + **`0`**...**`9`** | Save camera state | Saves the current camera state (position, view angle, mode, camera target etc.) to a slot (0...9)
**`0`**...**`9`** | Restore camera state | Restores camara state. See Save camera state
**`M`** | Open Map | Opens the map. (see Map View)
**`CTRL`** + **`E`** | Toggle Planing Mode | Toggles Planing Mode and shows Cursor
**`PAGE UP`** | Increase Planning Mode Channel | Increase Planning Mode Channel
**`PAGE DOWN`** | Decrease Planning Mode Channel | Decrease Planning Mode Channel
**`LMB`** | Drawing in Planning Mode | Drawing in Planning Mode

## MAP VIEW
Key Binding | Short Description | Remarks
---|---|---
**`M`** | Close map | Closes the map view.
**`ALT`** + **`LMB`** | Move camera | Moves the camera to the clicked position
**`LMB`** (Dbl. Click) on Marker | Focus Unit/Vehicle | Focusses a unit or vehicle.
Hover Marker | Shows unit/group/vehicle information | units: unit name<br>groups: ID and group members<br>Vehicles: type and units<br>
**`CTRL`** + **`E`** | Toggle Planing Mode | Toggles Planing Mode and shows Cursor
**`PAGE UP`** | Increase Planning Mode Channel | Increase Planning Mode Channel
**`PAGE DOWN`** | Decrease Planning Mode Channel | Decrease Planning Mode Channel
**`LMB`** | Drawing in Planning Mode | Drawing in Planning Mode

# Creators Manual
TBD
