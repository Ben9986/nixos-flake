const { GLib } = imports.gi;
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import { SimpleToggleButton } from "../ToggleButton"


const bluetooth = await Service.import("bluetooth")

const IdleButton = Widget.Button({
  child: Widget.Label("idle"),
  onClicked: () => Utils.subprocess('matcha')

})
export const ModuleIdleInhibitor = () => Widget.Button({ // TODO: Make this work
    attribute: {
        enabled: false,
        inhibitor: undefined,
    },
    className: 'txt-small sidebar-iconbutton',
    tooltipText: 'Keep system awake',
    onClicked: (self) => {
        self.attribute.enabled = !self.attribute.enabled;
        self.toggleClassName('sidebar-button-active', self.attribute.enabled);
        if (self.attribute.enabled) {
            self.attribute.inhibitor = Utils.subprocess(
                [`${App.configDir}/lib/wayland-idle-inhibitor.py`],
                (output) => print(output),
                (err) => logError(err),
                self,
            );
        }
        else {
            self.attribute.inhibitor.force_exit();
        }
    },
    child: Widget.Label("idle"),
    // setup: setupCursorHover,
});
