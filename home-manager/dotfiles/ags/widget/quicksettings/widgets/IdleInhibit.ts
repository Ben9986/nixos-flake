import { SimpleToggleButton } from "../ToggleButton"
import icons from "lib/icons"

var status = false;

const setIdle = (self) => {
	status = !status;
    Utils.exec('matcha -t');
    self.toggleClassName("active", status);
};

export const IdleButton = () => Widget.Button({
    on_clicked: self => setIdle(self),
    class_name: "simple-toggle",
    child: Widget.Box([
        Widget.Icon({
         icon: "local-cafe",
        }),
        Widget.Label({
            max_width_chars: 10,
            truncate: "end",
            label: "Toggle Idle",
        }),
    ]),
})
