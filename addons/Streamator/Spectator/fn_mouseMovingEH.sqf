#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    MouseMoving event handler for the spectator

    Parameter(s):
    0: Display <Display> (Default: displayNull)
    1: DeltaX <Number> (Default: 0)
    2: DeltaY <Number> (Default: 0)

    Returns:
    None
*/

params [
    ["_display", displayNull, [displayNull]],
    ["_deltaX", 0, [0]],
    ["_deltaY", 0, [0]]
];
private _fov_factor = (GVAR(CameraPreviousState) param [4, GVAR(CameraFOV)]) / 0.75;
private _pitch = GVAR(CameraPreviousState) param [3, GVAR(CameraPitch) +  GVAR(CameraPitchOffset)];
private _dir = GVAR(CameraPreviousState) param [2, GVAR(CameraDir) +  GVAR(CameraDirOffset)];

if (GVAR(CameraOffsetMode)) then {
    GVAR(CameraDirOffset) = GVAR(CameraDirOffset) + _deltaX * 0.5 * _fov_factor;
    GVAR(CameraPitchOffset) = -89.0 max (89.9 min (GVAR(CameraPitchOffset) - _deltaY * 0.5* _fov_factor));

    GVAR(CameraDirOffset) = ((((GVAR(CameraDirOffset) - _dir + 180) mod 360) - 180) min 90) max -90;
    GVAR(CameraPitchOffset) = ((((GVAR(CameraPitchOffset) - _pitch + 180) mod 360) - 180) min 90) max -90;
    GVAR(CameraDirOffset) = GVAR(CameraDirOffset) + _dir;
    GVAR(CameraPitchOffset) = GVAR(CameraPitchOffset) + _pitch;
} else {
    GVAR(CameraDir) = GVAR(CameraDir) + _deltaX * 0.5 * _fov_factor;
    GVAR(CameraPitch) = -89.0 max (89.9 min (GVAR(CameraPitch) - _deltaY * _fov_factor));

    GVAR(CameraDir) = ((((GVAR(CameraDir) - _dir + 180) mod 360) - 180) min 90) max -90;
    GVAR(CameraPitch) = ((((GVAR(CameraPitch) - _pitch + 180) mod 360) - 180) min 90) max -90;
    GVAR(CameraDir) = GVAR(CameraDir) + _dir;
    GVAR(CameraPitch) = GVAR(CameraPitch) + _pitch;
};