import { red, yellow, green, reset, cyan } from "@std/fmt/colors";

const HOSTS_FILE = "/etc/hosts";

const inputHosts: string[] = (Deno.env.get("hosts") ?? "")
    .split("\n")
    .filter((host) => host.trim().length > 0);

if (inputHosts.length === 0) {
    console.log(red("No hosts provided"));
    Deno.exit(1);
}

console.log()
console.log(`Editing ${cyan(HOSTS_FILE)}:`);

const hostsFileContentBefore = Deno.readTextFileSync(HOSTS_FILE);
for (const host of inputHosts) {
    if (hostsFileContentBefore.includes(host)) {
        console.log(yellow(`Host ${host} is already present in hosts file, skipping`));
        continue;
    }

    Deno.writeTextFileSync(HOSTS_FILE, `127.0.0.1 ${host}\n`, { append: true });
    console.log(green(`Blocked ${reset(host)}`));
}

console.log()
console.log(green("Hosts file updated."));
