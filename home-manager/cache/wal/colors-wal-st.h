const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#0c0d15", /* black   */
  [1] = "#E06564", /* red     */
  [2] = "#F29271", /* green   */
  [3] = "#55618B", /* yellow  */
  [4] = "#B97390", /* blue    */
  [5] = "#7783A9", /* magenta */
  [6] = "#A68BB1", /* cyan    */
  [7] = "#ebc4cb", /* white   */

  /* 8 bright colors */
  [8]  = "#a4898e",  /* black   */
  [9]  = "#E06564",  /* red     */
  [10] = "#F29271", /* green   */
  [11] = "#55618B", /* yellow  */
  [12] = "#B97390", /* blue    */
  [13] = "#7783A9", /* magenta */
  [14] = "#A68BB1", /* cyan    */
  [15] = "#ebc4cb", /* white   */

  /* special colors */
  [256] = "#0c0d15", /* background */
  [257] = "#ebc4cb", /* foreground */
  [258] = "#ebc4cb",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
