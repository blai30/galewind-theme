// TypeScript sample for syntax highlighting
import { readFile } from "node:fs/promises";

/**
 * Represents a parsed configuration entry.
 */
export interface ConfigEntry<TValue = string> {
  readonly key: string;
  value: TValue;
  tags?: string[];
}

export enum LogLevel {
  Debug = 0,
  Info = 1,
  Warn = 2,
  Error = 3,
}

const DEFAULT_TIMEOUT = 3_000;
const HEX_PATTERN = /^#(?:[0-9a-f]{3}|[0-9a-f]{6})$/i;

function logged(level: LogLevel) {
  return function decorate(target: unknown, propertyKey: string): void {
    console.log(`registering ${propertyKey} at level ${level}`);
  };
}

export class ConfigStore {
  private readonly entries = new Map<string, ConfigEntry>();

  @logged(LogLevel.Info)
  set(key: string, value: string, ...tags: string[]): this {
    this.entries.set(key, { key, value, tags });
    return this;
  }

  get = (key: string): string | undefined => this.entries.get(key)?.value;

  *[Symbol.iterator](): IterableIterator<ConfigEntry> {
    yield* this.entries.values();
  }
}

async function loadConfig(path: string): Promise<ConfigStore> {
  const store = new ConfigStore();
  const raw = await readFile(path, "utf8");
  for (const line of raw.split("\n")) {
    const [key, value] = line.split("=");
    if (key && value && !HEX_PATTERN.test(value)) {
      store.set(key.trim(), value.trim());
    }
  }
  return store;
}

loadConfig("./app.conf")
  .then((store) => console.table([...store]))
  .catch((error: unknown) => console.error("failed", error));
