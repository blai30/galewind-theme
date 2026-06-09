// JavaScript sample exercising JS-specific token scopes
const EventEmitter = require("node:events");

const PRIORITIES = Object.freeze({ low: 0, normal: 1, high: 2 });

class TaskQueue extends EventEmitter {
  #pending = [];

  constructor(concurrency = 4) {
    super();
    this.concurrency = concurrency;
    this.active = 0;
  }

  enqueue(task, { priority = PRIORITIES.normal } = {}) {
    this.#pending.push({ task, priority });
    this.#pending.sort((left, right) => right.priority - left.priority);
    this.emit("enqueued", task);
    this.#drain();
    return this;
  }

  async #drain() {
    while (this.active < this.concurrency && this.#pending.length > 0) {
      const { task } = this.#pending.shift();
      this.active += 1;
      try {
        const result = await task();
        this.emit("done", result);
      } catch (error) {
        this.emit("error", error);
      } finally {
        this.active -= 1;
      }
    }
  }
}

const slugify = (text) =>
  text
    .toLowerCase()
    .replace(/[^\w\s-]/g, "")
    .replace(/\s+/g, "-");

const queue = new TaskQueue(2);
queue.on("done", (value) => console.log(`finished: ${value}`));

for (const name of ["alpha", "beta", "gamma"]) {
  queue.enqueue(async () => slugify(`Build ${name} #1`));
}

module.exports = { TaskQueue, slugify, PRIORITIES };
