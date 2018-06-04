#include "macros.hpp"
/*
    Streamator

    Author: BadGuy

    Description:
    KeyDown-EH for the Spectator

    Parameter(s):
    0: Display <Display> (Default: displayNull)
    1: KeyCode <Number> (Default: 0)
    2: ShiftPressed <Bool> (Default: false)
    3: CtrlPressed <Bool> (Default: false)
    4: AltPressed <Bool> (Default: false)

    Returns:
    Event handled <Bool>
*/

#define SAVERESTORE(slot) if (GVAR(InputMode) > 0) exitWith {false}; \
if (_ctrl) then { \
[slot] call FUNC(savePosition); \
} else { \
[slot] call FUNC(restorePosition); \
}

params [
    "",
    ["_keyCode", 0, [0]],
    ["_shift", false, [true]],
    ["_ctrl", false, [true]],
    ["_alt", false, [true]]
];

private _return = switch (_keyCode) do {
    case DIK_M: { // M: Map
        if (GVAR(InputMode) > 0) exitWith {false};

        private _mapDisplay = uiNamespace getVariable [QGVAR(MapDisplay), displayNull];
        if (isNull _mapDisplay) then {
            _mapDisplay = (findDisplay 46) createDisplay "RscDisplayEmpty";
            uiNamespace setVariable [QGVAR(MapDisplay), _mapDisplay];
            (_mapDisplay displayCtrl 1202) ctrlSetFade 1;
            (_mapDisplay displayCtrl 1202) ctrlCommit 0;

            private _map = _mapDisplay ctrlCreate ["RscMapControl", -1];
            _map ctrlSetPosition [safeZoneX + PX(BORDERWIDTH), safeZoneY + PY(BORDERWIDTH), safeZoneW - PX(2 * BORDERWIDTH), safeZoneH - PY(2 * BORDERWIDTH)];
            _map ctrlCommit 0;

            GVAR(MapOpen) = true;
            QGVAR(updateInput) call CFUNC(localEvent); // hijack To Update Text on Map Open
            GVAR(MapState) params [["_zoom", 1], ["_position", getPos CLib_player]];

            _map ctrlMapAnimAdd [0, _zoom, _position];
            ctrlMapAnimCommit _map;

            [_map] call CFUNC(registerMapControl);
            _mapDisplay displayAddEventHandler ["KeyDown", {
                params ["_display", "_keyCode"];
                switch (_keyCode) do {
                    case DIK_ESCAPE;
                    case DIK_M: { // M
                        _display closeDisplay 1;
                        true
                    };
                    default {
                        true;
                    };
                };
            }];

            _map ctrlAddEventHandler ["MouseButtonClick", {
                params ["_map", "", "_xpos", "_ypos", "", "", "_alt"];
                if (_alt) then {
                    private _pos = _map ctrlMapScreenToWorld [_xpos, _ypos];
                    _pos pushBack (((getPos GVAR(Camera)) select 2) + getTerrainHeightASL _pos);
                    private _prevUnit = GVAR(CameraFollowTarget);
                    GVAR(CameraFollowTarget) = objNull;
                    GVAR(CameraMode) = 1;
                    GVAR(CameraPos) = _pos;
                    GVAR(CameraPreviousState) = [];
                    [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
                    [QGVAR(CameraTargetChanged), [objNull, _prevUnit]] call CFUNC(localEvent);
                    true;
                } else {false};
            }];

            _map ctrlAddEventHandler ["Destroy", {
                params ["_map"];
                [_map] call CFUNC(unregisterMapControl);
                private _pos = _map ctrlMapScreenToWorld [0.5, 0.5];
                private _zoom = ctrlMapScale _map;
                GVAR(MapState) = [_zoom, _pos];
                GVAR(MapOpen) = false;
                QGVAR(updateInput) call CFUNC(localEvent); // hijack To Update Text on Map Open

            }];
        } else {
            _mapDisplay closeDisplay 1;
        };

        true
    };
    case DIK_F: { // F
        if (GVAR(InputMode) > 0) exitWith {false};
        if (_ctrl) exitWith {
            GVAR(InputMode) = 1;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true
        };
        if (_alt && !isNull GVAR(lastUnitShooting)) exitWith {
            [GVAR(lastUnitShooting), true] call FUNC(setCameraTarget);
            true
        };
        if (!isNull GVAR(CursorTarget) && {GVAR(CursorTarget) isKindOf "AllVehicles" && {!(GVAR(CursorTarget) isEqualTo GVAR(CameraFollowTarget))}}) then {
            private _prevUnit = GVAR(CameraFollowTarget);
            GVAR(CameraFollowTarget) = GVAR(CursorTarget);
            GVAR(CameraRelPos) = getPosASLVisual GVAR(Camera) vectorDiff getPosASLVisual GVAR(CameraFollowTarget);
            GVAR(CameraMode) = 2;
            [QGVAR(CameraTargetChanged), [objNull, _prevUnit]] call CFUNC(localEvent);
            [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
        } else {
            private _prevUnit = GVAR(CameraFollowTarget);
            GVAR(CameraFollowTarget) = objNull;
            GVAR(CameraMode) = 1;
            [QGVAR(CameraTargetChanged), [objNull, _prevUnit]] call CFUNC(localEvent);
            [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
            true
        };
    };
    case DIK_LSHIFT: { // LShift
        if (GVAR(InputMode) > 0) exitWith {false};
        GVAR(CameraSpeedMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        false
    };
    case DIK_LCONTROL: { // LCTRL
        if (GVAR(InputMode) > 0) exitWith {false};
        GVAR(CameraSmoothingMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        false
    };
    case DIK_LALT: { // LCTRL
        if (GVAR(InputMode) > 0) exitWith {false};
        GVAR(CameraZoomMode) = true;
        QGVAR(hightlightModeChanged) call CFUNC(localEvent);
        false
    };
    case DIK_ESCAPE: { // ESC
        if (GVAR(InputMode) > 0) exitWith {
            GVAR(InputMode) = 0;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true
        };
        false
    };
    case DIK_TAB: { // TAB
        if (GVAR(InputMode) > 0) exitWith {
            GVAR(InputGuessIndex) = GVAR(InputGuessIndex) + ([1, -1] select _shift);
            if (GVAR(InputGuessIndex) < 0) then {
                GVAR(InputGuessIndex) = count GVAR(InputGuess) - 1;
            };
            if (GVAR(InputGuessIndex) >= count GVAR(InputGuess)) then {
                GVAR(InputGuessIndex) = 0;
            };
            [QGVAR(updateInput)] call CFUNC(localEvent);
            true
        };
        GVAR(CameraFOV) = 0.75;
        QGVAR(CameraFOVChanged) call CFUNC(localEvent);
        true
    };
    case DIK_RETURN: { // RETURN
        if (GVAR(InputMode) == 1) exitWith {
            if !(GVAR(InputGuess) isEqualTo []) then {
                private _target = ((GVAR(InputGuess) select GVAR(InputGuessIndex)) select 1);
                if (_target isEqualType []) then {
                    _target params ["_target", "_targetDistance", "_targetHeight"];

                    if (_target isEqualType objNull) then {
                        private _distance = _target distance ([getPos GVAR(Camera), getPos GVAR(CameraFollowTarget)] select (isNull GVAR(CameraFollowTarget)));
                        [_target, (_distance-_targetDistance) > 300] call FUNC(setCameraTarget);

                        GVAR(CameraRelPos) set [2, 0];
                        GVAR(CameraRelPos) = (vectorNormalized GVAR(CameraRelPos)) vectorMultiply _targetDistance;
                        GVAR(CameraRelPos) set [2, _targetHeight];
                        GVAR(CameraPitch) = -(GVAR(CameraRelPos) select 2) atan2 vectorMagnitude GVAR(CameraRelPos);
                        GVAR(CameraDir) = -(GVAR(CameraRelPos) select 0) atan2 -(GVAR(CameraRelPos) select 1);
                    } else {
                        private _pos = [0,0,0];
                        if (_target isEqualType "") then {
                            _pos = AGLToASL getMarkerPos _target;
                        };

                        if (_target isEqualType []) then {
                            _pos = AGLToASL _target;
                        };

                        private _diffVect = getPosASLVisual GVAR(Camera) vectorDiff _pos;
                        _diffVect set [2, 0];
                        GVAR(CameraPos) = _pos vectorAdd ((vectorNormalized _diffVect) vectorMultiply _targetDistance);
                        GVAR(CameraPos) set [2, _targetHeight];
                        if ((GVAR(CameraPos) distance getPos GVAR(Camera)) > 300) then {
                            GVAR(CameraPreviousState) = [];
                        };

                        GVAR(CameraPos) = AGLToASL GVAR(CameraPos);

                        _diffVect =  getPosASL GVAR(Camera) vectorDiff _pos;

                        GVAR(CameraPitch) = -(_diffVect select 2) atan2 vectorMagnitude _diffVect;
                        GVAR(CameraDir) = -(_diffVect select 0) atan2 -(_diffVect select 1);



                        if (GVAR(CameraMode) != 1) then {
                            private _prevUnit = GVAR(CameraFollowTarget);
                            GVAR(CameraFollowTarget) = objNull;
                            GVAR(CameraMode) = 1;
                            [QGVAR(CameraTargetChanged), [objNull, _prevUnit]] call CFUNC(localEvent);
                            [QGVAR(CameraModeChanged), GVAR(CameraMode)] call CFUNC(localEvent);
                        };

                    };

                } else {
                    private _distance = _target distance ([getPos GVAR(Camera), getPos GVAR(CameraFollowTarget)] select (isNull GVAR(CameraFollowTarget)));
                    [_target, _distance > 300] call FUNC(setCameraTarget);
                }

            };

            GVAR(InputMode) = 0;
            [QGVAR(InputModeChanged), GVAR(InputMode)] call CFUNC(localEvent);
            true
        };
    };
    case DIK_BACKSPACE: { // BACKSPACE
        if (GVAR(InputMode) > 0) exitWith {GVAR(InputMode) == 0};
        QGVAR(toggleUI) call CFUNC(localEvent);
        true;
    };
    case DIK_F1: { // F1
        GVAR(OverlayGroupMarker) = !GVAR(OverlayGroupMarker);
        QGVAR(updateInput) call CFUNC(localEvent);
        true
    };
    case DIK_F2: { // F2
        GVAR(OverlayUnitMarker) = !GVAR(OverlayUnitMarker);
        QGVAR(updateInput) call CFUNC(localEvent);
        true
    };
    case DIK_F3: { // F3
        GVAR(OverlayCustomMarker) = !GVAR(OverlayCustomMarker);
        QGVAR(updateInput) call CFUNC(localEvent);
        true
    };
    case DIK_F5: { // F3
        if (!isNull GVAR(CameraFollowTarget)) then {
            if (GVAR(UnitInfoOpen)) then {
                QGVAR(CloseUnitInfo) call CFUNC(localEvent);
            } else {
                [QGVAR(OpenUnitInfo), GVAR(CameraFollowTarget)] call CFUNC(localEvent);
            };
        } else {
            QGVAR(CloseUnitInfo) call CFUNC(localEvent);
        };

        true
    };
    case DIK_N: { // N
        if (GVAR(InputMode) > 0) exitWith {false};
        GVAR(CameraVision) = (GVAR(CameraVision) + 1) mod 10;
        call FUNC(setVisionMode);
        true
    };

    case DIK_1;
    case DIK_2;
    case DIK_3;
    case DIK_4;
    case DIK_5;
    case DIK_6;
    case DIK_7;
    case DIK_8;
    case DIK_9;
    case DIK_0: {
        SAVERESTORE(_keyCode);
        true;
    };

    case DIK_R: {
        if !(isNull GVAR(CameraFollowTarget)) exitWith {
            private _distance = (GVAR(CameraFollowTarget) distance getPos GVAR(Camera));
            [GVAR(CameraFollowTarget), _distance > 300] call FUNC(setCameraTarget);
            true
        };
        false
    };

    default {
        false
    };
};

if (!_return && GVAR(InputMode) > 0) then {
    private _char = [_keyCode, _shift] call FUNC(dik2char);
    if (_char != "") then {
        GVAR(InputScratchpad) = GVAR(InputScratchpad) + _char;
        QGVAR(updateGuess) call CFUNC(localEvent);
        QGVAR(updateInput) call CFUNC(localEvent);
        _return = true;
    } else {
        if (_keyCode == DIK_BACKSPACE) then { // BACKSPACE
            GVAR(InputScratchpad) = GVAR(InputScratchpad) select [0, count GVAR(InputScratchpad) - 1];
            QGVAR(updateGuess) call CFUNC(localEvent);
            QGVAR(updateInput) call CFUNC(localEvent);
            _return = true;
        };
    };
};

_return
