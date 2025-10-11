const fs = require('fs');
const assert = require('assert');
const { spawnSync } = require('child_process');
const path = require('path');

const DEFINITION_PATH = path.resolve("./compiled");
const PARSER_TEST_DIR = path.resolve("./vendor/test262-parser-tests");

function parse(src, { isModule, earlyErrors }) {
    const result = spawnSync(
        "kparse",
        ["--definition", DEFINITION_PATH, '-'],
        { input: src, encoding: "utf8" }
    );
    if (result.status !== 0) {
        throw new Error(`Parser failed with status ${result.status}`);
    }
    return result;
}

function assertDoesNotThrow(fn) {
    try {
        fn();
    } catch (e) {
        return false;
    }
    return true;
}

function assertDoesThrow(fn) {
    try {
        fn();
    } catch (e) {
        return true;
    }
    return false;
}

let passExcludes = [];
let failExcludes = [];
let earlyExcludes = [];

let count = 0;
let failedCount = 0;
let passedCount = 0;
fs.readdirSync(`${PARSER_TEST_DIR}/pass`).filter(f => !passExcludes.includes(f)).forEach(f => {
    let firstTree, secondTree;
    // if (count > 1) process.exit(1);
    const source = fs.readFileSync(`${PARSER_TEST_DIR}/pass/${f}`, 'utf8');
    const ok = assertDoesNotThrow(() => {
        firstTree = parse(source, { isModule: f.match('.module.js'), earlyErrors: true });
    });

    if (ok) {
        console.log(`${f} passed`);
        passedCount++;
    } else {
        console.log(`${f} failed`);
        failedCount++;
    }
    count++;
    // assert.doesNotThrow(() => {
    //     firstTree = parse(
    //         fs.readFileSync(`${PARSER_TEST_DIR}/pass/${f}`, 'utf8'),
    //         { isModule: f.match('.module.js'), earlyErrors: true }
    //     );
    // });
    // assert.doesNotThrow(() => {
    //     secondTree = parse(
    //         fs.readFileSync(`${PARSER_TEST_DIR}/pass-explicit/${f}`, 'utf8'),
    //         { isModule: f.match('.module.js'), earlyErrors: true }
    //     );
    // });
    // assert.deepStrictEqual(firstTree, secondTree);
});

console.log(`Passed ${passedCount} tests, failed ${failedCount} tests`);

// fs.readdirSync(`${PARSER_TEST_DIR}/fail`).filter(f => !failExcludes.includes(f)).forEach(f => {
//     assert.throws(() => {
//         parse(
//             fs.readFileSync(`${PARSER_TEST_DIR}/fail/${f}`, 'utf8'),
//             { isModule: f.match('.module.js'), earlyErrors: false }
//         );
//     });
// });

// fs.readdirSync(`${PARSER_TEST_DIR}/early`).filter(f => !earlyExcludes.includes(f)).forEach(f => {
//     // assert.doesNotThrow(() => {
//     //     parse(
//     //         fs.readFileSync(`early/${f}`, 'utf8'),
//     //         { isModule: f.match('.module.js'), earlyErrors: false }
//     //     );
//     // });
//     assert.throws(() => {
//         parse(
//             fs.readFileSync(`${PARSER_TEST_DIR}/early/${f}`, 'utf8'),
//             { isModule: f.match('.module.js'), earlyErrors: true }
//         );
//     });
// });