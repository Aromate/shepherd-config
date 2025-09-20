# GNU Shepherd User Service Configuration

Personal configuration for GNU Shepherd service manager.

## Structure

```
.
├── init.scm           # Main configuration file
├── services/          # Service definitions
│   └── dbus.scm      # D-Bus session bus service
├── CLAUDE.md         # Documentation for Claude AI assistant
└── README.md         # This file
```

## Usage

Start Shepherd with this configuration:

```bash
shepherd -c ~/.config/shepherd/init.scm
```

Check service status:

```bash
herd status
herd status dbus-session
```

## Services

### D-Bus Session
- Manages the D-Bus session bus
- Auto-restarts on failure
- Logs to `$XDG_RUNTIME_DIR/shepherd/dbus.log`

## Adding New Services

1. Create a new service file in `services/` directory
2. Add the filename to the load list in `init.scm`
3. Optionally add to auto-start list in `init.scm`

## Requirements

- GNU Shepherd 1.0.4+
- GNU Guile 3.0+
- D-Bus (for D-Bus service)