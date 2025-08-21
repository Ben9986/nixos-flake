static const char norm_fg[] = "#ebc4cb";
static const char norm_bg[] = "#0c0d15";
static const char norm_border[] = "#a4898e";

static const char sel_fg[] = "#ebc4cb";
static const char sel_bg[] = "#F29271";
static const char sel_border[] = "#ebc4cb";

static const char urg_fg[] = "#ebc4cb";
static const char urg_bg[] = "#E06564";
static const char urg_border[] = "#E06564";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
