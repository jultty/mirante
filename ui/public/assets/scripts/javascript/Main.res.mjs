// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Status from "./Status.res.mjs";
import * as Browser from "./Browser.res.mjs";
import * as Structure from "./Structure.res.mjs";

function main() {
  Structure.main();
  Browser.listenFromWindow(window, "load", Status.setStatus);
}

main();

export {
  main ,
}
/*  Not a pure module */
