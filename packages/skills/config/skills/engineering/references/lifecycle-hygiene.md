---
name: lifecycle-hygiene
description: Apply when writing or changing a long-running service or worker - startup, shutdown, background tasks, consumers, health and readiness probes, or handling of dependencies such as databases and message brokers that can go away.
---

# Lifecycle hygiene

A long-running service fails in ways a request handler does not. A background
task dies and the process keeps running, a database goes down for maintenance
and the workers never recover, a probe reports healthy while nothing is being
processed. These failures stay invisible in tests and surface in production.

- A background task never dies silently. When it fails, it restarts with
  backoff or takes the service down. Decide which, per task.
- A dependency outage pauses work with backoff, and the service resumes on its
  own once the dependency is back. No manual restart.
- Readiness reflects whether the service can do its actual job, including the
  dependencies and tasks that job needs. A listening port or a metrics
  endpoint is not proof of that.
- Shutdown is idempotent and releases every resource the service opened:
  tasks, consumers, clients, and connections.
