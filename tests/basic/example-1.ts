var var1 = 10;
var1 = 20;
// @ts-expect-error
var1 = true;
var var2 = true;
var var3 = false;
var var4;
var var5 = 0.1;
var var6 = 0x10;
var var7 = 0o10;

let let1 = 10;
let1 = 20;
// @ts-expect-error
let1 = true;
let let2 = true;
let let3 = false;
let let4;
let let5 = 0.1;
let let6 = 0x10;
let let7 = 0o10;

const const1 = 10;
const const2 = true;
const const3 = false;
const const4 = 0.1;
const const6 = 0x10;
const const7 = 0o10;

// Comments

/*
 * Multi-line comment
 * with a line break
 */