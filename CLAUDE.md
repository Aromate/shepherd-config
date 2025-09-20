# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a GNU Shepherd configuration directory located at `~/.config/shepherd/`. Shepherd is a service manager (init system) that manages system and user services, primarily used with GNU Guix but also available as a standalone daemon.

## Key Files

- `init.scm`: Main Shepherd configuration file written in Guile Scheme. Defines services and their startup behavior.

## Common Commands

### Service Management
```bash
# Check status of all services
herd status

# Start a service
herd start SERVICE_NAME

# Stop a service
herd stop SERVICE_NAME

# Restart a service
herd restart SERVICE_NAME

# View service logs (last N lines)
herd log SERVICE_NAME -n 20
```

### Shepherd Control
```bash
# Reload configuration without restarting
herd reload root

# Check Shepherd version
shepherd --version

# Run shepherd in foreground (for debugging)
shepherd -c init.scm --foreground
```

## Configuration Structure

The `init.scm` file follows this pattern:
1. Service definitions using `(service ...)` forms
2. Service registration via `(register-services ...)`
3. Daemonization setup
4. Auto-start service list in `(start-in-the-background ...)`

Services are defined using Guile Scheme and can specify:
- Service dependencies
- Start/stop procedures
- Respawn behavior
- Environment variables
- Working directories

## Development Notes

- All configuration is in Guile Scheme (`.scm` files)
- Services run as the current user unless specified otherwise
- Shepherd socket is typically at `/run/user/$(id -u)/shepherd/socket`
- Test configuration changes with `shepherd -c init.scm --foreground` before applying