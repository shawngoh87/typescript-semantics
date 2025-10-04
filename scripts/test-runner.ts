#!/usr/bin/env ts-node
import { readdir } from "fs/promises";
import path from "path";
import os from "os";
import { spawn } from "child_process";

// Simple CLI arg parsing for --concurrency or -c
function getConcurrencyFromArgs(): number {
	const args = process.argv.slice(2);
	const defaultConcurrency = Math.max(1, Math.min(8, os.cpus().length));
	let concurrency = defaultConcurrency;

	for (let i = 0; i < args.length; i++) {
		const arg = args[i];
		if (arg === "--concurrency" || arg === "-c") {
			const val = args[i + 1];
			if (val && !val.startsWith("-")) {
				const parsed = Number(val);
				if (Number.isInteger(parsed) && parsed > 0) {
					concurrency = parsed;
					i += 1;
					continue;
				}
			}
			console.warn(
				`Invalid concurrency value after ${arg}; using ${defaultConcurrency}`,
			);
		} else if (arg.startsWith("--concurrency=")) {
			const [, val] = arg.split("=");
			const parsed = Number(val);
			if (Number.isInteger(parsed) && parsed > 0) {
				concurrency = parsed;
			} else {
				console.warn(`Invalid concurrency value; using ${defaultConcurrency}`);
			}
		}
	}
	return concurrency;
}

type RunResult = { exitCode: number; stdout: string; stderr: string };

async function runCommand(
	command: string,
	args: string[],
	options: { inherit?: boolean } = {},
): Promise<RunResult> {
	return new Promise((resolve, reject) => {
		const useInherit = options.inherit === true;
		const child = spawn(command, args, {
			stdio: useInherit ? "inherit" : "pipe",
		});
		let stdout = "";
		let stderr = "";
		if (!useInherit) {
			child.stdout?.on("data", (chunk: Buffer | string) => {
				stdout += chunk.toString();
			});
			child.stderr?.on("data", (chunk: Buffer | string) => {
				stderr += chunk.toString();
			});
		}
		child.on("close", (code) => {
			resolve({ exitCode: code || 0, stdout, stderr });
		});
		child.on("error", (err) => {
			reject(err);
		});
	});
}

async function kompile(): Promise<void> {
	console.log("[1/2] Running kompile...");
	const { exitCode } = await runCommand(
		"kompile",
		["src/ts-main.k", "--output-definition", "compiled"],
		{ inherit: true },
	);
	if (exitCode !== 0) {
		throw new Error("kompile failed");
	}
	console.log("Kompile successful.\n");
}

async function findBasicTests(): Promise<string[]> {
	const testsDir = path.join(process.cwd(), "tests", "basic");
	const entries = await readdir(testsDir, { withFileTypes: true });
	const files = entries
		.filter((e) => e.isFile() && e.name.endsWith(".ts"))
		.map((e) => path.join(testsDir, e.name))
		.sort((a, b) => a.localeCompare(b));
	return files;
}

async function runKrun(testFile: string): Promise<number> {
	const fileName = path.basename(testFile);
	console.log(`Testing: ${fileName}`);
	const { exitCode, stdout, stderr } = await runCommand("krun", [
		"--definition",
		"compiled",
		testFile,
	]);
	if (stdout.trim().length > 0) {
		console.log(`Completed: ${fileName}`);
		console.log(stdout.trim());
	}
	if (stderr.trim().length > 0) {
		console.log(`Error: ${fileName}`);
		console.error(stderr.trim());
	}
	return exitCode;
}

async function runWithConcurrency<T>(
	tasks: Array<() => Promise<T>>,
	limit: number,
): Promise<T[]> {
	const results: T[] = [];
	let nextIndex = 0;

	async function worker() {
		while (true) {
			const current = nextIndex++;
			if (current >= tasks.length) return;
			const res = await tasks[current]();
			results[current] = res;
		}
	}

	const workers = Array.from({ length: Math.max(1, limit) }, () => worker());
	await Promise.all(workers);
	return results;
}

async function main() {
	const concurrency = getConcurrencyFromArgs();
	await kompile();

	const testFiles = await findBasicTests();
	if (testFiles.length === 0) {
		console.log("No tests found in tests/basic");
		return;
	}
	console.log(
		`[2/2] Running ${testFiles.length} test(s) with concurrency ${concurrency}...`,
	);

	const tasks = testFiles.map((file) => () => runKrun(file));
	const exitCodes = await runWithConcurrency(tasks, concurrency);

	const failures = exitCodes.filter((code) => code !== 0).length;
	if (failures > 0) {
		console.error(`\n${failures} test(s) failed.`);
		process.exit(1);
	}
	console.log("\nAll tests passed.");
}

// Node.js child_process for running subprocesses

main().catch((err) => {
	console.error(err instanceof Error ? err.message : err);
	process.exit(1);
});
