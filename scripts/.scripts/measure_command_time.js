const { spawn } = require('child_process');
const fs = require('fs');

const command = process.argv[2];
const logMessage = process.argv[3];

const startTime = Date.now();

const child = spawn(command, [], { shell: true });

child.stdout.on('data', (data) => {
  process.stdout.write(data);
  if (data.includes(logMessage)) {
    const endTime = Date.now();
    console.log(`\nTime elapsed: ${(endTime - startTime) / 1000} seconds`);
    process.exit(0);
  }
});

child.stderr.on('data', (data) => {
  process.stderr.write(data);
});

child.on('close', (code) => {
  const endTime = Date.now();
  console.log(`\nCommand exited with code ${code}`);
  console.log(`Total time elapsed: ${(endTime - startTime) / 1000} seconds`);
});
